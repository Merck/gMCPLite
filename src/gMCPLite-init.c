#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .C calls */
extern void cgMCP(double *, double *, double *, double *, int *, double *, double *, double *);
extern void graphmult(double *, double *, double *, double *, double *, double *, double *, double *, double *, int *, int *, int *, int *, int *);
extern void graphproc(double *, double *, double *, double *, int *, double *, int *, int *, int *);

static const R_CMethodDef CEntries[] = {
    {"cgMCP",     (DL_FUNC) &cgMCP,      8},
    {"graphmult", (DL_FUNC) &graphmult, 14},
    {"graphproc", (DL_FUNC) &graphproc,  9},
    {NULL, NULL, 0}
};

void R_init_gMCPLite(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
