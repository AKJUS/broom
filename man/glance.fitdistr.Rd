% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mass-fitdistr.R
\name{glance.fitdistr}
\alias{glance.fitdistr}
\title{Glance at a(n) fitdistr object}
\usage{
\method{glance}{fitdistr}(x, ...)
}
\arguments{
\item{x}{A \code{fitdistr} object returned by \code{\link[MASS:fitdistr]{MASS::fitdistr()}}.}

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
Glance accepts a model object and returns a \code{\link[tibble:tibble]{tibble::tibble()}}
with exactly one row of model summaries. The summaries are typically
goodness of fit measures, p-values for hypothesis tests on residuals,
or model convergence information.

Glance never returns information from the original call to the modeling
function. This includes the name of the modeling function or any
arguments passed to the modeling function.

Glance does not calculate summary measures. Rather, it farms out these
computations to appropriate methods and gathers the results together.
Sometimes a goodness of fit measure will be undefined. In these cases
the measure will be reported as \code{NA}.

Glance returns the same number of columns regardless of whether the
model matrix is rank-deficient or not. If so, entries in columns
that no longer have a well-defined value are filled in with an \code{NA}
of the appropriate type.
}
\examples{
\dontshow{if (rlang::is_installed("MASS")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# load libraries for models and data
library(MASS)

# generate data
set.seed(2015)
x <- rnorm(100, 5, 2)

#  fit models
fit <- fitdistr(x, dnorm, list(mean = 3, sd = 1))

# summarize model fit with tidiers
tidy(fit)
glance(fit)
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=tidy]{tidy()}}, \code{\link[MASS:fitdistr]{MASS::fitdistr()}}

Other fitdistr tidiers: 
\code{\link{tidy.fitdistr}()}
}
\concept{fitdistr tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with exactly one row and columns:
  \item{AIC}{Akaike's Information Criterion for the model.}
  \item{BIC}{Bayesian Information Criterion for the model.}
  \item{logLik}{The log-likelihood of the model. [stats::logLik()] may be a useful reference.}
  \item{nobs}{Number of observations used.}

}
