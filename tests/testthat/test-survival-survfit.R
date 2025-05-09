skip_on_cran()

skip_if_not_installed("modeltests")
library(modeltests)

skip_if_not_installed("survival")
suppressPackageStartupMessages(library(survival))

cfit <- coxph(Surv(time, status) ~ age + strata(sex), lung)
sfit <- survfit(cfit)

cfit2 <- coxph(Surv(time, status) ~ age, lung)
sfit2 <- survfit(cfit2)

fit2 <- survfit(
  Surv(stop, status * as.numeric(event), type = "mstate") ~ 1,
  data = mgus1,
  subset = (start == 0)
)

test_that("survfit tidier arguments", {
  check_arguments(tidy.survfit)
  check_arguments(glance.survfit)
})

test_that("tidy.survfit", {
  td <- tidy(sfit)
  td2 <- tidy(fit2)

  check_tidy_output(td)
  check_tidy_output(td2)
})

test_that("glance.survfit", {
  expect_snapshot(error = TRUE, glance(sfit))
  expect_snapshot(error = TRUE, glance(fit2))

  gl <- glance(sfit2)
  check_glance_outputs(gl)
})
