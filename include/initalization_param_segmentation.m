function param = initalization_param_segmentation(param,z,label)


param.type        = 'moyenne'; %'median', 'moyenne'
param.mu = zeros(param.M,param.c,param.K-1);
for k=1:param.K-1
    param.mu(:,param.c,k) = 0;
    for i=1:param.nbchannels
        if strcmp(param.type,'median')
            param.mu(:,1,k) = param.mu(:,1,k)+ abs(z(:,i) - param.moyenne(i,k+1)) - abs(z(:,i) - param.moyenne(i,k));
        else 
            param.mu(:,1,k) =  param.mu(:,1,k)+ (z(:,i) - param.moyenne(i,k+1)).^2 - (z(:,i) - param.moyenne(i,k)).^2;
        end
    end 
end
