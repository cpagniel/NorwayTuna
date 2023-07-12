%% plot_dives_NT.m
% Sub-function of Norway_Tuna.m; plot depth timeseries and start and end of dives.

%% Loop through TOPP IDs.

for i = 1:length(toppID)

    figure;

    plot(PSAT.DateTime(PSAT.TOPPID == toppID(i)),PSAT.Depth(PSAT.TOPPID == toppID(i)),'k-')

    hold on

    plot(dives(i).time(dives(i).binary == 1),dives(i).depth(dives(i).binary == 1),'rv','MarkerFaceColor','r','MarkerSize',10)
    plot(dives(i).time(dives(i).binary == 0),dives(i).depth(dives(i).binary == 0),'b^','MarkerFaceColor','b','MarkerSize',10)

    set(gca,'ydir','reverse','fontsize',18);
    title(num2str(toppID(i)),'fontsize',22);
    xlabel('Time','fontsize',20); ylabel('Depth (m)','fontsize',20)

    %% Save.

    cd([folder '/figures/dives']);
    saveas(gcf,[num2str(toppID(i)) '_dives.fig']);
    exportgraphics(gcf,[num2str(toppID(i)) '_dives.png'],'Resolution',300);

    close all

end
clear i