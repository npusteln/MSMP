function xestimate = display_estimation(param,xestimate)

xestimate2 = zeros(size(xestimate));
xestimate2(xestimate>0.5) = 1;
xestimate = xestimate2;
clear xestimate2;
%xrec = zeros(param.n*param.m);
%for i=1:param.nbchannels
    xrec =(1-xestimate(:,1,1));
    for k=1:param.K-2
        xrec = xrec +(xestimate(:,1,k) - xestimate(:,1,k+1))*(k+1);
    end
     xrec = xrec + xestimate(:,1,param.K-1) * param.K;
%end
%xestimate  = reshape(xrec,param.n,param.m,param.nbchannels);
xestimate  = reshape(xrec,param.n,param.m);