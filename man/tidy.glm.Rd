% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stats-glm.R
\name{tidy.glm}
\alias{tidy.glm}
\title{Tidy a(n) glm object}
\usage{
\method{tidy}{glm}(x, conf.int = FALSE, conf.level = 0.95, exponentiate = FALSE, ...)
}
\arguments{
\item{x}{A \code{glm} object returned from \code{\link[stats:glm]{stats::glm()}}.}

\item{conf.int}{Logical indicating whether or not to include a confidence
interval in the tidied output. Defaults to \code{FALSE}.}

\item{conf.level}{The confidence level to use for the confidence interval
if \code{conf.int = TRUE}. Must be strictly greater than 0 and less than 1.
Defaults to 0.95, which corresponds to a 95 percent confidence interval.}

\item{exponentiate}{Logical indicating whether or not to exponentiate the
the coefficient estimates. This is typical for logistic and multinomial
regressions, but a bad idea if there is no log or logit link. Defaults
to \code{FALSE}.}

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
\code{\link[stats:glm]{stats::glm()}}

Other lm tidiers: 
\code{\link{augment.glm}()},
\code{\link{augment.lm}()},
\code{\link{glance.glm}()},
\code{\link{glance.lm}()},
\code{\link{glance.summary.lm}()},
\code{\link{glance.svyglm}()},
\code{\link{tidy.lm}()},
\code{\link{tidy.lm.beta}()},
\code{\link{tidy.mlm}()},
\code{\link{tidy.summary.lm}()}
}
\concept{lm tidiers}
