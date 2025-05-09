% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/survival-survreg.R
\name{tidy.survreg}
\alias{tidy.survreg}
\alias{survreg_tidiers}
\title{Tidy a(n) survreg object}
\usage{
\method{tidy}{survreg}(x, conf.level = 0.95, conf.int = FALSE, ...)
}
\arguments{
\item{x}{An \code{survreg} object returned from \code{\link[survival:survreg]{survival::survreg()}}.}

\item{conf.level}{The confidence level to use for the confidence interval
if \code{conf.int = TRUE}. Must be strictly greater than 0 and less than 1.
Defaults to 0.95, which corresponds to a 95 percent confidence interval.}

\item{conf.int}{Logical indicating whether or not to include a confidence
interval in the tidied output. Defaults to \code{FALSE}.}

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
\dontshow{if (rlang::is_installed(c("survival", "ggplot2"))) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# load libraries for models and data
library(survival)

# fit model
sr <- survreg(
  Surv(futime, fustat) ~ ecog.ps + rx,
  ovarian,
  dist = "exponential"
)

# summarize model fit with tidiers + visualization
tidy(sr)
augment(sr, ovarian)
glance(sr)

# coefficient plot
td <- tidy(sr, conf.int = TRUE)

library(ggplot2)

ggplot(td, aes(estimate, term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0) +
  geom_vline(xintercept = 0)
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=tidy]{tidy()}}, \code{\link[survival:survreg]{survival::survreg()}}

Other survreg tidiers: 
\code{\link{augment.survreg}()},
\code{\link{glance.survreg}()}

Other survival tidiers: 
\code{\link{augment.coxph}()},
\code{\link{augment.survreg}()},
\code{\link{glance.aareg}()},
\code{\link{glance.cch}()},
\code{\link{glance.coxph}()},
\code{\link{glance.pyears}()},
\code{\link{glance.survdiff}()},
\code{\link{glance.survexp}()},
\code{\link{glance.survfit}()},
\code{\link{glance.survreg}()},
\code{\link{tidy.aareg}()},
\code{\link{tidy.cch}()},
\code{\link{tidy.coxph}()},
\code{\link{tidy.pyears}()},
\code{\link{tidy.survdiff}()},
\code{\link{tidy.survexp}()},
\code{\link{tidy.survfit}()}
}
\concept{survival tidiers}
\concept{survreg tidiers}
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
