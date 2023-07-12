sub = addvars(sub,sub.Depth,'Before','Temperature','NewVariableNames','DepthDet');
    sub.DepthDet = smoothdata(sub.DepthDet,'movmedian',60/5*5);
    sub.DepthDet(sub.DepthDet <= 10) = 0; % 10 m

    figure;

plot(sub.DateTime,sub.DepthDet,'k-'); set(gca,'ydir','reverse'); hold on;
plot(sub.DateTime(pks.initial),sub.DepthDet(pks.initial),'rv','MarkerFaceColor','r','MarkerSize',10);
plot(sub.DateTime(vls.initial),sub.DepthDet(vls.initial),'b^','MarkerFaceColor','b','MarkerSize',10);

for j = 1:365
xlim([datetime('09/19/2020 18:00')+days(j) datetime('09/19/2020 18:00')+days(j)+1]); ylim([0 500]);
pause(2)
end