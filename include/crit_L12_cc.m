function wp = crit_L12_cc(wx,param,gamma)

wp =0;
for k=1:param.K-1
    for j=1:param.c
        wp = wp + sum(sqrt(sum(wx(:,j,:,k).^2,1)),3);
    end
end
wp = gamma*wp;
