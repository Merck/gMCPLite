test_that("Example Graphs Testing", {
  graphs <- list(BonferroniHolm(5),
                 parallelGatekeeping(),
                 improvedParallelGatekeeping(),
                 BauerEtAl2001(),
                 BretzEtAl2009a(),
                 BretzEtAl2009b(),
                 BretzEtAl2009c(),
                 BretzEtAl2011(),
                 HungEtWang2010(nu = 0.5, tau = 0.5, omega = 0.5),
                 HuqueAloshEtBhore2011(),
                 HommelEtAl2007(),
                 HommelEtAl2007Simple(),
                 MaurerEtAl1995(),
                 improvedFallbackI(weights=rep(1/3, 3)),
                 improvedFallbackII(weights=rep(1/3, 3)),
                 cycleGraph(nodes=paste("H",1:4,sep=""), weights=rep(1/4, 4)),
                 fixedSequence(5),
                 fallback(weights=rep(1/4, 4)),
                 generalSuccessive(weights = c(1/2, 1/2), gamma = 0.5, delta = 0.5),
                 simpleSuccessiveI(),
                 simpleSuccessiveII(),
                 truncatedHolm(gamma = 0.5),
                 FerberTimeDose2011(times=5, doses=3, w=1/2),
                 Ferber2011(w = 0.5),
                 Entangled1Maurer2012(),
                 Entangled2Maurer2012(),
                 WangTing2014(nu = 0.5, tau = 0.5)
  )

  set.seed(1234)
  for (graph in graphs) {
    if (class(graph) != "entangledMCP"){ # exclude entagleMCP testing for now
    p <- runif(length(graph@nodeAttr$rejected))
    result <- gMCP(graph = graph, pvalues = p)
    expect_equal(unname(result@rejected), unname(result@adjPValues < 0.05))
    }
    }




})
