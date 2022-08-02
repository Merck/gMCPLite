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
 
to.binom <- function(int, n = floor(log2(int)) + 1) {
  # 6 times faster than the old function (Thank you!)
  if (n + 2 <= floor(log2(int))) {
    stop("Vector length to small to hold binary number")
  }
  ((int) %/% 2^((n:1) - 1)) %% 2
}

parse.intersection <- function(binom) {
  paste("H(", paste(which(binom == 1), collapse = ","), ")", sep = "")
}

to.intersection <- function(int) {
  maxn <- floor(log2(max(int))) + 1
  if (length(int) > 1) {
    unlist(lapply(lapply(int, to.binom, n = maxn), parse.intersection))
  } else {
    parse.intersection(to.binom(int, n = maxn))
  }
}
