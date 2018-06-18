function p = prox_c1(theta,param)

p = theta;
for k=2:2:param.K-2
    
    for i= 1 : param.c
        tmp         = theta(:,i,k) - theta(:,i,k+1);
        p(:,i,k)    = theta(:,i,k) - min(0,tmp)/2;
        p(:,i,k+1)  = theta(:,i,k+1) + min(0,tmp)/2;
    end
end




