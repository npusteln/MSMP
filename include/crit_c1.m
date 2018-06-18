function p = crit_c1(theta,param)


p = sum(sum(sum(abs(theta - prox_c1(theta,param)).^2)));



