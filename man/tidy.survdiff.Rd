% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/survival-survdiff.R
\name{tidy.survdiff}
\alias{tidy.survdiff}
\alias{survdiff_tidiers}
\title{Tidy a(n) survdiff object}
\usage{
\method{tidy}{survdiff}(x, ...)
}
\arguments{
\item{x}{An \code{survdiff} object returned from \code{\link[survival:survdiff]{survival::survdiff()}}.}

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
\dontshow{if (rlang::is_installed("survival")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# load libraries for models and data
library(survival)

# fit model
s <- survdiff(
  Surv(time, status) ~ pat.karno + strata(inst),
  data = lung
)

# summarize model fit with tidiers
tidy(s)
glance(s)
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=tidy]{tidy()}}, \code{\link[survival:survdiff]{survival::survdiff()}}

Other survdiff tidiers: 
\code{\link{glance.survdiff}()}

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
\code{\link{tidy.survexp}()},
\code{\link{tidy.survfit}()},
\code{\link{tidy.survreg}()}
}
\concept{survdiff tidiers}
\concept{survival tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with columns:
  \item{exp}{Weighted expected number of events in each group.}
  \item{N}{Number of subjects in each group.}
  \item{obs}{weighted observed number of events in each group.}

}
