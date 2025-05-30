% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tseries.R
\name{glance.garch}
\alias{glance.garch}
\title{Tidy a(n) garch object}
\usage{
\method{glance}{garch}(x, test = c("box-ljung-test", "jarque-bera-test"), ...)
}
\arguments{
\item{x}{A \code{garch} object returned by \code{\link[tseries:garch]{tseries::garch()}}.}

\item{test}{Character specification of which hypothesis test to use. The
\code{garch} function reports 2 hypothesis tests: Jarque-Bera to residuals
and Box-Ljung to squared residuals.}

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
\seealso{
\code{\link[=glance]{glance()}}, \code{\link[tseries:garch]{tseries::garch()}}, []

Other garch tidiers: 
\code{\link{tidy.garch}()}
}
\concept{garch tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with exactly one row and columns:
  \item{AIC}{Akaike's Information Criterion for the model.}
  \item{BIC}{Bayesian Information Criterion for the model.}
  \item{logLik}{The log-likelihood of the model. [stats::logLik()] may be a useful reference.}
  \item{method}{Which method was used.}
  \item{nobs}{Number of observations used.}
  \item{p.value}{P-value corresponding to the test statistic.}
  \item{statistic}{Test statistic.}
  \item{parameter}{Parameter field in the htest, typically degrees of
    freedom.}

}
