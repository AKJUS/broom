% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/survival-pyears.R
\name{tidy.pyears}
\alias{tidy.pyears}
\alias{pyears_tidiers}
\title{Tidy a(n) pyears object}
\usage{
\method{tidy}{pyears}(x, ...)
}
\arguments{
\item{x}{A \code{pyears} object returned from \code{\link[survival:pyears]{survival::pyears()}}.}

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
\details{
\code{expected} is only present in the output when if a \code{ratetable}
term is present.

If the \code{data.frame = TRUE} argument is supplied to \code{pyears},
this is simply the contents of \code{x$data}.
}
\examples{
\dontshow{if (rlang::is_installed("survival")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# load libraries for models and data
library(survival)

# generate and format data
temp.yr <- tcut(mgus$dxyr, 55:92, labels = as.character(55:91))
temp.age <- tcut(mgus$age, 34:101, labels = as.character(34:100))
ptime <- ifelse(is.na(mgus$pctime), mgus$futime, mgus$pctime)
pstat <- ifelse(is.na(mgus$pctime), 0, 1)
pfit <- pyears(Surv(ptime / 365.25, pstat) ~ temp.yr + temp.age + sex, mgus,
  data.frame = TRUE
)

# summarize model fit with tidiers
tidy(pfit)
glance(pfit)

# if data.frame argument is not given, different information is present in
# output
pfit2 <- pyears(Surv(ptime / 365.25, pstat) ~ temp.yr + temp.age + sex, mgus)

tidy(pfit2)
glance(pfit2)
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=tidy]{tidy()}}, \code{\link[survival:pyears]{survival::pyears()}}

Other pyears tidiers: 
\code{\link{glance.pyears}()}

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
\code{\link{tidy.survdiff}()},
\code{\link{tidy.survexp}()},
\code{\link{tidy.survfit}()},
\code{\link{tidy.survreg}()}
}
\concept{pyears tidiers}
\concept{survival tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with columns:
  \item{expected}{Expected number of events.}
  \item{pyears}{Person-years of exposure.}
  \item{n}{number of subjects contributing time}
  \item{event}{observed number of events}

}
