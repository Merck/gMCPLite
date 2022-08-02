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
 
getLaTeXFraction <- function(x) {
  result <- c()
  for (nom in strsplit(as.character(getFractionString(x)), split = "/")) {
    if (length(nom) == 1) {
      result <- c(result, nom)
    } else {
      result <- c(result, paste("\\frac{", nom[1], "}{", nom[2], "}", sep = ""))
    }
  }
  return(result)
}
