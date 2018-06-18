function p = transform_tv_v2(theta,param)

p = zeros(2,param.c,param.M,param.K-1);
tmp = reshape(theta,param.n,param.m,param.c,param.K-1);
for k=1:param.K-1
    for j=1:param.c
        p(1,j,:,k) = reshape(real(ifft2(param.H.*fft2(tmp(:,:,j,k)))),1,1,param.M,1);
        p(2,j,:,k) = reshape(real(ifft2(param.V.*fft2(tmp(:,:,j,k)))),1,1,param.M,1);
    end
end



