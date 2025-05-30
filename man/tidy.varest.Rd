% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vars.R
\name{tidy.varest}
\alias{tidy.varest}
\alias{vars_tidiers}
\title{Tidy a(n) varest object}
\usage{
\method{tidy}{varest}(x, conf.int = FALSE, conf.level = 0.95, ...)
}
\arguments{
\item{x}{A \code{varest} object produced by a call to \code{\link[vars:VAR]{vars::VAR()}}.}

\item{conf.int}{Logical indicating whether or not to include a confidence
interval in the tidied output. Defaults to \code{FALSE}.}

\item{conf.level}{The confidence level to use for the confidence interval
if \code{conf.int = TRUE}. Must be strictly greater than 0 and less than 1.
Defaults to 0.95, which corresponds to a 95 percent confidence interval.}

\item{...}{For \code{glance()}, additional arguments passed to \code{\link[=summary]{summary()}}.
Otherwise ignored.}
}
\description{
Tidy summarizes information about the components of a model.
A model component might be a single term in a regression, a single
hypothesis, a cluster, or a class. Exactly what tidy considers to be a
model component varies across models but is usually self-evident.
If a model has several distinct types of components, you will need to
specify which components to return.
}
\details{
The tibble has one row for each term in the regression. The
\code{component} column indicates whether a particular
term was used to model either the \code{"mean"} or \code{"precision"}. Here the
precision is the inverse of the variance, often referred to as \code{phi}.
At least one term will have been used to model the precision \code{phi}.

The \code{vars} package does not include a \code{confint} method and does not report
confidence intervals for \code{varest} objects. Setting the \code{tidy} argument
\code{conf.int = TRUE} will return a warning.
}
\examples{
\dontshow{if (rlang::is_installed("vars")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# load libraries for models and data
library(vars)

# load data
data("Canada", package = "vars")

# fit models
mod <- VAR(Canada, p = 1, type = "both")

# summarize model fit with tidiers
tidy(mod)
glance(mod)
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=tidy]{tidy()}}, \code{\link[vars:VAR]{vars::VAR()}}
}
\concept{vars tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with columns:
  \item{conf.high}{Upper bound on the confidence interval for the estimate.}
  \item{conf.low}{Lower bound on the confidence interval for the estimate.}
  \item{estimate}{The estimated value of the regression term.}
  \item{p.value}{The two-sided p-value associated with the observed statistic.}
  \item{statistic}{The value of a T-statistic to use in a hypothesis that the regression term is non-zero.}
  \item{std.error}{The standard error of the regression term.}
  \item{term}{The name of the regression term.}
  \item{component}{Whether a particular term was used to model the mean or the
    precision in the regression. See details.}

}
