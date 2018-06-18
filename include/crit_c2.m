function p = crit_c2(theta,param)


p = sum(sum(sum(abs(theta - prox_c2(theta,param)).^2)));



