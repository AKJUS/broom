#' @templateVar class glmnet
#' @template title_desc_tidy
#'
#' @param x A `glmnet` object returned from [glmnet::glmnet()].
#' @param return_zeros Logical indicating whether coefficients with value zero
#'   zero should be included in the results. Defaults to `FALSE`.
#' @template param_unused_dots
#'
#' @evalRd return_tidy(
#'   "term",
#'   "step",
#'   "estimate",
#'   "lambda",
#'   "dev.ratio"
#' )
#'
#' @details Note that while this representation of GLMs is much easier
#'   to plot and combine than the default structure, it is also much
#'   more memory-intensive. Do not use for large, sparse matrices.
#'
#'   No `augment` method is yet provided even though the model produces
#'   predictions, because the input data is not tidy (it is a matrix that
#'   may be very wide) and therefore combining predictions with it is not
#'   logical. Furthermore, predictions make sense only with a specific
#'   choice of lambda.
#'
# sometimes triggers CRAN NOTE `elapsed time > 10s`
#' @examplesIf FALSE
#'
#' # load libraries for models and data
#' library(glmnet)
#'
#' set.seed(2014)
#' x <- matrix(rnorm(100 * 20), 100, 20)
#' y <- rnorm(100)
#' fit1 <- glmnet(x, y)
#'
#' # summarize model fit with tidiers + visualization
#' tidy(fit1)
#' glance(fit1)
#'
#' library(dplyr)
#' library(ggplot2)
#'
#' tidied <- tidy(fit1) |> filter(term != "(Intercept)")
#'
#' ggplot(tidied, aes(step, estimate, group = term)) +
#'   geom_line()
#'
#' ggplot(tidied, aes(lambda, estimate, group = term)) +
#'   geom_line() +
#'   scale_x_log10()
#'
#' ggplot(tidied, aes(lambda, dev.ratio)) +
#'   geom_line()
#'
#' # works for other types of regressions as well, such as logistic
#' g2 <- sample(1:2, 100, replace = TRUE)
#' fit2 <- glmnet(x, g2, family = "binomial")
#' tidy(fit2)
#'
#' @export
#' @aliases glmnet_tidiers
#' @family glmnet tidiers
#' @seealso [tidy()], [glmnet::glmnet()]
tidy.glmnet <- function(x, return_zeros = FALSE, ...) {
  beta <- coef(x)

  if (inherits(x, "multnet")) {
    beta_d <- purrr::map_df(
      beta,
      function(b) {
        as_tidy_tibble(as.matrix(b), new_names = 1:ncol(b))
      },
      .id = "class"
    )
    ret <- beta_d |>
      pivot_longer(
        cols = c(everything(), -term, -class),
        names_to = "step",
        values_to = "estimate"
      )
  } else {
    beta_d <- as_tidy_tibble(
      as.matrix(beta),
      new_names = 1:ncol(beta)
    )

    ret <- pivot_longer(
      beta_d,
      cols = c(dplyr::everything(), -term),
      names_to = "step",
      values_to = "estimate"
    )
  }
  # add values specific to each step
  ret <- ret |>
    mutate(
      step = as.numeric(step),
      lambda = x$lambda[step],
      dev.ratio = x$dev.ratio[step]
    )

  if (!return_zeros) {
    ret <- filter(ret, estimate != 0)
  }

  as_tibble(ret)
}


#' @templateVar class glmnet
#' @template title_desc_glance
#'
#' @inherit tidy.glmnet params examples
#'
#' @evalRd return_glance("nulldev", "npasses", "nobs")
#'
#' @export
#' @family glmnet tidiers
#' @seealso [glance()], [glmnet::glmnet()]
glance.glmnet <- function(x, ...) {
  as_glance_tibble(
    nulldev = x$nulldev,
    npasses = x$npasses,
    nobs = stats::nobs(x),
    na_types = "rii"
  )
}
