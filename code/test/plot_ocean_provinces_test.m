cmap = colorcube(9);

figure;
plot(plt.Temperature(:,idx == 1),plt.Depth(:,idx == 1),'-','Color',cmap(1,:))
hold on
set(gca,'ydir','reverse')
xlim([0 30])
plot(plt.Temperature(:,idx == 2),plt.Depth(:,idx == 2),'-','Color',cmap(2,:))
plot(plt.Temperature(:,idx == 3),plt.Depth(:,idx == 3),'-','Color',cmap(3,:))
plot(plt.Temperature(:,idx == 4),plt.Depth(:,idx == 4),'-','Color',cmap(4,:))
plot(plt.Temperature(:,idx == 5),plt.Depth(:,idx == 5),'-','Color',cmap(5,:))
plot(plt.Temperature(:,idx == 6),plt.Depth(:,idx == 6),'-','Color',cmap(6,:))
plot(plt.Temperature(:,idx == 7),plt.Depth(:,idx == 7),'-','Color',cmap(7,:))
plot(plt.Temperature(:,idx == 8),plt.Depth(:,idx == 8),'-','Color',cmap(8,:))
plot(plt.Temperature(:,idx == 9),plt.Depth(:,idx == 9),'-','Color',cmap(9,:))

figure;
plot(plt.Longitude(idx == 1),plt.Latitude(idx == 1),'ko','MarkerFaceColor',cmap(1,:))
hold on
plot(plt.Longitude(idx == 2),plt.Latitude(idx == 2),'ko','MarkerFaceColor',cmap(2,:))
plot(plt.Longitude(idx == 3),plt.Latitude(idx == 3),'ko','MarkerFaceColor',cmap(3,:))
plot(plt.Longitude(idx == 4),plt.Latitude(idx == 4),'ko','MarkerFaceColor',cmap(4,:))
plot(plt.Longitude(idx == 5),plt.Latitude(idx == 5),'ko','MarkerFaceColor',cmap(5,:))
plot(plt.Longitude(idx == 6),plt.Latitude(idx == 6),'ko','MarkerFaceColor',cmap(6,:))
plot(plt.Longitude(idx == 7),plt.Latitude(idx == 7),'ko','MarkerFaceColor',cmap(7,:))
plot(plt.Longitude(idx == 8),plt.Latitude(idx == 8),'ko','MarkerFaceColor',cmap(8,:))
plot(plt.Longitude(idx == 9),plt.Latitude(idx == 9),'ko','MarkerFaceColor',cmap(9,:))
