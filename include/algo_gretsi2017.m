function [xn,crit] = algo_gretsi2017(param)


% linear operator
f1 = get_tv;
f1.beta
if strcmp(param.regtype,'nodiff')
    param.sigma = 1/(param.tau*f1.beta);

elseif strcmp(param.regtype,'diff')
    param.sigma = 1/(param.tau*4*f1.beta);
    
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
f2.prox          = @(x, gamma) proj_sorted_fast(x,gamma*param.mu);

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



%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     ALGORITHM       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

xn  = zeros(param.M,param.c,param.K-1);
if strcmp(param.regtype,'nodiff')
    yn = zeros(2,param.c, param.M, param.K-1);
elseif strcmp(param.regtype,'diff')
    yn = zeros(2,param.c, param.M, param.K);
else
    disp('ERROR : no param.type define\n');
end
    
crit = zeros(4,param.iter);
n=1;
xnold =xn ;
un = xn;
%%
while  n<param.iter && (norm(xn(:)-xnold(:))^2/norm(xn(:)+eps)^2>param.epsilon || norm(xn(:)-xnold(:))/norm(xn(:)+eps)==0)

    tic
    % Criterion
     crit(1,n) = f2.crit(un) + f1.crit(op_dir(un,param),param.lambda);
     crit(2,n) = f3.crit(un);
     crit(3,n) = f4.crit(un);
     crit(4,n) = f5.crit(un);
     if mod(n,100)==0
     fprintf('%d : crit = %3.2f\t dc1 = %3.2f \t dc2 = %3.2f \t dc2 = %3.2f \t diff = %3.6f\n',n,crit(1,n),crit(2,n),crit(3,n),crit(4,n),norm(xn(:)-xnold(:))^2/norm(xn(:)+eps)^2);
     end

    % Update
    un    = f2.prox(xn - param.tau*op_adj(yn, param),param.tau);
    tmp   = yn + param.sigma*op_dir(2*un - xn, param);
    wn   = tmp - param.sigma*f1.prox(tmp/param.sigma, param.lambda/param.sigma);

    xnold = xn;
    xn    = xn + 1.9*(un - xn);  
    yn    = yn + 1.9*(wn - yn);  
    crit(5,n) = toc;
    n     = n+1;

   
end