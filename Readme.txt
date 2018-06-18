

***************************************************************************
* author: Nelly Pustelnik   (nelly.pustelnik@ens-lyon.fr)                 *
* institution: CNRS, laboratoire de Physique de l'ENS de Lyon             *
* date: Saturday, October 30 2010                                         *
* License CeCILL-B                                                        *
*                                                                         *             
% Contributors :                                                          *
% Laurent Condat (laurent.condat@gipsa-lab.grenoble-inp.fr)               *
*                                                                         *                                                      
***************************************************************************
*********************************************************
* RECOMMENDATIONS:                                   	*
* This toolbox is designed to work with Matlab 2015.b   *
*********************************************************

------------------------------------------------------------------------------------------------------------------------
DESCRIPTION:
Proximal splitting algorithms for convex optimization are largely used in 
signal and image processing. They make possible to call the individual 
proximity operators of an arbitrary number of functions, whose sum is to 
be minimized. But the larger this number, the slower the convergence. 
In this work, we show how to compute the proximity operator of a sum of two
 functions, for a certain type of functions operating on objects having a 
graph structure. The gain provided by avoiding unnecessary splitting is 
illustrated by an application to image segmentation and depth map estimation. 


 How to run
============

 1. compile the mex files :
cd include/
mex proj_decreasing_mex.c


 2. run the demo files :
- segmentation: "demo_segmentation.m" or "demo_segmentation_comp.m" 
- disparity map: "demo_disparitymap.m" or "demo_disparitymap_comp.m" 


The main function is "algo_MPMS".

------------------------------------------------------------------------------------------------------------------------
RELATED PUBLICATION:

# N. Pustelnik, L. Condat, Proximity operator of a sum of functions;
% Application to depth map estimation, IEEE Signal Processing Letters,
% vol. 24, no. 12, Dec. 2017

------------------------------------------------------------------------------------------------------------------------