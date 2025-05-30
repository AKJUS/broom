#' @templateVar class Mclust
#' @template title_desc_tidy
#'
#' @param x An `Mclust` object return from [mclust::Mclust()].
#' @template param_unused_dots
#'
#' @evalRd return_tidy(
#'   "size",
#'   "proportion",
#'   mean = "The mean for each component. In case of 2+ dimensional models,
#'     a column with the mean is added for each dimension. NA for noise
#'     component",
#'   variance = "In case of one-dimensional and spherical models,
#'     the variance for each component, omitted otherwise. NA for noise
#'     component",
#'   component = "Cluster id as a factor."
#' )
#'
#' @examplesIf rlang::is_installed("mclust")
#'
#' # load library for models and data
#' library(mclust)
#'
#' # load data manipulation libraries
#' library(dplyr)
#' library(tibble)
#' library(purrr)
#' library(tidyr)
#'
#' set.seed(27)
#'
#' centers <- tibble(
#'   cluster = factor(1:3),
#'   # number points in each cluster
#'   num_points = c(100, 150, 50),
#'   # x1 coordinate of cluster center
#'   x1 = c(5, 0, -3),
#'   # x2 coordinate of cluster center
#'   x2 = c(-1, 1, -2)
#' )
#'
#' points <- centers |>
#'   mutate(
#'     x1 = map2(num_points, x1, rnorm),
#'     x2 = map2(num_points, x2, rnorm)
#'   ) |>
#'   select(-num_points, -cluster) |>
#'   unnest(c(x1, x2))
#'
#' # fit model
#' m <- Mclust(points)
#'
#' # summarize model fit with tidiers
#' tidy(m)
#' augment(m, points)
#' glance(m)
#'
#' @export
#' @aliases mclust_tidiers
#' @seealso [tidy()], [mclust::Mclust()]
#' @family mclust tidiers
#'
tidy.Mclust <- function(x, ...) {
  np <- max(x$G, length(table(x$classification)))
  ret <- data.frame(seq_len(np))
  colnames(ret) <- c("component")
  if (x$G < np) ret$component <- ret$component - 1
  ret$size <- sapply(seq(1, np), function(c) {
    sum(x$classification == c)
  })
  ret$proportion <- x$parameters$pro
  if (x$modelName %in% c("E", "V", "EII", "VII")) {
    ret$variance <- rep_len(x$parameters$variance$sigmasq, length.out = x$G)
  }
  if (dim(as.matrix(x$parameters$mean))[2] > 1) {
    mean <- t(x$parameters$mean)
  } else if (is.null(dim(x$parameters$mean))) {
    mean <- as.matrix(x$parameters$mean)
  } else {
    mean <- t(as.matrix(x$parameters$mean))
  }
  ret <- cbind(ret, mean = rbind(matrix(, np - nrow(mean), ncol(mean)), mean))
  as_tibble(ret)
}


#' @templateVar class Mclust
#' @template title_desc_augment
#'
#' @inherit tidy.Mclust params examples
#' @template param_data
#'
#' @evalRd return_augment(
#'   .fitted = FALSE,
#'   .resid = FALSE,
#'   ".class",
#'   ".uncertainty"
#' )
#'
#' @export
#' @seealso [augment()], [mclust::Mclust()]
#' @family mclust tidiers
#'
augment.Mclust <- function(x, data = NULL, ...) {
  check_ellipses("newdata", "augment", "Mclust", ...)

  if (is.null(data)) {
    data <- x$data
  } else if (!(is.data.frame(data) || is.matrix(data))) {
    cli::cli_abort("{.arg data} must be a data frame or matrix.")
  }

  as_augment_tibble(data) |>
    mutate(
      .class = as.factor(!!x$classification),
      .uncertainty = !!x$uncertainty
    )
}

#' @templateVar class Mclust
#' @template title_desc_glance
#'
#' @inherit tidy.Mclust params examples
#'
#' @evalRd return_glance(
#'   "BIC",
#'   "logLik",
#'   "df",
#'   model = "A string denoting the model type with optimal BIC",
#'   G = "Number mixture components in optimal model",
#'   hypvol = "If the other model contains a noise component, the
#'     value of the hypervolume parameter. Otherwise `NA`.",
#'   "nobs"
#' )
#'
#' @export
glance.Mclust <- function(x, ...) {
  as_glance_tibble(
    model = unname(x$modelName),
    G = unname(x$G),
    BIC = unname(x$bic),
    logLik = unname(x$loglik),
    df = unname(x$df),
    hypvol = unname(x$hypvol),
    nobs = stats::nobs(x),
    na_types = "cirriri"
  )
}
