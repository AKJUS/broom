% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stats-time-series.R
\name{tidy.ts}
\alias{tidy.ts}
\title{Tidy a(n) ts object}
\usage{
\method{tidy}{ts}(x, ...)
}
\arguments{
\item{x}{A univariate or multivariate \code{ts} times series object.}

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
\code{series} column is only present for multivariate \code{ts} objects.
}
\examples{

set.seed(678)

tidy(ts(1:10, frequency = 4, start = c(1959, 2)))

z <- ts(matrix(rnorm(300), 100, 3), start = c(1961, 1), frequency = 12)
colnames(z) <- c("Aa", "Bb", "Cc")

tidy(z)
}
\seealso{
\code{\link[=tidy]{tidy()}}, \code{\link[stats:ts]{stats::ts()}}

Other time series tidiers: 
\code{\link{tidy.acf}()},
\code{\link{tidy.spec}()},
\code{\link{tidy.zoo}()}
}
\concept{time series tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with columns:
  \item{index}{Index (i.e. date or time) for a `ts` or `zoo` object.}
  \item{series}{Name of the series (present only for multivariate time series).}
  \item{value}{The value/estimate of the component. Results from data reshaping.}

}
