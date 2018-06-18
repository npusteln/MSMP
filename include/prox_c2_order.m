function q = prox_c2_order(theta,param)

[~,order] = sort(param.moyenne);
q = theta;
theta_order = zeros(size(theta));

for i= 1 : param.c
    for k=1:param.K-1
        theta_order(:,i,k) = theta(:,i,order(i,k));
    end
    for k=1:2:(param.K-1)/2
        tmp         = theta_order(:,i,k) - theta_order(:,i,k+1);
        q(:,i,k)    = theta_order(:,i,k) - min(0,tmp)/2;
        q(:,i,k+1)  = theta_order(:,i,k+1) + min(0,tmp)/2;
    end
    theta_order = q;
    for k=1:param.K-1
        q(:,i,order(i,k)) = theta_order(:,i,k);
    end  
end







