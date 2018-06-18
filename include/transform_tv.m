function p = transform_tv(theta,param,f1)

if strcmp(param.regtype,'nodiff')
    p = zeros(2,param.c,param.n, param.m,param.K-1);
    theta = reshape(theta,param.n,param.m,param.c,param.K-1);
    for k=1:param.K-1
        p(:,:,:,:,k) = f1.dir_op(theta(:,:,:,k));
    end
    p = reshape(p,2,param.c, param.M,param.K-1);

elseif strcmp(param.regtype,'diff')
    p = zeros(2,param.c,param.n, param.m,param.K);
    theta = reshape(theta,param.n,param.m,param.c,param.K-1);
    p(:,:,:,:,1) = f1.dir_op(-theta(:,:,:,1));
    for k=2:param.K-1
        p(:,:,:,:,k) = f1.dir_op(theta(:,:,:,k-1)-theta(:,:,:,k));
    end
    p(:,:,:,:,param.K) = f1.dir_op(theta(:,:,:,param.K-1));
    p = reshape(p,2,param.c, param.M,param.K);
    
else
    disp('ERROR : no param.type define\n');
end





