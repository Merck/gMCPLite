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
 
fastgMCP <- function(m, w, p, a, keepWeights=TRUE) {
	if (length(a)>1) {
		warning("Only the first value of 'a' is used!")
	}
	n <- dim(m)[1]
	if (dim(m)[2]!=n || length(w)!=n || length(p)!=n) {
		stop("Wrong dimensions in fastgMCP call!")
	}
	result <- .C("cgMCP", oldM=as.double(m), oldW=as.double(w),
			p=as.double(p), a=as.double(a), n=as.integer(n),
			s=double(n), m = double(n*n), w = double(n),
			PACKAGE = "gMCPLite")
	return(list(m=matrix(result$m, nrow=n), w=result$w, rejected=(result$s==1)))
}
