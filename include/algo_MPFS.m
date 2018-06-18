% Solve the minimal partition problem with a  proximal full splitting 
% technique
% N. Pustelnik, L. Condat, Proximity operator of a sum of functions;
% Application to depth map estimation, IEEE Signal Processing Letters,
% vol. 24, no. 12, Dec. 2017.
%
% N. Pustelnik. Version: 04-June-2018.

function [xn,crit] = algo_MPFS(param)

% linear operator
f1 = get_tv;
if strcmp(param.regtype,'nodiff')
    param.sigma = 1/(param.tau*(f1.beta+2));

elseif strcmp(param.regtype,'diff')
    param.sigma = 1/(param.tau*(4*f1.beta+2));
    
else
    disp('ERROR : no param.type define\n');
end

%Fx = f.dir_op(x);
%Fstarx = f.adj_op(Fx);
op_dir           = @(x,param) transform_tv(x,param,f1);
op_adj           = @(x,param) transform_tvadj(x,param,f1);
% functions
if param.coupling==1
    f1.prox      = @(x,gamma) prox_L12_coupling(x,param,gamma);
else
    f1.prox      = @(x,gamma) prox_L12_cc(x,param,gamma);
end
%f2.prox          = @(x, gamma) prox_fidelity(x,param,gamma);
%f2.grad          = @(x)        grad_fidelity(x,param);
f3.prox          = @(x, gamma) projection(x-gamma*param.mu,0,1);
f4.prox          = @(x, gamma) prox_c1(x,param);
f5.prox          = @(x, gamma) prox_c2(x,param);


% functions
if param.coupling==1
    f1.crit      = @(x,gamma) crit_L12_coupling(x,param,gamma);
else
    f1.crit      = @(x,gamma) crit_L12_cc(x,param,gamma);
end
f2.crit          = @(x) crit_fidelity(x,param);
f3.crit          = @(x,param) crit_projection(x);
f4.crit          = @(x) crit_c1(x,param);
f5.crit          = @(x) crit_c2(x,param);



%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     ALGORITHM       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

xn  = zeros(param.M,param.c,param.K-1);
if strcmp(param.regtype,'nodiff')
    yn1 = zeros(2,param.c, param.M, param.K-1);
elseif strcmp(param.regtype,'diff')
    yn1 = zeros(2,param.c, param.M, param.K);
else
    disp('ERROR : no param.type define\n');
end
yn2 = zeros(param.M,param.c,param.K-1);
yn3 = zeros(param.M,param.c,param.K-1);
%yn4 = zeros(param.M,param.c,param.K-1);
crit = zeros(4,param.iter);


xn = proj_sorted_fast(xn,1);

n=1;
xnold =xn ;
%%
while n<param.iter && (norm(xn(:)-xnold(:))^2/norm(xn(:)+eps)^2>param.epsilon || norm(xn(:)-xnold(:))/norm(xn(:)+eps)==0)
    tic
    % Criterion
    crit(1,n) = f2.crit(xn) + f1.crit(op_dir(xn,param),param.lambda);
    crit(2,n) = f3.crit(xn);
    crit(3,n) = f4.crit(xn);
    crit(4,n) = f5.crit(xn);
    if mod(n,100)==0
    fprintf('%d : crit = %3.2f\t dc1 = %3.2f \t dc2 = %3.2f \t dc2 = %3.2f \t diff = %3.6f\n',n,crit(1,n),crit(2,n),crit(3,n),crit(4,n),norm(xn(:)-xnold(:))^2/norm(xn(:)+eps)^2);
    end
    % Update variables
    un    = f3.prox(xn - param.tau*(op_adj(yn1, param) + yn2 + yn3 ), param.tau);
    tmp1  = param.sigma*op_dir(2*un - xn, param);
    tmp   = param.sigma*(2*un - xn);
    yn1   = yn1 + tmp1 - param.sigma*f1.prox((yn1 + tmp1)/param.sigma, param.lambda/param.sigma);
    yn2   = yn2 + tmp - param.sigma*f4.prox((yn2 + tmp)/param.sigma, 1/param.sigma);
    yn3   = yn3 + tmp - param.sigma*f5.prox((yn3 + tmp)/param.sigma, 1/param.sigma);
    %yn4   = yn4 + tmp - param.sigma*f2.prox((yn4 + tmp)/param.sigma, 1/param.sigma); 


    xnold = xn;
    xn    = un;
    crit(5,n) = toc;
    n     = n+1;


end
