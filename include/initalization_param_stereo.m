function param = initalization_param_stereo(param,z,label)


param.type        = 'median'; %'median', 'moyenne'
param.mu = zeros(param.M,param.c,param.K-1);
for k=1:param.K-1
    param.mu(:,param.c,k) = 0;
    for i=1:param.nbchannels
        if strcmp(param.type,'median')
           
            param.mu(:,param.c,k) = param.mu(:,param.c,k)+ abs(z(:,i) - label(:,i,k+1)) - abs(z(:,i) - label(:,i,k));
        else 
            param.mu(:,param.c,k) =  param.mu(:,param.c,k)+ (z(:,i) - label(:,i,k+1)).^2 - (z(:,i) - label(:,i,k)).^2;
        end
    end 
end
