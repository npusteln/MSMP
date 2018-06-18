clear all
close all
clc


%x = [10:-1:5, 7:8,3:-1:1];
x = randn(1,10);
y = x;
[M,L] = size(x);
i=2;
j=1;
ind{1} =[];
while i<=L
    indv = find(x(:,i)>x(:,i-1));
    if ~isempty(indv)
        ind{indv,j} = unique([ind{indv,j},i-1,i]);
        x(1,ind{j}) = mean(x(1,ind{j}));
        i = max(i-1,2);
    else
        i = i+1;
        j=j+1;
        ind{j} =[];        
    end
end

figure(1)
plot(x,'r')
hold on
plot(y,'k')
grid on