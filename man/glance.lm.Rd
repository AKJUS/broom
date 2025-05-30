% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stats-lm.R
\name{glance.lm}
\alias{glance.lm}
\title{Glance at a(n) lm object}
\usage{
\method{glance}{lm}(x, ...)
}
\arguments{
\item{x}{An \code{lm} object created by \code{\link[stats:lm]{stats::lm()}}.}

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
\dontshow{if (rlang::is_installed("ggplot2")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

library(ggplot2)
library(dplyr)

mod <- lm(mpg ~ wt + qsec, data = mtcars)

tidy(mod)
glance(mod)

# coefficient plot
d <- tidy(mod, conf.int = TRUE)

ggplot(d, aes(estimate, term, xmin = conf.low, xmax = conf.high, height = 0)) +
  geom_point() +
  geom_vline(xintercept = 0, lty = 4) +
  geom_errorbarh()

# aside: There are tidy() and glance() methods for lm.summary objects too.
# this can be useful when you want to conserve memory by converting large lm
# objects into their leaner summary.lm equivalents.
s <- summary(mod)
tidy(s, conf.int = TRUE)
glance(s)

augment(mod)
augment(mod, mtcars, interval = "confidence")

# predict on new data
newdata <- mtcars |>
  head(6) |>
  mutate(wt = wt + 1)
augment(mod, newdata = newdata)

# ggplot2 example where we also construct 95\% prediction interval

# simpler bivariate model since we're plotting in 2D
mod2 <- lm(mpg ~ wt, data = mtcars)

au <- augment(mod2, newdata = newdata, interval = "prediction")

ggplot(au, aes(wt, mpg)) +
  geom_point() +
  geom_line(aes(y = .fitted)) +
  geom_ribbon(aes(ymin = .lower, ymax = .upper), col = NA, alpha = 0.3)

# predict on new data without outcome variable. Output does not include .resid
newdata <- newdata |>
  select(-mpg)

augment(mod, newdata = newdata)

au <- augment(mod, data = mtcars)

ggplot(au, aes(.hat, .std.resid)) +
  geom_vline(size = 2, colour = "white", xintercept = 0) +
  geom_hline(size = 2, colour = "white", yintercept = 0) +
  geom_point() +
  geom_smooth(se = FALSE)

plot(mod, which = 6)

ggplot(au, aes(.hat, .cooksd)) +
  geom_vline(xintercept = 0, colour = NA) +
  geom_abline(slope = seq(0, 3, by = 0.5), colour = "white") +
  geom_smooth(se = FALSE) +
  geom_point()

# column-wise models
a <- matrix(rnorm(20), nrow = 10)
b <- a + rnorm(length(a))
result <- lm(b ~ a)

tidy(result)
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=glance]{glance()}}, \code{\link[=glance.summary.lm]{glance.summary.lm()}}

Other lm tidiers: 
\code{\link{augment.glm}()},
\code{\link{augment.lm}()},
\code{\link{glance.glm}()},
\code{\link{glance.summary.lm}()},
\code{\link{glance.svyglm}()},
\code{\link{tidy.glm}()},
\code{\link{tidy.lm}()},
\code{\link{tidy.lm.beta}()},
\code{\link{tidy.mlm}()},
\code{\link{tidy.summary.lm}()}
}
\concept{lm tidiers}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with exactly one row and columns:
  \item{adj.r.squared}{Adjusted R squared statistic, which is like the R squared statistic except taking degrees of freedom into account.}
  \item{AIC}{Akaike's Information Criterion for the model.}
  \item{BIC}{Bayesian Information Criterion for the model.}
  \item{deviance}{Deviance of the model.}
  \item{df.residual}{Residual degrees of freedom.}
  \item{logLik}{The log-likelihood of the model. [stats::logLik()] may be a useful reference.}
  \item{nobs}{Number of observations used.}
  \item{p.value}{P-value corresponding to the test statistic.}
  \item{r.squared}{R squared statistic, or the percent of variation explained by the model. Also known as the coefficient of determination.}
  \item{sigma}{Estimated standard error of the residuals.}
  \item{statistic}{Test statistic.}
  \item{df}{The degrees for freedom from the numerator of the overall
    F-statistic. This is new in broom 0.7.0. Previously, this reported
    the rank of the design matrix, which is one more than the numerator
    degrees of freedom of the overall F-statistic.}

}
