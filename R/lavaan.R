#' @templateVar class lavaan
#' @template title_desc_tidy
#'
#' @param x A `lavaan` object, such as those returned from [lavaan::cfa()],
#'   and [lavaan::sem()].
#'
#' @template param_confint
#'
#' @param ... Additional arguments passed to [lavaan::parameterEstimates()].
#'   **Cautionary note**: Misspecified arguments may be silently ignored.
#'
#' @return A [tibble::tibble()] with one row for each estimated parameter and
#'   columns:
#'
#'   \item{term}{The result of paste(lhs, op, rhs)}
#'   \item{op}{The operator in the model syntax (e.g. `~~` for covariances, or
#'     `~` for regression parameters)}
#'   \item{group}{The group (if specified) in the lavaan model}
#'   \item{estimate}{The parameter estimate (may be standardized)}
#'   \item{std.error}{}
#'   \item{statistic}{The z value returned by [lavaan::parameterEstimates()]}
#'   \item{p.value}{}
#'   \item{conf.low}{}
#'   \item{conf.high}{}
#'   \item{std.lv}{Standardized estimates based on the variances of the
#'     (continuous) latent variables only}
#'   \item{std.all}{Standardized estimates based on both the variances
#'     of both (continuous) observed and latent variables.}
#'   \item{std.nox}{Standardized estimates based on both the variances
#'     of both (continuous) observed and latent variables, but not the
#'     variances of exogenous covariates.}
#'
#' @examplesIf rlang::is_installed("lavaan")
#'
#' # load libraries for models and data
#' library(lavaan)
#'
#' cfa.fit <- cfa("F =~ x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9",
#'   data = HolzingerSwineford1939, group = "school"
#' )
#'
#' tidy(cfa.fit)
#'
#' @export
#' @aliases lavaan_tidiers sem_tidiers cfa_tidiers
#' @family lavaan tidiers
#' @seealso [tidy()], [lavaan::cfa()], [lavaan::sem()],
#'   [lavaan::parameterEstimates()]
tidy.lavaan <- function(x, conf.int = FALSE, conf.level = 0.95, ...) {
  check_ellipses("exponentiate", "tidy", "lavaan", ...)

  lavaan::parameterEstimates(
    x,
    ci = conf.int,
    level = conf.level,
    standardized = TRUE,
    ...
  ) |>
    as_tibble() |>
    tibble::rownames_to_column() |>
    mutate(term = paste(lhs, op, rhs)) |>
    rename2(
      estimate = est,
      std.error = se,
      p.value = pvalue,
      statistic = z,
      conf.low = ci.lower,
      conf.high = ci.upper
    ) |>
    select(term, op, dplyr::everything(), -rowname, -lhs, -rhs) |>
    as_tibble()
}


#' @templateVar class lavaan
#' @template title_desc_glance
#'
#' @inheritParams tidy.lavaan
#' @template param_unused_dots
#'
#' @return A one-row [tibble::tibble] with columns:
#'
#'   \item{chisq}{Model chi squared}
#'   \item{npar}{Number of parameters in the model}
#'   \item{rmsea}{Root mean square error of approximation}
#'   \item{rmsea.conf.high}{95 percent upper bound on RMSEA}
#'   \item{srmr}{Standardised root mean residual}
#'   \item{agfi}{Adjusted goodness of fit}
#'   \item{cfi}{Comparative fit index}
#'   \item{tli}{Tucker Lewis index}
#'   \item{AIC}{Akaike information criterion}
#'   \item{BIC}{Bayesian information criterion}
#'   \item{ngroups}{Number of groups in model}
#'   \item{nobs}{Number of observations included}
#'   \item{norig}{Number of observation in the original dataset}
#'   \item{nexcluded}{Number of excluded observations}
#'   \item{converged}{Logical - Did the model converge}
#'   \item{estimator}{Estimator used}
#'   \item{missing_method}{Method for eliminating missing data}
#'
#' For further recommendations on reporting SEM and CFA models see
#' Schreiber, J. B. (2017). Update to core reporting practices in
#' structural equation modeling. Research in Social and Administrative
#' Pharmacy, 13(3), 634-643. https://doi.org/10.1016/j.sapharm.2016.06.006
#'
#' @examplesIf rlang::is_installed("lavaan")
#'
#' library(lavaan)
#'
#' # fit model
#' cfa.fit <- cfa(
#'   "F =~ x1 + x2 + x3 + x4 + x5",
#'   data = HolzingerSwineford1939, group = "school"
#' )
#'
#' # summarize model fit with tidiers
#' glance(cfa.fit)
#'
#' @export
#' @family lavaan tidiers
#' @seealso [glance()], [lavaan::cfa()], [lavaan::sem()],
#'   [lavaan::fitmeasures()]
#'
glance.lavaan <- function(x, ...) {
  res <- x |>
    lavaan::fitmeasures(
      fit.measures = c(
        "npar",
        "chisq",
        "rmsea",
        "rmsea.ci.upper",
        "srmr",
        "aic",
        "bic",
        "tli",
        "agfi",
        "cfi"
      )
    ) |>
    tibble::enframe(name = "term") |>
    pivot_wider(names_from = term, values_from = value)
  res |>
    select(order(colnames(res))) |>
    map_df(as.numeric) |>
    bind_cols(
      tibble(
        converged = lavaan::lavInspect(x, "converged"),
        estimator = lavaan::lavInspect(x, "options")$estimator,
        ngroups = lavaan::lavInspect(x, "ngroups"),
        missing_method = lavaan::lavInspect(x, "options")$missing,
        nobs = sum(lavaan::lavInspect(x, "nobs")),
        norig = sum(lavaan::lavInspect(x, "norig")),
        nexcluded = norig - nobs
      )
    ) |>
    rename(rmsea.conf.high = rmsea.ci.upper, AIC = aic, BIC = bic)
}
