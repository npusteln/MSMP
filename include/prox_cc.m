function [p,q] = prox_cc(thetap, thetaq, ind,K)

p = thetap;
q = thetaq;
for k=2:2:K-1
    tmp         = thetap(ind{k}) - thetap(ind{k+1});
    p(ind{k})   = thetap(ind{k}) - min(0,tmp)/2;
    p(ind{k+1}) = thetap(ind{k+1}) + min(0,tmp)/2;
end
for k=1:2:K-1
    tmp         = thetaq(ind{k}) - thetaq(ind{k+1});
    q(ind{k})   = thetaq(ind{k}) - min(0,tmp)/2;
    q(ind{k+1}) = thetaq(ind{k+1}) + min(0,tmp)/2;
end





