test_that("test gPAD utility functions", {
  expect_equal(as.numeric(paste(to.binom(1000), collapse = "")), as.numeric(paste(rev(as.integer(intToBits(1000))), collapse="")))
  expect_error(to.binom(1000, n=3))

  parse.intersection(to.binom(1000))
  to.intersection(1000)
  to.intersection(c(999, 1000))

})
