% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/emmeans.R
\name{tidy.ref.grid}
\alias{tidy.ref.grid}
\title{Tidy a(n) ref.grid object}
\usage{
\method{tidy}{ref.grid}(x, conf.int = FALSE, conf.level = 0.95, ...)
}
\arguments{
\item{x}{A \code{ref.grid} object created by \code{\link[emmeans:ref_grid]{emmeans::ref_grid()}}.}

\item{conf.int}{Logical indicating whether or not to include a confidence
interval in the tidied output. Defaults to \code{FALSE}.}

\item{conf.level}{The confidence level to use for the confidence interval
if \code{conf.int = TRUE}. Must be strictly greater than 0 and less than 1.
Defaults to 0.95, which corresponds to a 95 percent confidence interval.}

\item{...}{Additional arguments passed to \code{\link[emmeans:summary.emmGrid]{emmeans::summary.emmGrid()}} or
\code{\link[lsmeans:ref.grid]{lsmeans::summary.ref.grid()}}. \strong{Cautionary note}: misspecified arguments
may be silently ignored!}
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
Returns a data frame with one observation for each estimated marginal
mean, and one column for each combination of factors. When the input is a
contrast, each row will contain one estimated contrast.

There are a large number of arguments that can be
passed on to \code{\link[emmeans:summary.emmGrid]{emmeans::summary.emmGrid()}} or \code{\link[lsmeans:ref.grid]{lsmeans::summary.ref.grid()}}.
}
\examples{
\dontshow{if (rlang::is_installed(c("emmeans", "ggplot2"))) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# load libraries for models and data
library(emmeans)

# linear model for sales of oranges per day
oranges_lm1 <- lm(sales1 ~ price1 + price2 + day + store, data = oranges)

# reference grid; see vignette("basics", package = "emmeans")
oranges_rg1 <- ref_grid(oranges_lm1)
td <- tidy(oranges_rg1)
td

# marginal averages
marginal <- emmeans(oranges_rg1, "day")
tidy(marginal)

# contrasts
tidy(contrast(marginal))
tidy(contrast(marginal, method = "pairwise"))

# plot confidence intervals
library(ggplot2)

ggplot(tidy(marginal, conf.int = TRUE), aes(day, estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high))

# by multiple prices
by_price <- emmeans(oranges_lm1, "day",
  by = "price2",
  at = list(
    price1 = 50, price2 = c(40, 60, 80),
    day = c("2", "3", "4")
  )
)

by_price

tidy(by_price)

ggplot(tidy(by_price, conf.int = TRUE), aes(price2, estimate, color = day)) +
  geom_line() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high))

# joint_tests
tidy(joint_tests(oranges_lm1))
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=tidy]{tidy()}}, \code{\link[emmeans:ref_grid]{emmeans::ref_grid()}}, \code{\link[emmeans:emmeans]{emmeans::emmeans()}},
\code{\link[emmeans:contrast]{emmeans::contrast()}}

Other emmeans tidiers: 
\code{\link{tidy.emmGrid}()},
\code{\link{tidy.lsmobj}()},
\code{\link{tidy.summary_emm}()}
}
\concept{emmeans tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with columns:
  \item{conf.high}{Upper bound on the confidence interval for the estimate.}
  \item{conf.low}{Lower bound on the confidence interval for the estimate.}
  \item{df}{Degrees of freedom used by this term in the model.}
  \item{p.value}{The two-sided p-value associated with the observed statistic.}
  \item{std.error}{The standard error of the regression term.}
  \item{estimate}{Expected marginal mean}
  \item{statistic}{T-ratio statistic}

}
