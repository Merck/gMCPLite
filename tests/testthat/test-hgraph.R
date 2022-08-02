test_that("Testing cases for multiplicity graphs with ggplot2", {
  hGraph(6)

  cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
                 "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  hGraph(6,fill=as.factor(1:6),palette=cbPalette)

  hGraph(3,x=sqrt(0:2),y=c(1,3,1.5),size=6,halfWid=.3,halfHgt=.3, trhw=0.6,
         palette=cbPalette[2:4], fill = c(1, 2, 2),
         legend.position = c(.6,.5), legend.name = "Legend:", labels = c("Group 1", "Group 2"),
         nameHypotheses=c("H1:\n Long name","H2:\n Longer name","H3:\n Longest name"))

})
