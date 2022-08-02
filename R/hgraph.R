#    Copyright (c) 2022 Merck & Co., Inc., Rahway, NJ, USA and its affiliates. All rights reserved.
#
#    This file is part of the gMCPLite program.
#
#    gMCPLite is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
#' Create multiplicity graphs using ggplot2
#'
#' Plots a multiplicity graph defined by user inputs.
#' The graph can also be used with the ***gMCP*** package to evaluate a set of
#' nominal p-values for the tests of the hypotheses in the graph.
#'
#' @param nHypotheses number of hypotheses in graph
#' @param nameHypotheses hypothesis names
#' @param alphaHypotheses alpha-levels or weights for ellipses
#' @param m square transition matrix of dimension `nHypotheses`
#' @param fill grouping variable for hypotheses
#' @param palette colors for groups
#' @param labels text labels for groups
#' @param legend.name text for legend header
#' @param legend.position text string or x,y coordinates for legend
#' @param halfWid half width of ellipses
#' @param halfHgt half height of ellipses
#' @param trhw transition box width
#' @param trhh transition box height
#' @param trprop proportion of transition arrow length where transition box is placed
#' @param digits number of digits to show for alphaHypotheses
#' @param trdigits digits displayed for transition weights
#' @param size text size in ellipses
#' @param boxtextsize transition text size
#' @param legend.textsize legend text size
#' @param arrowsize size of arrowhead for transition arrows
#' @param radianStart radians from origin for first ellipse; nodes spaced equally in clockwise order with centers on an ellipse by default
#' @param offset rotational offset in radians for transition weight arrows
#' @param xradius horizontal ellipse diameter on which ellipses are drawn
#' @param yradius vertical ellipse diameter on which ellipses are drawn
#' @param x x coordinates for hypothesis ellipses if elliptical arrangement is not wanted
#' @param y y coordinates for hypothesis ellipses if elliptical arrangement is not wanted
#' @param wchar character for alphaHypotheses in ellipses; defaults to the Unicode escape sequence \code{\\u03b1} (Greek letter alpha).
#' See \href{https://en.wikipedia.org/wiki/List_of_Unicode_characters}{list of Unicode characters} for a more comprehensive character list.
#' @return A `ggplot` object with a multi-layer multiplicity graph
#'
#' @examples
#' # Defaults: note clockwise ordering
#' hGraph(5)
#' # Add colors (default is 3 gray shades)
#' hGraph(3,fill=1:3)
#' # Colorblind palette
#' cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
#'                "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
#' hGraph(6,fill=as.factor(1:6),palette=cbPalette)
#' # Use a hue palette
#' hGraph(4,fill=factor(1:4),palette=scales::hue_pal(l=75)(4))
#' # different alpha allocation, hypothesis names and transitions
#' alphaHypotheses <- c(.005,.007,.013)
#' nameHypotheses <- c("ORR","PFS","OS")
#' m <- matrix(c(0,1,0,
#'               0,0,1,
#'               1,0,0),nrow=3,byrow=TRUE)
#' hGraph(3,alphaHypotheses=alphaHypotheses,nameHypotheses=nameHypotheses,m=m)
#' # Custom position and size of ellipses, change text to multi-line text
#' # Adjust box width
#' # add legend in middle of plot
#' hGraph(3,x=sqrt(0:2),y=c(1,3,1.5),size=6,halfWid=.3,halfHgt=.3, trhw=0.6,
#'        palette=cbPalette[2:4], fill = c(1, 2, 2),
#'        legend.position = c(.6,.5), legend.name = "Legend:", labels = c("Group 1", "Group 2"),
#'        nameHypotheses=c("H1:\n Long name","H2:\n Longer name","H3:\n Longest name"))
#'
#' @details
#' See vignette **Multiplicity graphs formatting using ggplot2**
#' for explanation of formatting.
#'
#' @importFrom grDevices gray.colors
#' @importFrom ggplot2 aes ggplot guide_legend stat_ellipse theme theme_void
#' geom_text geom_segment geom_rect scale_fill_manual element_text
#' @importFrom grid unit
#' @importFrom grDevices palette
#' @importFrom methods new show callNextMethod validObject
#' @importFrom stats qt qnorm uniroot reshape
#' @importFrom graphics legend
#' @importFrom utils capture.output
#' @rdname hGraph
#' @export hGraph
#'
# Workaround for roxygen2 bug <https://github.com/r-lib/roxygen2/issues/1186>
#' @usage
#' hGraph(
#'   nHypotheses = 4,
#'   nameHypotheses = paste("H", (1:nHypotheses), sep = ""),
#'   alphaHypotheses = 0.025/nHypotheses,
#'   m = matrix(array(1/(nHypotheses - 1), nHypotheses^2), nrow = nHypotheses) -
#'     diag(1/(nHypotheses - 1), nHypotheses),
#'   fill = 1,
#'   palette = grDevices::gray.colors(length(unique(fill)), start = 0.5, end = 0.8),
#'   labels = LETTERS[1:length(unique(fill))],
#'   legend.name = " ",
#'   legend.position = "none",
#'   halfWid = 0.5,
#'   halfHgt = 0.5,
#'   trhw = 0.1,
#'   trhh = 0.075,
#'   trprop = 1/3,
#'   digits = 5,
#'   trdigits = 2,
#'   size = 6,
#'   boxtextsize = 4,
#'   legend.textsize = size * 2.5,
#'   arrowsize = 0.02,
#'   radianStart = if ((nHypotheses)\%\%2 != 0) {
#'      pi * (1/2 + 1/nHypotheses)
#'  } else
#'     {
#'      pi * (1 + 2/nHypotheses)/2
#'  },
#'   offset = pi/4/nHypotheses,
#'   xradius = 2,
#'   yradius = xradius,
#'   x = NULL,
#'   y = NULL,
#'   wchar = "\u03b1"
#' )
hGraph <- function(
  nHypotheses = 4,
  nameHypotheses = paste("H", (1:nHypotheses), sep = ""),
  alphaHypotheses = 0.025/nHypotheses,
  m = matrix(array(1/(nHypotheses - 1), nHypotheses^2),
             nrow = nHypotheses) - diag(1/(nHypotheses - 1), nHypotheses),
  fill = 1,
  palette = grDevices::gray.colors(length(unique(fill)), start = .5, end = .8),
  labels = LETTERS[1:length(unique(fill))],
  legend.name = " ",
  legend.position = "none",
  halfWid = 0.5,
  halfHgt = 0.5,
  trhw = 0.1,
  trhh = 0.075,
  trprop = 1/3,
  digits = 5,
  trdigits = 2,
  size = 6,
  boxtextsize = 4,
  legend.textsize = size*2.5,
  arrowsize = 0.02,
  radianStart = if((nHypotheses)%%2 != 0) {
    pi * (1/2 + 1/nHypotheses) } else {
      pi * (1 + 2/nHypotheses)/2 },
  offset = pi/4/nHypotheses,
  xradius = 2,
  yradius = xradius,
  x = NULL,
  y = NULL,
  wchar = "\u03b1"
){
  #####################################################################
  # Begin: Internal functions
  #####################################################################
  ellipseCenters <- function(alphaHypotheses=NULL, digits=5, txt = letters[1:3], fill=1,
                             xradius = 2, yradius = 2, radianStart = NULL,
                             x=NULL, y=NULL, wchar='x'){
    ntxt <- length(txt)
    if (!is.null(x) && !is.null(y)){
      if (length(x)!=ntxt) stop("length of x must match # hypotheses")
      if (length(y)!=ntxt) stop("length of y must match # hypotheses")
    }else{
      if (is.null(radianStart)) radianStart <- if((ntxt)%%2!=0){pi*(1/2+1/ntxt)}else{
        pi * (1 + 2 / ntxt) / 2}
      if (!is.numeric(radianStart)) stop("radianStart must be numeric")
      if (length(radianStart) != 1) stop("radianStart should be a single numeric value")
      # compute middle of each rectangle
      radian <- (radianStart - (0:(ntxt-1))/ntxt*2*pi) %% (2*pi)
      x <- xradius * cos(radian)
      y <- yradius * sin(radian)
    }
    # create data frame with middle (x and y) of ellipses, txt, fill
    return(data.frame(x,y,
                      txt=paste(txt,'\n',wchar,'=',round(alphaHypotheses,digits),sep=""),
                      fill=as.factor(fill))
    )
  }


  makeEllipseData <- function(df=NULL,xradius=.5,yradius=.5){
    # hack to get ellipses around x,y with radii xradius and yradius
    w <- xradius/3.1
    h <- yradius/3.1
    df$n <- 1:nrow(df)
    x1 <- x2 <- x3 <- x4 <- df
    x1$y <- x1$y + h
    x2$y <- x2$y - h
    x3$x <- x3$x + w
    x4$x <- x4$x - w
    ellipses <- rbind(x1, x2, x3, x4)
    ellipses$txt=""
    return(ellipses)
  }

  makeTransitionSegments <- function(df=NULL, m=NULL, xradius=NULL, yradius=NULL, offset=NULL,
                                     trdigits=NULL, trprop=NULL, trhw=NULL, trhh=NULL){
    from <- to <- w <- y <- xend <- yend <- xb <- yb <- xbmin <- xbmax <- ybmin <- ybmax <- txt <- NULL
    # Create dataset records from transition matrix
    md <- data.frame(m)
    names(md) <- seq_len(nrow(m))
    md$from <- seq_len(nrow(md))
    md <- reshape(data = md, varying = seq_len(nrow(m)), v.names = "w", idvar = "from", timevar = "to", direction = "long")
    if(any(md$w < 0) | any(md$w > 1)){
      message("Note: The transition weights contain negative value or value beyond 1, which have been ignored. Please set eligible weights between 0 and 1")
    }
    md <- md[(md$w > 0) & (md$w <= 1), , drop = FALSE]


    # Get ellipse center centers for transitions
    df1 <- df[, c("x", "y"), drop = FALSE]
    df1$from <- seq_len(nrow(df1))

    df2 <- merge(md, df1, by = "from", all.x = TRUE)

    names(df1) <- c("xend", "yend", "to")
    df3 <- merge(df2, df1[, c("to", "xend", "yend"), drop = FALSE], by = "to", all.x = TRUE)
    df3$theta <- atan2((df3$yend - df3$y) * xradius, (df3$xend - df3$x) * yradius)
    df3$x1 <- df3$x; df3$x1end <- df3$xend; df3$y1 <- df3$y; df3$y1end <- df3$yend
    df3$x <- df3$x1 + xradius * cos(df3$theta + offset)
    df3$y <- df3$y1 + yradius * sin(df3$theta + offset)
    df3$xend <- df3$x1end + xradius * cos(df3$theta + pi - offset)
    df3$yend <- df3$y1end + yradius * sin(df3$theta + pi - offset)
    df3$xb <- df3$x + (df3$xend - df3$x) * trprop
    df3$yb <- df3$y + (df3$yend - df3$y) * trprop
    df3$xbmin <- df3$xb - trhw
    df3$xbmax <- df3$xb + trhw
    df3$ybmin <- df3$yb - trhh
    df3$ybmax <- df3$yb + trhh
    df3$txt <- as.character(round(df3$w,trdigits))

    return(
      df3[, c("from", "to", "w", "x", "y", "xend", "yend", "xb", "yb", "xbmin", "xbmax", "ybmin", "ybmax", "txt"), drop = FALSE]
    )
  }


  checkHGArgs <- function(nHypotheses =NULL, nameHypotheses =NULL, alphaHypotheses = NULL, m = NULL, fill = NULL,
                          palette = NULL, labels = NULL, legend = NULL, legend.name = NULL, legend.position = NULL, legend.textsize = NULL,
                          halfwid = NULL, halfhgt = NULL, trhw = NULL, trhh = NULL, trprop = NULL, digits = NULL,
                          trdigits = NULL, size = NULL, boxtextsize = NULL, arrowsize = NULL, radianStart = NULL,
                          offset = NULL, xradius = NULL, yradius = NULL, x = NULL, y = NULL, wchar='w')
  { if (!is.character(nameHypotheses)) stop("Hypotheses should be in a vector of character strings")
    ntxt <- length(nameHypotheses)
    if(!(is.numeric(xradius) & length(xradius) == 1 & xradius > 0)) stop("hGraph: xradius must be positive, > 0 and length 1")
    if(!(is.numeric(yradius) & length(yradius) == 1 & yradius > 0)) stop("hGraph: yradius must be positive, > 0 and length 1")
    # length of fill should be same as ntxt
    if(length(fill) != 1 & length(fill) != ntxt) stop("fill must have length 1 or number of hypotheses")
  }
  # Following is to eliminate R CMD check error related to defining variables
  #from <- halfhgt <- halfwid <- n <- palette <- theta <- to <- txt <- w <- x1 <- x1end <- xb <-
  #xbmax <- xbmin <- xend <- y1 <- y1end <- yb <- ybmax <- ybmin <- yend <- NULL
  #####################################################################
  # End: Internal functions
  #####################################################################

  # Check inputs
  checkHGArgs(nHypotheses, nameHypotheses, alphaHypotheses, m, fill,
              palette, labels, legend, legend.name, legend.position, legend.textsize, halfwid, halfhgt,
              trhw, trhh, trprop, digits, trdigits, size, boxtextsize,
              arrowsize, radianStart, offset, xradius, yradius, x, y, wchar)
  # Set up hypothesis data
  hData <- ellipseCenters(alphaHypotheses,
                          digits,
                          nameHypotheses,
                          fill = fill,
                          xradius = xradius,
                          yradius = yradius,
                          radianStart = radianStart,
                          x = x,
                          y = y,
                          wchar = wchar)
  # Set up ellipse data
  ellipseData <- makeEllipseData(df = hData, xradius = halfWid, yradius = halfHgt)
  # Set up transition data
  transitionSegments <- makeTransitionSegments(df = hData, m = m, xradius = halfWid, yradius = halfHgt, offset = offset,
                           trprop = trprop, trdigits = trdigits, trhw = trhw, trhh = trhh)
  # Layer the plot
  ggplot()+
    # plot ellipses
    stat_ellipse(data=ellipseData,
                 aes(x=x, y=y, group=n, fill=as.factor(fill)),
                 geom="polygon") +
    theme_void() +
    #following should be needed
    #   scale_alpha(guide="none") +
    scale_fill_manual(values=palette,
                      labels=labels,
                      guide_legend(legend.name)) +
    theme(legend.position = legend.position,
          legend.title = ggplot2::element_text(size = legend.textsize),
          legend.text = ggplot2::element_text(size = legend.textsize)) +
    # Add text
    geom_text(data=hData,aes(x=x,y=y,label=txt),size=size) +
    # Add transition arrows
    geom_segment(data = transitionSegments,
                 aes(x=x, y=y, xend=xend, yend=yend),
                 arrow = grid::arrow(length = grid::unit(arrowsize, "npc"))) +
    # Add transition boxes
    geom_rect(data = transitionSegments,
              aes(xmin = xbmin, xmax = xbmax, ymin = ybmin, ymax = ybmax),
              fill="white",color="black") +
    # Add transition text
    geom_text(data = transitionSegments, aes(x = xb, y = yb, label=txt), size = boxtextsize)
}

utils::globalVariables(c("from","halfhgt","halfwid","n","palette","theta","to","txt","w","x1","x1end","xb",
                         "xbmax","xbmin","xend","y1","y1end","yb","ybmax","ybmin","yend"))
