#' @templateVar class smooth.spline
#' @template title_desc_tidy
#'
#' @param x A `smooth.spline` object returned from [stats::smooth.spline()].
#' @template param_data
#' @template param_unused_dots
#'
# sometimes triggers CRAN NOTE `elapsed time > 10s`
#' @examplesIf FALSE
#'
#' # fit model
#' spl <- smooth.spline(mtcars$wt, mtcars$mpg, df = 4)
#'
#' # summarize model fit with tidiers
#' augment(spl, mtcars)
#'
#' # calls original columns x and y
#' augment(spl)
#'
#' library(ggplot2)
#' ggplot(augment(spl, mtcars), aes(wt, mpg)) +
#'   geom_point() +
#'   geom_line(aes(y = .fitted))
#'
#' @evalRd return_augment()
#'
#' @aliases smooth.spline_tidiers
#' @export
#' @family smoothing spline tidiers
#' @seealso [augment()], [stats::smooth.spline()],
#'   [stats::predict.smooth.spline()]
augment.smooth.spline <- function(x, data = x$data, ...) {
  check_ellipses("newdata", "augment", "smooth.spline", ...)

  data <- as_tibble(data)
  data$.fitted <- stats::fitted(x)
  data$.resid <- stats::resid(x)
  data
}


#' @templateVar class smooth.spine
#' @template title_desc_tidy
#'
#' @inherit augment.smooth.spline params examples
#'
#' @evalRd return_glance(
#'   "spar",
#'   "lambda",
#'   "df",
#'   "crit",
#'   "pen.crit",
#'   "cv.crit",
#'   "nobs"
#' )
#'
#' @export
#' @family smoothing spline tidiers
#' @seealso [augment()], [stats::smooth.spline()]
#'
glance.smooth.spline <- function(x, ...) {
  ret <- x[c("df", "lambda", "cv.crit", "pen.crit", "crit", "spar")]
  ret <- as_tibble(ret)
  ret$nobs <- stats::nobs(x)
  ret
}
