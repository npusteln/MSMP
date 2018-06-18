function p = prox_fidelity(theta,param, gamma)


p = zeros(size(theta));
for i=1:param.c
    for k=1:param.K-1
        p(:,i,k) = theta(:,i,k) - gamma*param.mu(:,i,k);
    end
end