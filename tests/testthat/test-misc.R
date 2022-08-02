test_that("testing cases for checking valid weights", {
  expect_error(checkValidWeights(matrix("a", nrow = 2, ncol =2)))
  expect_error(suppressWarnings(checkValidWeights(matrix(c(0, NA, 0, 0), nrow = 2, ncol =2))))
  expect_warning(checkValidWeights(matrix(-0.1, nrow = 2, ncol =2)))
  expect_warning(checkValidWeights(matrix(0.55, nrow = 2, ncol =2)))
})

test_that("test bdigNA", {
  expect_equal(bdiagNA(), matrix(nrow=0, ncol=0))
  expect_equal(bdiagNA(diag(3)), diag(3))
  expect_equal(dim(bdiagNA(diag(3), matrix(1/2,nr=3,nc=3), diag(2))), rep(3+3+2, 2))
})

test_that("test correlation matrix", {
  expect_false(checkCorrelation(matrix(c(0, NA, 0, 0), nrow = 2, ncol =2), returnMessage = FALSE, na.allowed = FALSE))
  expect_equal(checkCorrelation(matrix(c(0, NA, 0, 0), nrow = 2, ncol =2), returnMessage = TRUE, na.allowed = FALSE), "Matrix can not contain NAs.")
  expect_false(checkCorrelation(matrix(c(0, "a", 0, 0), nrow = 2, ncol =2), returnMessage = FALSE, na.allowed = FALSE))
  expect_equal(checkCorrelation(matrix(c(0, "a", 0, 0), nrow = 2, ncol =2), returnMessage = TRUE, na.allowed = FALSE), "Matrix must be a numeric matirx.")
  expect_false(checkCorrelation(matrix(2, nrow = 2, ncol =2), returnMessage = FALSE, na.allowed = FALSE))
  expect_equal(checkCorrelation(matrix(2, nrow = 2, ncol =2), returnMessage = TRUE, na.allowed = FALSE), "Values must be between -1 and 1.")
  expect_false(checkCorrelation(matrix(0.5, nrow = 2, ncol =2), returnMessage = FALSE, na.allowed = FALSE))
  expect_equal(checkCorrelation(matrix(0.5, nrow = 2, ncol =2), returnMessage = TRUE, na.allowed = FALSE), "Diagonal must be equal to 1.")
  expect_false(checkCorrelation(matrix(c(1,0,0.5,1), nrow = 2, ncol =2), returnMessage = FALSE, na.allowed = FALSE))
  expect_equal(checkCorrelation(matrix(c(1,0,0.5,1), nrow = 2, ncol =2), returnMessage = TRUE, na.allowed = FALSE), "Matrix must be symmetric.")
  expect_true(checkCorrelation(matrix(c(1,0.5,0.5,1), nrow = 2, ncol =2)))
})

