function [xn,crit] = algo_gretsi_splitting_2017(param)


% linear operator
f1 = get_tv;
param.sigma = 1/(param.tau*(f1.beta+1));
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
f2.prox          = @(x, gamma) proj_sorted_fast_without_rangeconstraint(x,gamma*param.mu);
f3.prox          = @(x,gamma) projection(x,0,1);

% functions
if param.coupling==1
    f1.crit      = @(x,gamma) crit_L12_coupling(x,param,gamma);
else
    f1.crit      = @(x,gamma) crit_L12_cc(x,param,gamma);
end
f2.crit          = @(x) crit_fidelity(x,param);
f3.crit          = @(x) crit_projection(x);
f4.crit          = @(x) crit_c1(x,param);
f5.crit          = @(x) crit_c2(x,param);

rho=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     ALGORITHM       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

xn  = zeros(param.M,param.c,param.K-1);
if strcmp(param.regtype,'nodiff')
    yn1 = zeros(2,param.c, param.M, param.K-1);
    yn2 = zeros(param.M, param.c,param.K-1);
elseif strcmp(param.regtype,'diff')
    yn1 = zeros(2,param.c, param.M, param.K);
    yn2 = zeros(param.M, param.c,param.K-1);
else
    disp('ERROR : no param.type define\n');
end

    
crit = zeros(4,param.iter);
n=1;
xnold =xn;
yn1old=yn1;
yn2old=yn2;
%%
while  n<=param.iter 
%&& (norm(xn(:)-xnold(:))^2/norm(xn(:)+eps)^2>param.epsilon || norm(xn(:)-xnold(:))/norm(xn(:)+eps)==0)

    tic
    % Criterion
    crit(1,n) = f2.crit(xn) + f1.crit(op_dir(xn,param),param.lambda);
    crit(2,n) = f3.crit(xn);
    crit(3,n) = f4.crit(xn);
    crit(4,n) = f5.crit(xn);
    %fprintf('%d : crit = %3.2f\t dc1 = %3.2f \t dc2 = %3.2f \t dc2 = %3.2f \t diff = %3.6f\n',n,crit(1,n),crit(2,n),crit(3,n),crit(4,n),norm(xn(:)-xnold(:))^2/norm(xn(:)+eps)^2);


    % Update

    un    = f2.prox(xn - param.tau*(op_adj(yn1, param) + yn2),param.tau);
    tmp1  = yn1 + param.sigma*op_dir(2*un - xn, param);
    tmp2  = yn2 + param.sigma*(2*un - xn);
    yn1   = tmp1 - param.sigma*f1.prox(tmp1/param.sigma, param.lambda/param.sigma);
    yn2   = tmp2 - param.sigma*f3.prox(tmp2/param.sigma, param.lambda/param.sigma);
    
	yn1=yn1+rho*(yn1-yn1old);
	yn1old=yn1;
	yn2=yn2+rho*(yn2-yn2old);
	yn2old=yn2;
    
	xnold = xn;
	xn=un+rho*(un-xnold);
	%xn=un;

    	
    crit(5,n) = toc;
    n     = n+1;

   
end