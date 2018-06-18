function z = proj_sorted_fast_without_rangeconstraint(x,alpha)

[M,C,K] = size(x);
xr = reshape(x-alpha,M*C,K)';
xr = reshape(xr,M*C*K,1);

zr = proj_decreasing_mex(xr',K,M*C);

z = reshape(zr,K,M*C)';
z = reshape(z,M,C,K);

