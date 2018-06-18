/*
 * proj_decreasing.c - example in MATLAB External Interfaces
 *
 * Sort a vector (inVector) with a size N (size*nbpixels)
 * outputs a 1xN vector (outVector)
 *
 * The calling syntax is:
 *
 *		proj_decreasing(inVector,outVector,size,nbpixels)
 *
 * This is a MEX-file for MATLAB.
*/

#include <stdlib.h>
#include <stdio.h>
#include "mex.h"

/*
On suppose que x est allou?? en m??moire en amont, de m??me taille que x.
On suppose que length>=1 et nbpixels>=1.
*/
void projdecreasing (double* y, double* x, const unsigned int length, 
const unsigned int nbpixels) {
	
	/*if (length==0) return;*/
	int* indstart = malloc(length*sizeof(int)); /*starting indices of constant pieces of x*/
	int n = 0;
	int j;	/*number of segments -1*/
	int i;
	int j2;
	int offset=0;
	
	for (n=0; n<nbpixels; n++) {
		*indstart = offset;
		x[offset] = y[offset];
		j=0;
		/*the constant value of x over the j+1-th piece is stored in x[indstart[j]]*/
		for (i=offset+1; i<length+offset; i++)
		    if (y[i]>=x[indstart[j]]) {
		    	/*numerically robust update of the mean:*/
		        x[indstart[j]]+=(y[i]-x[indstart[j]])/(i-indstart[j]+1);      
		        while ((j>0)&&(x[indstart[j]]>=x[indstart[j-1]])) {
		        	j--;
		        	/*numerically robust update of the mean:*/
		        	x[indstart[j]]+=(x[indstart[j+1]]-x[indstart[j]])*
		        		((double)(i-indstart[j+1]+1)/(double)(i-indstart[j]+1));
		        }
		    } else {
		        indstart[++j] = i;
		        x[i] = y[i];
		    }
		for (j2=0; j2<j; j2++)
			for (i=indstart[j2]+1; i<indstart[j2+1]; i++)
				x[i] = x[indstart[j2]];
		for (i=indstart[j2]+1; i<length+offset; i++)
			x[i] = x[indstart[j2]];
		offset+=length;
	}
}




void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // check the params
    if (nrhs != 3)
        mexErrMsgTxt("This function takes 1 input");
    if (nlhs != 1)
        mexErrMsgTxt("This function gives 1 output");
    
    
    //

    double *inVector;       /* 1xN input matrix */
    int size;            /* size of matrix */
    int nbpixels;        /* size of matrix */
    double *outVector;      /* output matrix */
    
    /* get the value of the scalar input  
    multiplier = mxGetScalar(prhs[0]);*/
    
    /* create a pointer to the real data in the input matrix  */
    inVector = mxGetPr(prhs[0]);
    size = mxGetScalar(prhs[1]);
    nbpixels = mxGetScalar(prhs[2]);
    /* create the output matrix */
    plhs[0] = mxCreateDoubleMatrix(1,size*nbpixels,mxREAL);
    
    /* get a pointer to the real data in the output matrix */
    outVector = mxGetPr(plhs[0]);

    /* call the computational routine */
    projdecreasing(inVector,outVector,size,nbpixels);

}