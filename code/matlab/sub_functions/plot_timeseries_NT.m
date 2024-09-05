%% plot_timeseries_NT.m
% Sub-function of Norway_Tuna.m; plots temperature-depth timeseries with hotspot location.

%% Loop through each tag

toppID = unique(PSAT.TOPPID);

cmap.regions = [128 128 128; 227 26 28; 56 108 176; 166 206 227; 253 192 134; 190 174 212]./256;

for i = 1:length(toppID)

    %% Create figure.

    figure('Position',[112 219 1272 532]);

    %% Plot timeseries.

    scatter(PSAT.DateTime(PSAT.TOPPID == toppID(i) & PSAT.Date <= META.PopUpDate(META.TOPPID == toppID(i))),PSAT.Depth(PSAT.TOPPID == toppID(i) & PSAT.Date <= META.PopUpDate(META.TOPPID == toppID(i))),...
        4,PSAT.Temperature(PSAT.TOPPID == toppID(i) & PSAT.Date <= META.PopUpDate(META.TOPPID == toppID(i))),'filled');

    set(gca,'ydir','reverse','FontSize',24,'LineWidth',3);
    xlabel('Date','FontSize',30); ylabel('Depth (m)','FontSize',30);

    %% Set colormap for timeseries.

    % cmocean thermal;
    colormap(getPyPlot_cMap('Spectral_r'));
    % colormap(jet)
    h = colorbar; ylabel(h,'Temperature (^oC)','FontSize',28);
    h.FontSize = 26;
    caxis([0 30]); h.Ticks = 0:5:30; 

    clear h

    %% Set axes.

    tmp = PSAT.DateTime(PSAT.TOPPID == toppID(i));
    if year(tmp(1)) == 2020
        xlim([datetime(2020,08,30) datetime(2021,10,15)]);
    elseif year(tmp(1)) == 2021
        xlim([datetime(2021,08,30) datetime(2022,10,15)]);
    elseif year(tmp(1)) == 2022
        xlim([datetime(2022,08,30) datetime(2023,10,15)]);
    end

    ylim([-50 1200]);

    box on;

    hold on

     %% Plot hotspot.
 
    tmp = PSAT(PSAT.TOPPID == toppID(i) & PSAT.Date <= META.PopUpDate(META.TOPPID == toppID(i)),:);

    ind = ischange(tmp.Region(tmp.TOPPID == toppID(i))); 
    ind = [1; find(ind); length(tmp.Region(tmp.TOPPID == toppID(i)))];

    for j = 1:length(ind)-1
        p(j) = patch([tmp.DateTime(ind(j)) tmp.DateTime(ind(j)) ...
            tmp.DateTime(ind(j+1)-1) tmp.DateTime(ind(j+1)-1) tmp.DateTime(ind(j))],...
            [-10 -50 -50 -10 -10],cmap.regions(tmp.Region(ind(j))+1,:),'EdgeColor','none');
    end
    clear j 
    clear ind
    clear tmp

    %% Save figure.

    cd([fdir '/figures/timeseries']);
    exportgraphics(gcf,['timeseries_' num2str(toppID(i)) '.png'],'Resolution',300);

    close gcf

end
clear i
clear toppID
