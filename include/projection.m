function xp=projection(x,n,m)
%projection sur [n,m]


indm=find(x>m);
indn=find(x<n);

xp=x;
xp(indm)=m;
xp(indn)=n;