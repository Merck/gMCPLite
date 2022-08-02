test_that("Test graphTest using entangled graph", {
  G1 <- rbind(c(0,0.5,0.5,0,0), c(0,0,1,0,0),
              c(0, 0, 0, 1-0.01, 0.01), c(0, 1, 0, 0, 0),
              c(0, 0, 0, 0, 0))
  G2 <- rbind(c(0,0,1,0,0), c(0.5,0,0.5,0,0),
              c(0, 0, 0, 0.01, 1-0.01), c(0, 0, 0, 0, 0),
              c(1, 0, 0, 0, 0))
  weights <- rbind(c(1, 0, 0, 0, 0), c(0, 1, 0, 0, 0))
  pvals <- c(0.024, 0.05, 0.01, 0.003, 0.009)
  out <- graphTest(pvals, weights, alpha=c(0.0125, 0.0125), G=list(G1, G2), verbose = TRUE)
  graph1 <- matrix2graph(G1, weights[1,])
  graph2 <- matrix2graph(G2, weights[2,])
  graph <- new("entangledMCP", subgraphs=list(graph1, graph2), weights=c(0.5,0.5))
  out_from_objects <- graphTest(pvals, alpha=0.025, graph=graph, verbose = TRUE)

  expect_error(convert(graph1))

})
