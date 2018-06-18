function wp = prox_L12(wx,gamma)

c = size(wx,2);
wp = zeros(size(wx));
tmp = sqrt(sum(sum(wx.^2,1),2));
ind = find(tmp>gamma); 
for l=1:2
    for j = 1:c
        wp(l,j,ind) = (1 - gamma./tmp(ind)).*wx(l,j,ind);
    end
end


