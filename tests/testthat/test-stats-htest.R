skip_if_not_installed("modeltests")
library(modeltests)

skip_if_not_installed("modeldata")
library(modeldata)
data(hpc_data)

test_that("htest tidier arguments", {
  check_arguments(tidy.htest)
  check_arguments(glance.htest)
})

test_that("tidy.htest same as glance.htest", {
  tt <- t.test(rnorm(10))
  expect_identical(tidy(tt), glance(tt))
})

test_that("tidy.htest/oneway.test", {
  mtcars$cyl <- as.factor(mtcars$cyl)
  ot <- oneway.test(mpg ~ cyl, mtcars)
  expect_snapshot(td <- tidy(ot))
  expect_snapshot(gl <- glance(ot))

  check_tidy_output(td)
  check_dims(td, expected_cols = 5)
  check_glance_outputs(gl)
})

test_that("tidy.htest/cor.test", {
  pco <- cor.test(mtcars$mpg, mtcars$wt)
  td <- tidy(pco)
  gl <- glance(pco)

  check_tidy_output(td)
  check_glance_outputs(gl, strict = FALSE)

  sco <- suppressWarnings(cor.test(mtcars$mpg, mtcars$wt, method = "spearman"))
  td2 <- tidy(sco)
  gl2 <- glance(sco)

  check_tidy_output(td2)
  check_glance_outputs(gl2, strict = FALSE)
})

test_that("tidy.htest/t.test", {
  tt <- t.test(mpg ~ am, mtcars)
  td <- tidy(tt)
  gl <- glance(tt)

  check_tidy_output(td)
  check_glance_outputs(gl, strict = FALSE)
})

test_that("tidy.htest/wilcox.test", {
  wt <- suppressWarnings(wilcox.test(mpg ~ am, mtcars))
  td <- tidy(wt)
  gl <- glance(wt)

  check_tidy_output(td)
  check_glance_outputs(gl)
})

test_that("tidy.pairwise.htest", {
  pht <- with(hpc_data, pairwise.t.test(compounds, class))
  td <- tidy(pht)
  # gl <- glance(pht)

  check_arguments(tidy.pairwise.htest)
  check_tidy_output(td)
  # check_glance_outputs(gl). doesn't exist yet
})

test_that("tidy.power.htest", {
  ptt <- power.t.test(n = 2:30, delta = 1)
  td <- tidy(ptt)
  # gl <- glance(ptt)

  check_arguments(tidy.power.htest)
  check_tidy_output(td, strict = FALSE)
  # check_glance_outputs(gl). doesn't exist yet.
})


test_that("augment.htest (chi squared test)", {
  # doesn't have a data argument
  check_arguments(augment.htest, strict = FALSE)

  df <- as.data.frame(Titanic)
  tab <- xtabs(Freq ~ Sex + Class, data = df)

  chit <- chisq.test(tab) # 2D table
  au <- augment(chit)
  check_tibble(au, method = "augment", strict = FALSE)

  chit2 <- chisq.test(c(A = 20, B = 15, C = 25)) # 1D table
  au2 <- augment(chit2)
  check_tibble(au2, method = "augment", strict = FALSE)

  tt <- t.test(rnorm(10))
  expect_snapshot(error = TRUE, augment(tt))

  wt <- wilcox.test(mpg ~ am, data = mtcars, conf.int = TRUE, exact = FALSE)
  expect_snapshot(error = TRUE, augment(wt))

  ct <- cor.test(mtcars$wt, mtcars$mpg)
  expect_snapshot(error = TRUE, augment(ct))
})

test_that("tidy.htest does not return matrix columns", {
  skip_if_not_installed("survey")
  data(api, package = "survey")
  dclus1 <- survey::svydesign(
    id = ~dnum,
    weights = ~pw,
    data = apiclus1,
    fpc = ~fpc
  )

  expect_true(
    survey::svychisq(
      ~ sch.wide + stype,
      design = dclus1,
      statistic = "Wald"
    ) |>
      tidy() |>
      purrr::none(~ inherits(., "matrix"))
  )
})

test_that("tidy.htest handles various test types", {
  tt <- t.test(rnorm(10))
  tt$parameter <- c(9, 10)

  expect_snapshot(.res <- tidy(tt))
})
