function p = transform_tvadj_v2(theta,param)

p = zeros(param.M,param.c,param.K-1);
tmp1 = reshape(theta(1,:,:,:),param.n,param.m,param.c,param.K-1);
tmp2 = reshape(theta(2,:,:,:),param.n,param.m,param.c,param.K-1);
for k=1:param.K-1
    for j=1:param.c
        p(:,j,k) = reshape(real(ifft2(conj(param.H).*fft2(tmp1(:,:,j,k)) + ...
            conj(param.H).*fft2(tmp2(:,:,j,k)))),param.M,1,1);
       
    end
end



