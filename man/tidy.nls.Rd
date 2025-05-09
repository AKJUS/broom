% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stats-nls.R
\name{tidy.nls}
\alias{tidy.nls}
\alias{nls_tidiers}
\title{Tidy a(n) nls object}
\usage{
\method{tidy}{nls}(x, conf.int = FALSE, conf.level = 0.95, ...)
}
\arguments{
\item{x}{An \code{nls} object returned from \code{\link[stats:nls]{stats::nls()}}.}

\item{conf.int}{Logical indicating whether or not to include a confidence
interval in the tidied output. Defaults to \code{FALSE}.}

\item{conf.level}{The confidence level to use for the confidence interval
if \code{conf.int = TRUE}. Must be strictly greater than 0 and less than 1.
Defaults to 0.95, which corresponds to a 95 percent confidence interval.}

\item{...}{Additional arguments. Not used. Needed to match generic
signature only. \strong{Cautionary note:} Misspelled arguments will be
absorbed in \code{...}, where they will be ignored. If the misspelled
argument has a default value, the default value will be used.
For example, if you pass \code{conf.lvel = 0.9}, all computation will
proceed using \code{conf.level = 0.95}. Two exceptions here are:
\itemize{
\item \code{tidy()} methods will warn when supplied an \code{exponentiate} argument if
it will be ignored.
\item \code{augment()} methods will warn when supplied a \code{newdata} argument if it
will be ignored.
}}
}
\description{
Tidy summarizes information about the components of a model.
A model component might be a single term in a regression, a single
hypothesis, a cluster, or a class. Exactly what tidy considers to be a
model component varies across models but is usually self-evident.
If a model has several distinct types of components, you will need to
specify which components to return.
}
\examples{
\dontshow{if (rlang::is_installed("ggplot2")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# fit model
n <- nls(mpg ~ k * e^wt, data = mtcars, start = list(k = 1, e = 2))

# summarize model fit with tidiers + visualization
tidy(n)
augment(n)
glance(n)

library(ggplot2)

ggplot(augment(n), aes(wt, mpg)) +
  geom_point() +
  geom_line(aes(y = .fitted))

newdata <- head(mtcars)
newdata$wt <- newdata$wt + 1

augment(n, newdata = newdata)
\dontshow{\}) # examplesIf}
}
\seealso{
\link{tidy}, \code{\link[stats:nls]{stats::nls()}}, \code{\link[stats:summary.nls]{stats::summary.nls()}}

Other nls tidiers: 
\code{\link{augment.nls}()},
\code{\link{glance.nls}()}
}
\concept{nls tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with columns:
  \item{conf.high}{Upper bound on the confidence interval for the estimate.}
  \item{conf.low}{Lower bound on the confidence interval for the estimate.}
  \item{estimate}{The estimated value of the regression term.}
  \item{p.value}{The two-sided p-value associated with the observed statistic.}
  \item{statistic}{The value of a T-statistic to use in a hypothesis that the regression term is non-zero.}
  \item{std.error}{The standard error of the regression term.}
  \item{term}{The name of the regression term.}

}
