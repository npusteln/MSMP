function xestimate = display_segmentation(param,xestimate)

xestimate2 = zeros(size(xestimate));
xestimate2(xestimate>0.5)=1;
xestimate = xestimate2;
clear xestimate2;
xrec = zeros(param.n*param.m,param.nbchannels);
for i=1:3 
    xrec(:,i) =(1-xestimate(:,1,1))*param.moyenne(i,1);
    for k=1:param.K-2
        xrec(:,i) = xrec(:,i) +(xestimate(:,1,k) - xestimate(:,1,k+1))*param.moyenne(i,k+1);
    end
     xrec(:,i) = xrec(:,i) + xestimate(:,1,param.K-1) * param.moyenne(i,param.K);
end



%end
%xestimate  = reshape(xrec,param.n,param.m,param.nbchannels);
xestimate  = reshape(xrec,param.n,param.m,param.nbchannels);