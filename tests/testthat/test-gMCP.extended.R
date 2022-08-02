test_that("Testing case using Bonferroni-based Test", {
  expect_equal(bonferroni.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0)), 0.2)
  expect_false(bonferroni.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), adjPValues=FALSE))
})

test_that("Testing case using weighted parametric Test", {
  expect_equal(parametric.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), correlation = diag(3)), 0.19)
  expect_false(parametric.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), correlation = diag(3), adjPValues=FALSE))
})

test_that("Testing case using trimmed simes Test", {
  expect_error(bonferroni.trimmed.simes.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), adjPValues = TRUE))
  expect_false(bonferroni.trimmed.simes.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), adjPValues=FALSE))
  expect_false(bonferroni.trimmed.simes.test(pvalues=c(0.1,0.2), weights=c(0.5,0.5), adjPValues=FALSE))


  graph <- BonferroniHolm(4)
  pvalues <- c(0.01, 0.05, 0.03, 0.02)
  g <- gMCP.extended(graph=graph, pvalues=pvalues, test=bonferroni.trimmed.simes.test, adjPValues = FALSE)
  expect_equal(unname(g@rejected), c(TRUE, FALSE, FALSE, FALSE))
  })

test_that("Testing case using Simes on suebset Test",{
  expect_equal(simes.on.subsets.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0)), 0.2)
  expect_false(simes.on.subsets.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), adjPValues = FALSE))

  graph <- BonferroniHolm(4)
  pvalues <- c(0.01, 0.05, 0.03, 0.02)
  g <- gMCP.extended(graph=graph, pvalues=pvalues, test=simes.on.subsets.test, subsets=list(1:2, 3:4))
  expect_equal(unname(g@rejected), c(TRUE, FALSE, FALSE, FALSE))
})

test_that("Testing case using weighted Simes Test",{
  expect_equal(simes.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0)), 0.2)
  expect_false(simes.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), adjPValues = FALSE))

  graph <- BonferroniHolm(4)
  pvalues <- c(0.01, 0.05, 0.03, 0.02)
  g <- gMCP.extended(graph=graph, pvalues=pvalues, test=simes.test)
  expect_equal(unname(g@rejected), c(TRUE, TRUE, TRUE, TRUE))
})
