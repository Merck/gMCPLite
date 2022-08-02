m <- matrix(0, nrow = 4, ncol = 4)
m[1,3] <- m[2,4] <- m[3,2] <- m[4,1] <- 1
w <- c(1/2, 1/2, 0, 0)
p1 <- c(0.01, 0.005, 0.01, 0.5)
p2 <- c(0.01, 0.005, 0.015, 0.022)
a <- 0.05
g <- matrix2graph(m, w)
sigma <- matrix(1, nrow = 4, ncol = 4)

test_that("Testing case using Bonferroni-based Test", {

  result1 <- gMCP(g, pvalues=p1, alpha=a)
  result2 <- gMCP(g, pvalues=p2, alpha=a, verbose = FALSE)

  expect_equal(unname(result1@rejected), c(TRUE, TRUE, TRUE, FALSE))
  expect_equal(unname(result1@adjPValues) < a, c(TRUE, TRUE, TRUE, FALSE))

  expect_equal(unname(result2@rejected), c(TRUE, TRUE, TRUE, TRUE))
  expect_equal(unname(result2@adjPValues) < a, c(TRUE, TRUE, TRUE, TRUE))

  # missing test and correlation, enable verbose
  result3 <- gMCP(g, pvalues=rep(0.1,4),  alpha=a, adjPValues = FALSE, verbose = TRUE)
  expect_equal(unname(result3@rejected), c(FALSE, FALSE, FALSE, FALSE))

  # UseC and no upscalse
  result4 <- gMCP(g, pvalues=p1,  alpha=a, useC = TRUE, upscale = FALSE)
  expect_equal(unname(result4@rejected), c(TRUE, TRUE, TRUE, FALSE))

  # all w = 0
  w1 <- c(0, 0, 0, 0)
  g1 <- matrix2graph(m, w1)
  result5 <- gMCP(g1, pvalues=p1,  alpha=a)
  expect_equal(unname(result5@rejected), c(FALSE, FALSE, FALSE, FALSE))


})

test_that("Testing case using weighted Simes' Test", {

  result1 <- gMCP(g, pvalues=p1, test="Simes", alpha=a)
  result2 <- gMCP(g, pvalues=p2, test="Simes", alpha=a)

  expect_equal(unname(result1@rejected), c(TRUE, TRUE, TRUE, FALSE))
  expect_equal(unname(result1@adjPValues) < a, c(TRUE, TRUE, TRUE, FALSE))

  expect_equal(unname(result2@rejected), c(TRUE, TRUE, TRUE, TRUE))
  expect_equal(unname(result2@adjPValues) < a, c(TRUE, TRUE, TRUE, TRUE))

  #adjPval = FALSE
  result3 <- gMCP(g, pvalues=p1, test="Simes", alpha=a, adjPValues = FALSE)
  expect_equal(unname(result3@rejected), c(TRUE, TRUE, TRUE, FALSE))
  expect_equal(unname(result3@adjPValues) , numeric(0))

  result4 <- gMCP(g, pvalues=rep(0.1, 4), test="Simes", alpha=a, adjPValues = FALSE)
  expect_equal(unname(result4@rejected), rep(FALSE, 4))

  result5 <- gMCP(g, pvalues=rep(0.01, 4), test="Simes", alpha=a, adjPValues = FALSE)
  expect_equal(unname(result5@rejected), rep(TRUE, 4))

})

test_that("Testing case using parametric Test", {

  result1 <- gMCP(g, pvalues=p1, test="parametric", alpha=a, correlation = sigma)

  expect_equal(unname(result1@rejected), c(TRUE, TRUE, TRUE, FALSE))
  expect_equal(unname(result1@adjPValues) < a, c(TRUE, TRUE, TRUE, FALSE))

})

test_that("Testing case for error/warning exceptions", {

  # matrix not numeric
  m[2,1] <- "unknown"
  g1 <- matrix2graph(m, w)
  expect_error(gMCP(g1, pvalues=p1,  alpha=a))

  # pvalue length different from # of nodes
  p <- c(0.01, 0.005, 0.01)
  expect_error(gMCP(g, pvalues=p,  alpha=a))

  # upscale warnings
  expect_warning(gMCP(g, pvalues=p1, test="Bretz2011", alpha=a, correlation = sigma, upscale = FALSE))
  expect_warning(gMCP(g, pvalues=p1, test="simple-parametric", alpha=a, correlation = sigma, upscale = TRUE))

  # unknown test error
  expect_error(gMCP(g, pvalues=p1, test="Unknowntest", alpha=a))

})
