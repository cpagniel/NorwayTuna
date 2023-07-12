test = unique(datetime(year(tmp.DateTime),month(tmp.DateTime),day(tmp.DateTime)));
test2 = datetime(year(tmp.DateTime),month(tmp.DateTime),day(tmp.DateTime));

ind = min(test):hours(1):max(test);

for i = 1:length(test)
    plot(tmp.Temperature(tmp.DateTime >= ind(i) & tmp.DateTime  < ind(i+1)),tmp.Depth(tmp.DateTime  >= ind(i) & tmp.DateTime < ind(i+1)),'.')
    set(gca,'ydir','reverse')
    xlim([0 30]); ylim([0 500])
    title(['hour ' num2str(i)])
    pause(2)
end