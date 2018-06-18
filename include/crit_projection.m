function p = crit_projection(theta)

p = sum(sum(sum(abs(theta - projection(theta,0,1)).^2)));
