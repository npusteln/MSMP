clear all
close all
clc


%x = [10:-1:5, 7:8,3:-1:1];
x = randn(1,10);
y = x;
i=2;
j=1;
ind{1} =[];
while i<=length(x)
    if x(1,i)>x(1,i-1)
        ind{j} = unique([ind{j},i-1,i]);
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