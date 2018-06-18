% demo_Segmentation.m
%
% Solve the minimal partition problem with a minimal proximal splitting 
% technique
% N. Pustelnik, L. Condat, Proximity operator of a sum of functions;
% Application to depth map estimation, IEEE Signal Processing Letters,
% vol. 24, no. 12, Dec. 2017.
%
% N. Pustelnik. Version: 04-June-2018.

toolpath = './';
addpath(genpath(toolpath));


%% Load data
x                                    = imread('parrots_orig.png');
noiselevel                           = 10;
%z  = double(x(113:512,1:400,:))+noiselevel*randn(size(x(113:512,1:400,:)));
z = double(x(113:512,1:400,:));
z = z + noiselevel*randn(size(z));
z0                                   = z;
figure(1)
imagesc(rescale(z));
label =  [      43    43    43;
    82   132    32;
   255   255   255;
   251   199     0;
    91   147   156;
    93    90    76];

param.K=6;

%% Parameters
[param.n,param.m,param.nbchannels]   = size(z0);
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
param.iter     = 20;                  % number of iterations
param.epsilon  = 1e-20;                  % Stopping criterion
param.regtype  = 'diff';
param.tau      = 0.1/param.lambda;                   % Step-size parameter

%% Algorithm improved
    % Algorithm basic
    [xrec_splitting,crit_splitting]       = algo_MPFS(param);

    % Algorithm improved splitting
    [xrec_gretsi_modif,crit_gretsi_modif]       = algo_MPIS(param);

    
    % Algorithm improved
    [xrec_gretsi,crit_gretsi]       = algo_MPMS(param);

%% Display
figure(1)
subplot(141); imagesc(rescale(reshape(z,param.n,param.m,param.nbchannels))); title 'Left image';
subplot(142); imagesc(rescale(display_segmentation(param,xrec_splitting))); title 'Segmentation';
subplot(143); imagesc(rescale(display_segmentation(param,xrec_gretsi))); title 'Segmentation';
subplot(144); imagesc(rescale(display_segmentation(param,xrec_gretsi_modif))); title 'Segmentation';

figure(2)
plot(crit_splitting(1,2:end-1),'k'); hold on ; plot(crit_gretsi(1,2:end-1),'r'); plot(crit_gretsi_modif(1,2:end-1),'b');

