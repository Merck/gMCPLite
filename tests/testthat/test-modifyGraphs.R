test_that("Testing join graphs", {
  g1 <- BonferroniHolm(2)
  g2 <- BonferroniHolm(3)
  expect_warning(joinGraphs(g1, g2))
})

test_that("Testing subset graphs", {
  graph <- improvedParallelGatekeeping()
  subgraph(graph, c(TRUE, FALSE, TRUE, FALSE))
  subgraph(graph, c("H1", "H3"))
  expect_error(subgraph(graph, c(1,3)))
})
