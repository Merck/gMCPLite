test_that("Test generateWeights using Bonferroni Holm graph", {
  bhG5 <- BonferroniHolm(5)
  g <- getMatrix(bhG5)
  w <- getWeights(bhG5)
  Weights <- generateWeights(g,w)

  int_hyp <- permutations(5)[-1,]
  Wts <- cbind(int_hyp,1/apply(int_hyp,1,sum)*int_hyp)
  expect_equal(unname(Weights), Wts)
})


test_that("Test generateWeights using fixed sequence", {
  fs2 <- fixedSequence(2)
  g <- getMatrix(fs2)
  w <- getWeights(fs2)

  Weights <- generateWeights(g,w)

  int_hyp <- permutations(2)[-1,]
  Wts <- cbind(int_hyp,matrix(c(0,1,
                                 1,0,
                                 1,0),byrow=TRUE,nrow=3))
  expect_equal(unname(Weights), Wts)
})


test_that("Test generateWeights using user-defined matrix and weights", {
  g <- matrix(c(0,0.4,
                0.3,0), byrow=TRUE,nrow=2)
  w <- c(0.3,0.7)
  Weights <- generateWeights(g,w)

  int_hyp <- permutations(2)[-1,]
  Wts <- cbind(int_hyp,matrix(c(0,0.82,
                                0.51,0,
                                0.3,0.7),byrow=TRUE,nrow=3))

  expect_equal(unname(Weights), Wts)
})
