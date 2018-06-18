function p = prox_c1_sort(theta,param)

[~,order] = sort(param.moyenne);
p = theta;
theta_order = zeros(size(theta));

for i= 1 : param.c
    for k=1:param.K-1
        theta_order(:,i,k) = theta(:,i,order(i,k));
    end
    for k=2:2:(param.K-1)/2
        tmp         = theta_order(:,i,k) - theta_order(:,i,k+1);
        p(:,i,k)    = theta_order(:,i,k) - min(0,tmp)/2;
        p(:,i,k+1)  = theta_order(:,i,k+1) + min(0,tmp)/2;
    end
    theta_order = p;
    for k=1:param.K-1
        p(:,i,order(i,k)) = theta_order(:,i,k);
    end    
end




