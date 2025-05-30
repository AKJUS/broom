% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mfx.R
\name{glance.mfx}
\alias{glance.mfx}
\alias{glance.logitmfx}
\alias{glance.negbinmfx}
\alias{glance.poissonmfx}
\alias{glance.probitmfx}
\title{Glance at a(n) mfx object}
\usage{
\method{glance}{mfx}(x, ...)

\method{glance}{logitmfx}(x, ...)

\method{glance}{negbinmfx}(x, ...)

\method{glance}{poissonmfx}(x, ...)

\method{glance}{probitmfx}(x, ...)
}
\arguments{
\item{x}{A \code{logitmfx}, \code{negbinmfx}, \code{poissonmfx}, or \code{probitmfx}  object. (Note that \code{betamfx} objects receive their own set of tidiers.)}

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
\details{
This generic glance method wraps \code{\link[=glance.glm]{glance.glm()}} for applicable
objects from the \code{mfx} package.
}
\examples{
\dontshow{if (rlang::is_installed("mfx")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# load libraries for models and data
library(mfx)

# get the marginal effects from a logit regression
mod_logmfx <- logitmfx(am ~ cyl + hp + wt, atmean = TRUE, data = mtcars)

tidy(mod_logmfx, conf.int = TRUE)

# compare with the naive model coefficients of the same logit call
tidy(
  glm(am ~ cyl + hp + wt, family = binomial, data = mtcars),
  conf.int = TRUE
)

augment(mod_logmfx)
glance(mod_logmfx)

# another example, this time using probit regression
mod_probmfx <- probitmfx(am ~ cyl + hp + wt, atmean = TRUE, data = mtcars)

tidy(mod_probmfx, conf.int = TRUE)
augment(mod_probmfx)
glance(mod_probmfx)
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=glance.glm]{glance.glm()}}, \code{\link[mfx:logitmfx]{mfx::logitmfx()}}, \code{\link[mfx:negbinmfx]{mfx::negbinmfx()}},
\code{\link[mfx:poissonmfx]{mfx::poissonmfx()}}, \code{\link[mfx:probitmfx]{mfx::probitmfx()}}

Other mfx tidiers: 
\code{\link{augment.betamfx}()},
\code{\link{augment.mfx}()},
\code{\link{glance.betamfx}()},
\code{\link{tidy.betamfx}()},
\code{\link{tidy.mfx}()}
}
\concept{mfx tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with exactly one row and columns:
  \item{AIC}{Akaike's Information Criterion for the model.}
  \item{BIC}{Bayesian Information Criterion for the model.}
  \item{deviance}{Deviance of the model.}
  \item{df.null}{Degrees of freedom used by the null model.}
  \item{df.residual}{Residual degrees of freedom.}
  \item{logLik}{The log-likelihood of the model. [stats::logLik()] may be a useful reference.}
  \item{nobs}{Number of observations used.}
  \item{null.deviance}{Deviance of the null model.}

}
