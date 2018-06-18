function p = transform_tvadj(theta,param,f1)

if strcmp(param.regtype,'nodiff')
    p = zeros(param.n, param.m , param.c, param.K-1);
    theta = reshape(theta,2,param.c,param.n,param.m,param.K-1);
    for k=1:param.K-1
        p(:,:,:,k) = f1.adj_op(theta(:,:,:,:,k));
    end
    p = reshape(p,param.M,param.c, param.K-1);


elseif strcmp(param.regtype,'diff')
    p = zeros(param.n, param.m , param.c, param.K-1);
    theta = reshape(theta,2,param.c,param.n,param.m,param.K);
    for k=1:param.K-1
        p(:,:,:,k) = f1.adj_op(-theta(:,:,:,:,k)+ theta(:,:,:,:,k+1));
    end
    p = reshape(p,param.M,param.c, param.K-1);

else
    disp('ERROR : no param.type define\n');
end



