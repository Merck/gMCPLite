
test_that("Test graph2matrix using Bonferroni Holm", {
  bhG5 <- BonferroniHolm(5)

  matrix <- matrix(0.25,5,5)
  diag(matrix) <- 0

  expect_equal(matrix, unname(graph2matrix(bhG5)))
})

test_that("Test graph2matrix using user-defined matrix and weights", {
  m <- matrix(runif(16), nrow=4)
  colnames(m) <- rownames(m) <- paste0("H",seq(1,4))
  diag(m) <- 0
  expect_equal(m, graph2matrix(matrix2graph(m)))

  weights <- c(0.1, 0.1, 0.1, 0)
  gR <- new("graphMCP", m=m, weights=weights)
  expect_equal(graph2matrix(gR), m)

})

test_that("Test graph2matrix using epsilon edges", {

  m<-rbind(H1=c("0",         "0",         "0.5",         "0.5"),
           H2=c("0",         "0",         "0.5",         "0.5"),
           H3=c("\\epsilon", "0",         "0",           "1-\\epsilon"),
           H4=c("0",         "\\epsilon", "1-\\epsilon", "0"))
  colnames(m) <- rownames(m)

  weights <- c(0.1, 0.1, 0.1, 0)
  gR <- new("graphMCP", m=m, weights=weights)
  expect_equal(graph2matrix(gR), m)
 })
