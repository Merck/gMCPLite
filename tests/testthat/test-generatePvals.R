test_that("Test generatePvals using Bonferroni Holm", {
  bhG5 <- BonferroniHolm(5)
  g <- getMatrix(bhG5)
  w <- getWeights(bhG5)
  obs_pvals <- c(0.001,0.02,0.1,0.3,0.04)
  c<-diag(1,5,5)
  Pvals <- generatePvals(g,w,cr=c,p=obs_pvals,adjusted=TRUE)
  expect_equal(Pvals, unname(gMCP(bhG5, obs_pvals,correlation=c)@adjPValues))
})


test_that("Test generatePvals using user-defined matrix and weights", {
  g <- matrix(c(0,0.5,
                0.5,0), byrow=TRUE,nrow=2)
  w <- c(1/2,1/2)
  c<-diag(1,2,2)
  obs_pvals <- c(0.001,0.04)

  Pvals <- generatePvals(g,w,cr=c,p=obs_pvals,adjusted=TRUE)

  gR <- new("graphMCP", m=g, weights=w)
  expect_equal(Pvals, unname(gMCP(gR, obs_pvals,test='parametric',correlation=c)@adjPValues))
})
