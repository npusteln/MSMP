clear all
close all
clc

toolpath = './';
addpath(genpath(toolpath));


%% Load data
nomImage   = 'teddy';
noiselevel = 10;
if strcmp(nomImage,'corridor')
    im_Left  = imread('corridor_l_original.tiff');
    im_Right = imread('corridor_r_original.tiff');
elseif strcmp(nomImage,'teddy') 
    im_Left  = (imread('im2.png'));
    im_Right = (imread('im6.png'));
end
param.K = 50;
[param.height,param.width,param.nbchannels] = size(im_Left);
im_Left  = double(im_Left) + noiselevel*randn(size(im_Left));
im_Right = double(im_Right)+ noiselevel*randn(size(im_Left));

%% Compute disparity
x1       = reshape(im_Left,param.height*param.width,param.nbchannels);
x2       = reshape(im_Right,param.height*param.width,param.nbchannels);


% Disparity vector
%-> gerer les occlusions.
x1d      = nan*zeros(param.height,param.width,param.nbchannels,param.K);
x1       = reshape(x1,param.height,param.width,param.nbchannels);
for k = 1:param.K
    x1d(:,1:end-k,:,k) = x1(:,k+1:end,:);
end
x1d      = x1d(:,1:end-param.K,:);
x2       = reshape(x2,param.height,param.width,param.nbchannels);
x2       = x2(:,1:end-param.K,:);
param.n  = size(x1d,1);
param.m  = size(x1d,2);
param.M  = param.n*param.m;
x1d      = reshape(x1d,param.n*param.m,param.nbchannels,param.K);
x2       = reshape(x2,param.n*param.m,param.nbchannels);


%% Parameters
param.c        = 1;
init           = initalization_param_stereo(param,x2, x1d);
param.coupling = 1;
param.mu       = init.mu;
param.lambda   = 50;                     % Set the regularity of the solution
param.iter     = 20;                  % number of iterations
param.epsilon  = 1e-20;                  % Stopping criterion
param.regtype  = 'diff';
param.tau      = 0.005;                   % Step-size parameter

% Algorithm improved
[xrec_gretsi,crit_gretsi]       = algo_MPMS(param);

% Display
figure(1)
subplot(131); imagesc(im_Left); title 'Left image';
subplot(132); imagesc(im_Right); title 'Right image';
subplot(133); imagesc(display_estimation(param,xrec_gretsi)); title 'Disparity';
