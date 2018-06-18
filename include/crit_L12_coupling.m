function wp = crit_L12_coupling(wx,param,gamma)

if strcmp(param.regtype,'nodiff')
    wp =0;
    for k=1:param.K-1
        wp = wp + sum(sqrt(sum(sum(wx(:,:,:,k).^2,1),2)),3);
    end
    wp = gamma*wp;

elseif strcmp(param.regtype,'diff')
    wp =0;
    for k=1:param.K
        wp = wp + sum(sqrt(sum(sum(wx(:,:,:,k).^2,1),2)),3);
    end
    wp = gamma*wp;
    
else
    disp('ERROR : no param.type define\n');
end



