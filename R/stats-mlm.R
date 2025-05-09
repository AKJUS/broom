#' @templateVar class mlm
#' @template title_desc_tidy
#'
#' @param x An `mlm` object created by [stats::lm()] with a matrix as the
#'   response.
#' @template param_confint
#' @template param_unused_dots
#'
#' @evalRd return_tidy(regression = TRUE)
#'
#' @details In contrast to `lm` object (simple linear model), tidy output for
#'   `mlm` (multiple linear model) objects contain an additional column
#'   `response`.
#'
#'   If you have missing values in your model data, you may need to refit
#'   the model with `na.action = na.exclude`.
#'
#' @examples
#'
#' # fit model
#' mod <- lm(cbind(mpg, disp) ~ wt, mtcars)
#'
#' # summarize model fit with tidiers
#' tidy(mod, conf.int = TRUE)
#'
#' @export
#' @seealso [tidy()]
#' @family lm tidiers
#' @export
tidy.mlm <- function(x, conf.int = FALSE, conf.level = 0.95, ...) {
  check_ellipses("exponentiate", "tidy", "mlm", ...)

  # adding other details from summary object
  s <- summary(x)

  co <- stats::coef(s)
  nn <- c("estimate", "std.error", "statistic", "p.value")

  # multiple response variables
  ret <- map_as_tidy_tibble(
    co,
    new_names = nn[1:ncol(co[[1]])],
    id_column = "response"
  )

  ret$response <- stringr::str_replace(ret$response, "Response ", "")

  ret <- as_tibble(ret)

  if (conf.int) {
    # S3 method for computing confidence intervals for `mlm` objects was
    # introduced in R 3.5
    CI <- tryCatch(
      stats::confint(x, level = conf.level),
      error = function(x) {
        NULL
      }
    )

    # if R version is prior to 3.5, use the custom function
    if (is.null(CI)) {
      CI <- confint_mlm(x, level = conf.level)
    }

    colnames(CI) <- c("conf.low", "conf.high")
    ret <- dplyr::bind_cols(ret, as_tibble(CI))
  }

  as_tibble(ret)
}

# compute confidence intervals for mlm object.
confint_mlm <- function(object, level = 0.95, ...) {
  coef <- as.numeric(coef(object))
  alpha <- (1 - level) / 2
  crit_val <- qt(c(alpha, 1 - alpha), object$df.residual)
  se <- sqrt(diag(stats::vcov(object)))
  ci <- as.data.frame(coef + se %o% crit_val)
  colnames(ci) <- c("conf.low", "conf.high")
  ci
}
