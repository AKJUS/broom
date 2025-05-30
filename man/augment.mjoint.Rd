% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/joinerml.R
\name{augment.mjoint}
\alias{augment.mjoint}
\title{Augment data with information from a(n) mjoint object}
\usage{
\method{augment}{mjoint}(x, data = x$data, ...)
}
\arguments{
\item{x}{An \code{mjoint} object returned from \code{\link[joineRML:mjoint]{joineRML::mjoint()}}.}

\item{data}{A \link[base:data.frame]{base::data.frame} or \code{\link[tibble:tibble]{tibble::tibble()}} containing the original
data that was used to produce the object \code{x}. Defaults to
\code{stats::model.frame(x)} so that \code{augment(my_fit)} returns the augmented
original data. \strong{Do not} pass new data to the \code{data} argument.
Augment will report information such as influence and cooks distance for
data passed to the \code{data} argument. These measures are only defined for
the original training data.}

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
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} with one row for each original observation
with addition columns:
\item{.fitted_j_0}{population-level fitted values for the
j-th longitudinal process}
\item{.fitted_j_1}{individuals-level fitted values for the j-th
longitudinal process}
\item{.resid_j_0}{population-level residuals for the j-th
longitudinal process}
\item{.resid_j_1}{individual-level residuals for the j-th
longitudinal process}
}
\description{
Augment accepts a model object and a dataset and adds
information about each observation in the dataset. Most commonly, this
includes predicted values in the \code{.fitted} column, residuals in the
\code{.resid} column, and standard errors for the fitted values in a \code{.se.fit}
column. New columns always begin with a \code{.} prefix to avoid overwriting
columns in the original dataset.

Users may pass data to augment via either the \code{data} argument or the
\code{newdata} argument. If the user passes data to the \code{data} argument,
it \strong{must} be exactly the data that was used to fit the model
object. Pass datasets to \code{newdata} to augment data that was not used
during model fitting. This still requires that at least all predictor
variable columns used to fit the model are present. If the original outcome
variable used to fit the model is not included in \code{newdata}, then no
\code{.resid} column will be included in the output.

Augment will often behave differently depending on whether \code{data} or
\code{newdata} is given. This is because there is often information
associated with training observations (such as influences or related)
measures that is not meaningfully defined for new observations.

For convenience, many augment methods provide default \code{data} arguments,
so that \code{augment(fit)} will return the augmented training data. In these
cases, augment tries to reconstruct the original data based on the model
object with varying degrees of success.

The augmented dataset is always returned as a \link[tibble:tibble]{tibble::tibble} with the
\strong{same number of rows} as the passed dataset. This means that the passed
data must be coercible to a tibble. If a predictor enters the model as part
of a matrix of covariates, such as when the model formula uses
\code{\link[splines:ns]{splines::ns()}}, \code{\link[stats:poly]{stats::poly()}}, or \code{\link[survival:Surv]{survival::Surv()}}, it is represented
as a matrix column.

We are in the process of defining behaviors for models fit with various
\code{na.action} arguments, but make no guarantees about behavior when data is
missing at this time.
}
\details{
See \code{\link[joineRML:fitted.mjoint]{joineRML::fitted.mjoint()}} and \code{\link[joineRML:residuals.mjoint]{joineRML::residuals.mjoint()}} for
more information on the difference between population-level and
individual-level fitted values and residuals.

If fitting a joint model with a single longitudinal process,
make sure you are using a named \code{list} to define the formula
for the fixed and random effects of the longitudinal submodel.
}
\examples{
\dontshow{if (rlang::is_installed("joineRML")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# broom only skips running these examples because the example models take a
# while to generate—they should run just fine, though!
\dontrun{


# load libraries for models and data
library(joineRML)

# fit a joint model with bivariate longitudinal outcomes
data(heart.valve)

hvd <- heart.valve[!is.na(heart.valve$log.grad) &
  !is.na(heart.valve$log.lvmi) &
  heart.valve$num <= 50, ]

fit <- mjoint(
  formLongFixed = list(
    "grad" = log.grad ~ time + sex + hs,
    "lvmi" = log.lvmi ~ time + sex
  ),
  formLongRandom = list(
    "grad" = ~ 1 | num,
    "lvmi" = ~ time | num
  ),
  formSurv = Surv(fuyrs, status) ~ age,
  data = hvd,
  inits = list("gamma" = c(0.11, 1.51, 0.80)),
  timeVar = "time"
)

# extract the survival fixed effects
tidy(fit)

# extract the longitudinal fixed effects
tidy(fit, component = "longitudinal")

# extract the survival fixed effects with confidence intervals
tidy(fit, ci = TRUE)

# extract the survival fixed effects with confidence intervals based
# on bootstrapped standard errors
bSE <- bootSE(fit, nboot = 5, safe.boot = TRUE)
tidy(fit, boot_se = bSE, ci = TRUE)

# augment original data with fitted longitudinal values and residuals
hvd2 <- augment(fit)

# extract model statistics
glance(fit)
}
\dontshow{\}) # examplesIf}
}
