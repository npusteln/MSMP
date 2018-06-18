% demo_Segmentation.m
%
% Solve the minimal partition problem with a minimal proximal splitting 
% technique
% N. Pustelnik, L. Condat, Proximity operator of a sum of functions;
% Application to depth map estimation, IEEE Signal Processing Letters,
% vol. 24, no. 12, Dec. 2017.
%
% N. Pustelnik. Version: 04-June-2018.

clear all; close all; clc

toolpath = './';
addpath(genpath(toolpath));


%% Load data
x                                    = imread('parrots_orig.png');
noiselevel                           = 5;
z  = double(x(113:512,1:400,:))+noiselevel*randn(size(x(113:512,1:400,:)));
z0                                   = z;
figure(1)
imagesc(rescale(z));axis image off;

%% Select the label
param.K = str2num(input('Select a number of label:','s'));

title('Select the label by picking a color on the image');
for i=1:param.K
    [x,y]= ginput(1);
    label(i,:) = z(round(y),round(x),:);
    labeldisp(i,1,:) = label(i,:);

end
[param.n,param.m,param.nbchannels]   = size(z0);
figure(2)
imagesc(rescale(labeldisp));axis image off;
pause(0.1);


%% Parameters
param.M         = param.n*param.m;
z               = reshape(z,param.M,param.nbchannels);
param.moyenne = zeros(3,param.K);
for k=1:param.K
    param.moyenne(:,k) = label(k,:);
end
param.c        = 1;
init           = initalization_param_segmentation(param,z, label);
param.coupling = 1;
param.mu       = init.mu;
param.lambda   = 1000;                     % Set the regularity of the solution
param.iter     = 30;                  % number of iterations
param.epsilon  = 1e-20;                  % Stopping criterion
param.regtype  = 'diff';
param.tau      = 0.1/param.lambda;                   % Step-size parameter

%% Proposed algorithm
[xrec_gretsi,crit_gretsi]       = algo_MPMS(param);

%% Display
figure(1)
subplot(121); imagesc(rescale(reshape(z,param.n,param.m,param.nbchannels))); title 'Left image';axis image off;
subplot(122); imagesc(rescale(display_segmentation(param,xrec_gretsi))); title 'Segmentation';axis image off;
