% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plm.R
\name{glance.plm}
\alias{glance.plm}
\title{Glance at a(n) plm object}
\usage{
\method{glance}{plm}(x, ...)
}
\arguments{
\item{x}{A \code{plm} objected returned by \code{\link[plm:plm]{plm::plm()}}.}

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
\dontshow{if (rlang::is_installed("plm")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# load libraries for models and data
library(plm)

# load data
data("Produc", package = "plm")

# fit model
zz <- plm(log(gsp) ~ log(pcap) + log(pc) + log(emp) + unemp,
  data = Produc, index = c("state", "year")
)

# summarize model fit with tidiers
summary(zz)

tidy(zz)
tidy(zz, conf.int = TRUE)
tidy(zz, conf.int = TRUE, conf.level = 0.9)

augment(zz)
glance(zz)
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=glance]{glance()}}, \code{\link[plm:plm]{plm::plm()}}

Other plm tidiers: 
\code{\link{augment.plm}()},
\code{\link{tidy.plm}()}
}
\concept{plm tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with exactly one row and columns:
  \item{adj.r.squared}{Adjusted R squared statistic, which is like the R squared statistic except taking degrees of freedom into account.}
  \item{deviance}{Deviance of the model.}
  \item{df.residual}{Residual degrees of freedom.}
  \item{nobs}{Number of observations used.}
  \item{p.value}{P-value corresponding to the test statistic.}
  \item{r.squared}{R squared statistic, or the percent of variation explained by the model. Also known as the coefficient of determination.}
  \item{statistic}{F-statistic}

}
