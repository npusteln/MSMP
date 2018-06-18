function wp = prox_L12_coupling(wx,param,gamma)

if strcmp(param.regtype,'nodiff')
    wp = zeros(size(wx));
    for k=1:param.K-1
        wp(:,:,:,k) = prox_L12(wx(:,:,:,k),gamma);
    end
elseif strcmp(param.regtype,'diff')
    wp = zeros(size(wx));
    for k=1:param.K
        wp(:,:,:,k) = prox_L12(wx(:,:,:,k),gamma);
    end
else
    disp('ERROR : no param.type define\n');
end
