clear all
close all
clc

toolpath = './';
addpath(genpath(toolpath));


%% Load data
nomImage   = 'corridor';
noiselevel = 10;
if strcmp(nomImage,'corridor')
    load corridor.mat
    im_Left  = imread('corridor_l_original.tiff');
    im_Right = imread('corridor_r_original.tiff');
elseif strcmp(nomImage,'teddy') 
    im_Left  = (imread('im2.png'));
    im_Right = (imread('im6.png'));
end
param.K = 20;
[param.height,param.width,param.nbchannels] = size(im_Left);
im_Left  = double(im_Left) + noiselevel*randn(size(im_Left));
im_Right = double(im_Right)+ noiselevel*randn(size(im_Left));
indl = 180:240;
indc = 100:160;
figure(2);imagesc(rescale(im_Right(indl,indc))); axis image off; colormap(gray);
figure(3);imagesc(rescale(im_Left(indl,indc)));  axis image off; colormap(gray);
%% Compute disparity
x1       = reshape(im_Left,param.height*param.width,param.nbchannels);
x2       = reshape(im_Right,param.height*param.width,param.nbchannels);

% Reference disparity map
%[dw] = compute_disp(reshape(x1,param.height,param.width,param.nbchannels),reshape(x2,param.height,param.width,param.nbchannels),6,'SSD' ,10,0,10,3,1500);
%param.K = round(max(dw(:)));

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
param.iter     = 5000;                  % number of iterations
param.epsilon  = 1e-20;                  % Stopping criterion
param.regtype  = 'diff';
for tau = [0.001,0.005,0.01]
    param.tau      = tau;                   % Step-size parameter



    %% Algorithmic solutions

    % Algorithm basic
    [xrec_splitting,crit_splitting]       = algo_MPFS(param);

    % Algorithm improved splitting
    [xrec_gretsi_modif,crit_gretsi_modif]       = algo_MPIS(param);
    
    
    % Algorithm improved
    [xrec_gretsi,crit_gretsi]       = algo_MPMS(param);


    name = 'Corridor';
    tit = [name,'_',param.regtype,'_lambda',num2str(param.lambda),'_tau',num2str(param.tau),'_K',int2str(param.K),'sigma',num2str(noiselevel),'_',int2str(iter),'.mat'];
    save(tit,'xrec_splitting','xrec_gretsi','crit_splitting','crit_gretsi','xrec_gretsi_modif','crit_gretsi_modif','param')

end

