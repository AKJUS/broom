skip_on_cran()

skip_if_not_installed("modeltests")
library(modeltests)

skip_if_not_installed("maps")
ca <- maps::map("county", "ca", plot = FALSE, fill = TRUE)

test_that("tidy.map", {
  check_arguments(tidy.map)

  td <- tidy(ca)
  check_tidy_output(td, strict = FALSE)
  check_dims(td, expected_cols = 7)
})
