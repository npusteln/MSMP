function x= rescale(x)

x = x-min(x(:));
x = x/max(x(:));