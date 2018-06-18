function p = proj_sorted(x,alpha)

[M,C,K] = size(x);
p = zeros(size(x));
for i=1:M
    for j = 1:C
        p(i,j,:) = projection(proj_decreasing(squeeze(x(i,j,:)-alpha(i,j,:))),0,1);
    end
end