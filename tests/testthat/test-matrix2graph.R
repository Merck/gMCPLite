test_that("Test matrix2graph using user-defined matrix and weights", {
  m <- matrix(runif(16), nrow=4)
  colnames(m) <- rownames(m) <- paste0("H",seq(1,4))
  diag(m) <- 0
  expect_equal(m, graph2matrix(matrix2graph(m)))
  expect_equal(m, getMatrix(matrix2graph(m)))
})

test_that("Test matrix2graph using epsilon edges", {

  m<-rbind(H1=c("0",         "0",         "0.5",         "0.5"),
           H2=c("0",         "0",         "0.5",         "0.5"),
           H3=c("\\epsilon", "0",         "0",           "1-\\epsilon"),
           H4=c("0",         "\\epsilon", "1-\\epsilon", "0"))
  colnames(m) <- rownames(m)

  expect_equal(m, graph2matrix(matrix2graph(m)))
  expect_equal(m, getMatrix(matrix2graph(m)))
})
