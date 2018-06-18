function p = crit_fidelity(theta,param)

p = 0;
for i=1:param.c
    for k=1:param.K-1
        p = p + theta(:,i,k)'*param.mu(:,i,k);
    end
end