skip_on_cran()

skip_if_not_installed("modeltests")
library(modeltests)

skip_if_not_installed("network")
skip_if_not_installed("btergm")

test_that("tidy.btergm", {
  check_arguments(tidy.btergm, strict = FALSE)

  networks <- list()

  for (i in 1:10) {
    mat <- matrix(rbinom(100, 1, .25), nrow = 10, ncol = 10)
    diag(mat) <- 0
    nw <- network::network(mat)
    networks[[i]] <- nw
  }

  covariates <- list()

  for (i in 1:10) {
    mat <- matrix(rnorm(100), nrow = 10, ncol = 10)
    covariates[[i]] <- mat
  }

  suppressWarnings(
    fit <- btergm::btergm(
      networks ~ edges + istar(2) + edgecov(covariates),
      R = 100,
      verbose = FALSE
    )
  )

  td <- tidy(fit)
  tde <- tidy(fit, exponentiate = TRUE)

  check_tidy_output(td)
  check_tidy_output(tde)

  check_dims(td, 3, 4)
  check_dims(tde, 3, 4)
})
