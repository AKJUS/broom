#' @templateVar class glm
#' @template title_desc_tidy
#'
#' @param x A `glm` object returned from [stats::glm()].
#' @template param_confint
#' @template param_exponentiate
#' @template param_unused_dots
#'
#' @export
#' @family lm tidiers
#' @seealso [stats::glm()]
tidy.glm <- function(
  x,
  conf.int = FALSE,
  conf.level = .95,
  exponentiate = FALSE,
  ...
) {
  warn_on_appropriated_glm_class(x)
  warn_on_subclass(x, "tidy")

  ret <- as_tibble(summary(x)$coefficients, rownames = "term")
  colnames(ret) <- c("term", "estimate", "std.error", "statistic", "p.value")

  coefs <- stats::coef(x)

  if (length(coefs) != nrow(ret)) {
    # summary(x)$coefficients misses rank deficient rows (i.e. coefs that
    # summary.lm() sets to NA), catch them here and add them back. This join is
    # costly, so only do it when necessary.
    coefs <- tibble::enframe(coefs, name = "term", value = "estimate")
    ret <- left_join(coefs, ret, by = c("term", "estimate"))
  }

  if (conf.int) {
    ci <- broom_confint_terms(x, level = conf.level)
    ret <- dplyr::left_join(ret, ci, by = "term")
  }

  if (exponentiate) {
    ret <- exponentiate(ret)
  }

  ret
}

#' @templateVar class glm
#' @template title_desc_augment
#'
#' @param x A `glm` object returned from [stats::glm()].
#' @template param_data
#' @template param_newdata
#' @param type.predict Passed to [stats::predict.glm()] `type`
#'   argument. Defaults to `"link"`.
#' @param type.residuals Passed to [stats::residuals.glm()] and
#'   to [stats::rstandard.glm()] `type` arguments. Defaults to `"deviance"`.
#' @template param_se_fit
#' @template param_unused_dots
#'
#' @evalRd return_augment(
#'   ".se.fit",
#'   ".hat",
#'   ".sigma",
#'   ".std.resid",
#'   ".cooksd"
#' )
#'
#' @details If the weights for any of the observations in the model
#'   are 0, then columns ".infl" and ".hat" in the result will be 0
#'   for those observations.
#'
#'   A `.resid` column is not calculated when data is specified via
#'   the `newdata` argument.
#'
#' @export
#' @family lm tidiers
#' @seealso [stats::glm()]
#' @include stats-lm.R
augment.glm <- function(
  x,
  data = model.frame(x),
  newdata = NULL,
  type.predict = c("link", "response", "terms"),
  type.residuals = c("deviance", "pearson"),
  se_fit = FALSE,
  ...
) {
  warn_on_appropriated_glm_class(x)
  warn_on_subclass(x, "augment")

  type.predict <- rlang::arg_match(type.predict)
  type.residuals <- rlang::arg_match(type.residuals)

  df <- if (is.null(newdata)) data else newdata
  df <- as_augment_tibble(df)

  # don't use augment_newdata here; don't want raw/response residuals in .resid
  if (se_fit) {
    pred_obj <- predict(x, newdata, type = type.predict, se.fit = TRUE)
    df$.fitted <- pred_obj$fit |> unname()
    df$.se.fit <- pred_obj$se.fit |> unname()
  } else {
    df$.fitted <- predict(x, newdata, type = type.predict) |> unname()
  }

  if (is.null(newdata)) {
    tryCatch(
      {
        infl <- influence(x, do.coef = FALSE)
        df$.resid <- residuals(x, type = type.residuals) |> unname()
        df <- add_hat_sigma_cols(df, x, infl)
        df$.std.resid <- rstandard(x, infl = infl, type = type.residuals) |>
          unname()
        df$.cooksd <- cooks.distance(x, infl = infl) |> unname()
      },
      error = data_error
    )
  }

  df
}


#' @templateVar class glm
#' @template title_desc_glance
#'
#' @param x A `glm` object returned from [stats::glm()].
#' @template param_unused_dots
#'
#' @evalRd return_glance(
#'   "null.deviance",
#'   "df.null",
#'   "logLik",
#'   "AIC",
#'   "BIC",
#'   "deviance",
#'   "df.residual",
#'   "nobs"
#' )
#'
#' @examples
#'
#' g <- glm(am ~ mpg, mtcars, family = "binomial")
#' glance(g)
#' @export
#' @family lm tidiers
#' @seealso [stats::glm()]
glance.glm <- function(x, ...) {
  warn_on_appropriated_glm_class(x)
  warn_on_subclass(x, "glance")

  as_glance_tibble(
    null.deviance = x$null.deviance,
    df.null = x$df.null,
    logLik = as.numeric(stats::logLik(x)),
    AIC = stats::AIC(x),
    BIC = stats::BIC(x),
    deviance = stats::deviance(x),
    df.residual = stats::df.residual(x),
    nobs = stats::nobs(x),
    na_types = "rirrrrii"
  )
}

warn_on_appropriated_glm_class <- function(x, call = caller_env()) {
  warn_on_glm2(x)
  warn_on_stanreg(x, call = call)

  invisible(TRUE)
}

# the output of glm2::glm2 has the same class as objects outputted
# by stats::glm2. glm2 outputs are currently not supported (intentionally)
# so warn that output is not maintained.
warn_on_glm2 <- function(x) {
  if (!is.null(x$method) & is.character(x$method)) {
    if (x$method == "glm.fit2") {
      cli::cli_warn(
        c(
          "{.arg x} seems to be outputted from the {.pkg glm2} package.",
          "i" = "Tidiers for {.pkg glm2} output are currently not maintained;
                 please use caution in interpreting {.pkg broom} output."
        ),
        call = NULL
      )
    }
  }

  invisible(TRUE)
}

# stanreg objects subclass glm, glm tidiers error out (uninformatively),
# and the maintained stanreg tidiers live in broom.mixed.
warn_on_stanreg <- function(x, call = caller_env()) {
  if (!is.null(x$stan_function)) {
    cli::cli_abort(
      c(
        "{.arg x} seems to be outputted from the {.pkg rstanarm} package.",
        "i" = "Tidiers for mixed model output now live in {.pkg broom.mixed}."
      ),
      call = call
    )
  }

  invisible(TRUE)
}
