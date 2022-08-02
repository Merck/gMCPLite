test_that("Test graphMCP using user-defined matrix and weights", {
  set.seed(1234)
  m <- matrix(runif(16), nrow=4)
  weights <- c(0.1, 0.1, 0.1, 0)
  gR <- new("graphMCP", m=m, weights=weights)

  expect_equal(unname(getWeights(gR)), weights)
  expect_equal(unname(getMatrix(gR)), m)
})

test_that("Test graphMCP using BonferroniHolm", {
  bhG5 <- BonferroniHolm(5)
  matrix <- matrix(0.25,5,5)
  diag(matrix) <- 0
  expect_equal(unname(getWeights(bhG5)), c(0.2, 0.2, 0.2, 0.2, 0.2))
  expect_equal(unname(getMatrix(bhG5)), matrix)
})


test_that("Test graphMCP using Fixed sequence", {
  fs3 <- fixedSequence(3)
  matrix <- matrix(0,3,3)
  matrix[1,2] <- matrix[2,3] <- 1
  expect_equal(unname(getWeights(fs3)), c(1,0,0))
  expect_equal(unname(getMatrix(fs3)), matrix)
})

test_that("Testing case using Bonferroni-based Test", {
  m <- matrix(0, nrow = 4, ncol = 4)
  m[1,3] <- m[2,4] <- m[3,2] <- m[4,1] <- 1
  w <- c(1/2, 1/2, 0, 0)
  p <- c(0.01, 0.005, 0.01, 0.5)
  a <- 0.05
  g <- matrix2graph(m, w)
  sigma <- matrix(1, nrow = 4, ncol = 4)

  result1 <- gMCP(g, pvalues=p, alpha=a)
  expect_equal(length(result1@graphs), 4)
  expect_equal(all(!result1@rejected), FALSE)
  expect_equal(length(result1@adjPValues), 4)

  result2 <- gMCP(g, pvalues=rep(0.1,4), alpha=a)
  expect_equal(length(result2@graphs), 1)
  expect_equal(all(!result2@rejected), TRUE)
  expect_equal(length(result2@adjPValues), 4)
})

test_that("testing case for getWeightStr",{
  g <- BonferroniHolm(4)
  expect_equal(apply(getWeightStr(g), c(1, 2), function(x) eval(parse(text = x))), g@m)
  expect_true(any(grepl(pattern = "\\\\frac", getWeightStr(g, LaTeX = TRUE))))


})
