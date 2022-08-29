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

checkValidWeights <- function(weights) {
  if(!is.numeric(weights)) {
    stop("Weights have to be numeric!")
  }
  if(any(is.na(weights) | is.infinite(weights))) {
    warning("Some of the weights are not real numbers. NA, NaN, Inf and -Inf are not supported.")
  }
  if(any(0 > weights | weights > 1 + .Machine$double.eps ^ 0.25)) {
    warning("Invalid weights: weights must be between 0 and 1")
  }
  if(sum(weights) > 1 + .Machine$double.eps ^ 0.25) {
    warning("Invalid weights: the sum of all weights must be less than 1")
  }
}

#' Substitute Epsilon
#'
#' Substitute Epsilon with a given value.
#'
#' For details see the given references.
#'
#' @param graph A graph of class \code{graphMCP} or class
#' \code{entangledMCP}.
#' @param eps A numeric scalar specifying a value for epsilon edges.
#' @return A graph where all epsilons have been replaced with the given value.
#' @author Kornelius Rohmeyer \email{rohmeyer@@small-projects.de}
#' @seealso \code{graphMCP}, \code{entangledMCP}
#' @keywords print graphs
#' @examples
#'
#'
#' graph <- improvedParallelGatekeeping()
#' graph
#' substituteEps(graph, eps=0.01)
#'
#'
#' @export substituteEps
substituteEps <- function(graph, eps=10^(-3)) {
  # Call this function recursivly for entangled graphs.
  if ("entangledMCP" %in% class(graph)) {
    for(i in 1:length(graph@subgraphs)) {
      graph@subgraphs[[i]] <- substituteEps(graph@subgraphs[[i]], eps)
    }
    return(graph)
  }
  # Real function:
  if (is.numeric(graph@m)) return(graph)
  m <- matrix(gsub("\\\\epsilon", eps, graph@m), nrow=length(getNodes(graph)))

  m2 <- matrix(sapply(m, function(x) {
    result <- try(eval(parse(text=x)), silent=TRUE);
    ifelse(class(result)=="try-error",NA,result)
  }), nrow=length(getNodes(graph)))

  if (all(is.na(m)==is.na(m2))) m <- m2
  rownames(m) <- colnames(m) <- getNodes(graph)
  graph@m <- m
  return(graph)
}

#' Replaces variables in a general graph with specified numeric values
#'
#' Given a list of variables and real values a general graph is processed and
#' each variable replaced with the specified numeric value.
#'
#'
#' @param graph A graph of class \code{graphMCP} or class
#' \code{entangledMCP}.
#' @param variables A named list with one or more specified real values, for example
#' \code{list(a=0.5, b=0.8, "tau"=0.5)} or \code{list(a=c(0.5, 0.8), b=0.8, "tau"=0.5)}.
#' If \code{ask=TRUE} and this list is
#' missing at all or single variables are missing from the list, the user is
#' asked for the values (if the session is not interactive an error is thrown).
#' For interactively entered values only single numbers are supported.
#' @param ask If \code{FALSE} all variables that are not specified are not
#' replaced.
#' @param partial IF \code{TRUE} only specified variables are replaced and
#' parameter \code{ask} is ignored.
#' @param expand Used internally. Don't use yourself.
#' @param list If \code{TRUE} the result will always be a list, even if only one
#' graph is returned in this list.
#' @return A graph or a matrix with variables replaced by the specified numeric
#' values. Or a list of theses graphs and matrices if a variable had more than one value.
#' @author Kornelius Rohmeyer \email{rohmeyer@@small-projects.de}
#' @seealso \code{graphMCP}, \code{entangledMCP}
#' @keywords print graphs
#' @examples
#'
#' graph <- HungEtWang2010()
#' replaceVariables(graph, list("tau"=0.5,"omega"=0.5, "nu"=0.5))
#' replaceVariables(graph, list("tau"=c(0.1, 0.5, 0.9),"omega"=c(0.2, 0.8), "nu"=0.4))
#'
#' @export replaceVariables
replaceVariables <-function(graph, variables=list(), ask=TRUE, partial=FALSE, expand=TRUE, list=FALSE) {
  if (expand) variables <- varcombs(variables)
  if (is.list(variables[[1]])) {
    result <- list()
    for (v in variables) {
      r2 <- replaceVariables(graph, variables=v, ask=ask, partial=partial, expand=FALSE)
      attr(r2, "label") <- attr(v, "label")
      attr(r2, "variables") <- unlist(v)
      result <- c(result, list(r2))
    }
    if (length(result)==1 && !list) return(result[[1]])
    return(result)
  }
  # Call this function recursivly for entangled graphs.
  if ("entangledMCP" %in% class(graph)) {
    for(i in 1:length(graph@subgraphs)) {
      graph@subgraphs[[i]] <- replaceVariables(graph@subgraphs[[i]], variables=variables, ask=ask,   partial=partial)
    }
    return(graph)
  }
  # Real function:
  greek <- c("alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta",
             "theta", "iota", "kappa", "lambda", "mu", "nu", "xi",
             "omicron", "pi", "rho", "sigma", "tau", "nu", "phi",
             "chi", "psi", "omega")
  if (is.matrix(graph)) { m <- graph } else {m <- graph@m}
  for (g in c(greek,  letters)) {
    if (length(grep(g, m))!=0) {
      if (is.null(answer <- variables[[g]])) {
        if (!partial && ask) {
          if(interactive()) {
            answer <- readline(paste("Value for variable ",g,"? ", sep=""))
          } else {
            stop(paste("Value for variable",g,"not specified."))
          }
        }
      }
      if(!is.null(answer)) {
        m <- gsub(paste(ifelse(nchar(g)==1,"","\\\\"), g, sep=""), answer, m)
      }
    }
  }
  if (is.matrix(graph)) return(parse2numeric(m))
  graph@m <- m
  return(parse2numeric(graph))
}

# Parses matrices of graphs (simple and entangled)
#
# Parses matrices of graphs (simple and entangled) when values are of type character, e.g. "1/3".
#
# @param g Graph of class \code{graphMCP} or \code{entangledMCP}.
# @param force Logical whether conversion to numeric should be forced or not.
# If forced all values that could not be parsed will be \code{NA}.
# Otherwise the original unchanged graph will be returned.
# @author Kornelius Rohmeyer \email{rohmeyer@@small-projects.de}
# @keywords Converted graph (if all values could be parsed or \code{force=TRUE}) or original graph.
# @examples
#
# # Nothing changes:
# gMCP:::parse2numeric(HungEtWang2010())
# # Note that other methods like printing don't handle NAs well:
# gMCP:::parse2numeric(HungEtWang2010(), force=TRUE)
#
parse2numeric <- function(graph, force=FALSE) {
  # Call this function recursivly for entangled graphs.
  if ("entangledMCP" %in% class(graph)) {
    for(i in 1:length(graph@subgraphs)) {
      graph@subgraphs[[i]] <- parse2numeric(graph@subgraphs[[i]])
    }
    return(graph)
  }
  # Real function:
  if (is.matrix(graph)) { m <- graph } else {m <- graph@m}
  names <- rownames(m)
  m <- matrix(sapply(m, function(x) {
    result <- try(eval(parse(text=x)), silent=TRUE);
    ifelse(class(result)=="try-error",NA,result)
  }), nrow=dim(m)[1])
  if (!force && any(is.na(m))) return(graph)
  rownames(m) <- colnames(m) <- names
  if (is.matrix(graph)) return(m)
  graph@m <- m
  return(graph)
}

isEpsilon <- function(w) {
  x <- try(eval(parse(text = gsub("\\\\epsilon", 0, w)), envir = baseenv()), silent=TRUE)
  if ("try-error" %in% class(x)) return(FALSE)
  return(x==0)
}

# For testing purposes: variables <- list(a=c(1,2), b=(3), x=c(2,3,4), d=c(1,2))
varcombs <- function(variables) {
  combs <- list()
  m <- do.call(expand.grid, lapply(variables, function(x){1:length(x)}))
  for (i in 1:dim(m)[1]) {
    variablesII <- rep(0, length(variables))
    for(k in 1:length(variables)) {
      variablesII[k] <- variables[[k]][m[i,k]]
    }
    names(variablesII) <- names(variables)
    x <- as.list(variablesII)
    attr(x, "label") <- paste(paste(names(variables),"=",variablesII,sep=""), collapse=", ")
    combs <- c(combs, list(x))
  }
  # GII <- replaceVariables(G, as.list(variablesII))
  # additionalLabel <- paste(",", paste(paste(names(variables),"=",variablesII,sep=""), collapse=", "))
  return(combs)
}

#' Create a Block Diagonal Matrix with NA outside the diagonal
#'
#' Build a block diagonal matrix with NA values outside the diagonal given
#' several building block matrices.
#'
#' This function is useful to build the correlation matrices, when only
#' partial knowledge of the correlation exists.
#'
#' @param ...  individual matrices or a \code{list} of matrices.
#' @return A block diagonal matrix with NA values outside the diagonal.
#' @author Kornelius Rohmeyer \email{rohmeyer@@small-projects.de}
#' @seealso \code{\link{gMCP}}
#' @examples
#' bdiagNA(diag(3), matrix(1/2,nr=3,nc=3), diag(2))
#'
#' @export bdiagNA
bdiagNA <- function(...) {
  if (nargs() == 0)
    return(matrix(nrow=0, ncol=0))
  if (nargs() == 1 && !is.list(...))
    return(as.matrix(...))
  asList <- if (nargs() == 1 && is.list(...)) list(...)[[1]] else list(...)
  if (length(asList) == 1)
    return(as.matrix(asList[[1]]))
  n <- 0
  for (m in asList) {
    if (!is.matrix(m)) {
      stop("Only matrices are allowed as arguments.")
    }
    if (dim(m)[1]!=dim(m)[2]) {
      stop("Only quadratic matrices are allowed.")
    }
    n <- n + dim(m)[1]
  }
  M <- matrix(NA, nrow=n, ncol=n)
  k <- 0
  for (m in asList) {
    for (i in 1:dim(m)[1]) {
      for (j in 1:dim(m)[1]) {
        M[i+k,j+k] <- m[i,j]
      }
    }
    k <- k + dim(m)[1]
  }
  return(M)
}

#' Check correlation matrix
#'
#' Sanity checks for the correlation matrix.
#'
#' @param m TBA
#' @param returnMessage TBA
#' @param na.allowed TBA
#'
#' @details
#' Checks the following properties:
#' \itemize{
#'   \item Values must be between -1 and 1.
#'   \item Diagonal must be equal to 1.
#'   \item Matrix must be symmetric.
#' }
#'
#' @return Logical
#'
#' @export checkCorrelation
#'
#' @examples
#' NULL
checkCorrelation <- function(m, returnMessage = FALSE, na.allowed = TRUE) {
  if (!na.allowed && any(is.na(m))) {
    if (returnMessage) {
      return("Matrix can not contain NAs.")
    }
    return(FALSE)
  }
  if (!is.numeric(m) || !is.matrix(m)) {
    if (returnMessage) {
      return("Matrix must be a numeric matirx.")
    }
    return(FALSE)
  }
  if (!isTRUE(all.equal(1, max(1, max(abs(m)[!is.na(m)]))))) {
    if (returnMessage) {
      return("Values must be between -1 and 1.")
    }
    return(FALSE)
  }
  if (!isTRUE(all.equal(diag(m), rep(1, dim(m)[1]), check.attributes = FALSE))) {
    if (returnMessage) {
      return("Diagonal must be equal to 1.")
    }
    return(FALSE)
  }
  if (!isSymmetric(unname(m))) {
    if (returnMessage) {
      return("Matrix must be symmetric.")
    }
    return(FALSE)
  }
  return(TRUE)
}

# Calculation time note: n=22 needs 12 seconds on my computer.
# With each further step calculation time nearly doubles.

#' Permutation for a design matrix
#'
#' @param n dimension of the matrix
#'
#' @return a n*(2^n) dimensional matrix
#'
#' @examples
#' permutations(3)
#'
#' @export permutations
#'
permutations <- function(n) {
  outer(
    (1:(2^n)) - 1, (n:1) - 1,
    FUN = function(x, y) {
      (x %/% 2^y) %% 2
    }
  )
}

#' Placement of graph nodes
#'
#' Places the nodes of a graph according to a specified layout.
#'
#' If one of \code{nrow} or \code{ncol} is not given, an attempt is made to
#' infer it from the number of nodes of the \code{graph} and the other
#' parameter.  If neither is given, the graph is placed as a circle.
#'
#' @param graph A graph of class \code{graphMCP} or class
#' \code{entangledMCP}.
#' @param nrow The desired number of rows.
#' @param ncol The desired number of columns.
#' @param byrow Logical whether the graph is filled by rows (otherwise by
#' columns).
#' @param topdown Logical whether the rows are filled top-down or bottom-up.
#' @param force Logical whether a graph that has already a layout should be
#' given the specified new layout.
#' @return The graph with nodes placed according to the specified layout.
#' @author Kornelius Rohmeyer \email{rohmeyer@@small-projects.de}
#' @seealso \code{graphMCP}, \code{entangledMCP}
#' @keywords graphs
#' @examples
#'
#'
#' g <- matrix2graph(matrix(0, nrow=6, ncol=6))
#'
#' g <- placeNodes(g, nrow=2, force=TRUE)
#'
#'
#' @export placeNodes
placeNodes <- function(graph, nrow, ncol, byrow = TRUE, topdown = TRUE, force = FALSE) {
  entangled <- NULL
  # If the graph is entangled only place the nodes of the first graph
  if ("entangledMCP" %in% class(graph)) {
    entangled <- graph
    graph <- entangled@subgraphs[[1]]
  }
  # Only place nodes if  no placement data exists or parameter force is set to TRUE
  if (is.null(graph@nodeAttr$X) || force) {
    n <- length(getNodes(graph))
    if (missing(nrow) && missing(ncol)) {
      v <- (1:n)/n*2*pi
      nodeX <- 300 + 250*sin(v)
      nodeY <- 300 + 250*cos(v)
    } else {
      if (missing(nrow)) {
        nrow <- ceiling(length(getNodes(graph))/ncol)
      }
      if (missing(ncol)) {
        ncol <- ceiling(length(getNodes(graph))/nrow)
      }
      # if nrow*ncol<n increase the number of rows
      if (nrow*ncol<n) {
        nrow <- ceiling(length(getNodes(graph))/ncol)
      }
      if (byrow) {
        nodeX <- rep(((1:ncol)-1)*200+100, nrow)
        nodeY <- rep(((1:nrow)-1)*200+100, each = ncol)
      } else {
        nodeX <- rep(((1:ncol)-1)*200+100, each = nrow)
        nodeY <- rep(((1:nrow)-1)*200+100, ncol)
      }
      if (!topdown) nodeY <- max(nodeY) - nodeY + 100
    }
    graph@nodeAttr$X <- nodeX[1:n]
    graph@nodeAttr$Y <- nodeY[1:n]
    for (i in getNodes(graph)) {
      for (j in getNodes(graph)) {
        if (graph@m[i,j]!=0) {
          edgeAttr(graph, i, j, "labelX") <- -100
          edgeAttr(graph, i, j, "labelY") <- -100
        }
      }
    }
  }
  if (!is.null(entangled)) {
    entangled@subgraphs[[1]] <- graph
    return(entangled)
  }
  return(graph)
}
