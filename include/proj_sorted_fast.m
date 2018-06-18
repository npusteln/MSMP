function z = proj_sorted_fast(x,alpha)

[M,C,K] = size(x);
xr = reshape(x-alpha,M*C,K)';
xr = reshape(xr,M*C*K,1);

zr = projection(proj_decreasing_mex(xr',K,M*C),0,1);

z = reshape(zr,K,M*C)';
z = reshape(z,M,C,K);

