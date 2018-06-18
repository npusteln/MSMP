function wp = prox_L12_cc(wx,param,gamma)

wp = zeros(size(wx));
for k=1:param.K-1
    for j=1:param.c
        wp(:,j,:,k) = prox_L12(wx(:,j,:,k),gamma);
    end
end
