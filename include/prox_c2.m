function q = prox_c2(theta,param)

q = theta;
for k=1:2:param.K-2
    for i= 1 : param.c
        tmp         = theta(:,i,k) - theta(:,i,k+1);
        q(:,i,k)    = theta(:,i,k) - min(0,tmp)/2;
        q(:,i,k+1)  = theta(:,i,k+1) + min(0,tmp)/2;
    end
end





