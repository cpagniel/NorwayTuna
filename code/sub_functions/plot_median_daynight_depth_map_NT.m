%% plot_median_daynight_depth_map_NT.m
% Sub-function of Norway_Tuna.m; plots median day and night dive depth in
% 1 x 1 degree bins.

for i = 0:1

    %% Create figure and axes for bathymetry.

    figure('Position',[476 334 716 532]);

    %% Set projection of map.

    LATLIMS = [15 70]; LONLIMS = [-80 40];
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

    %% Bin SSM Positions

    binned.LONedges = -80:1:40;
    binned.LATedges = 15:1:70;

    [binned.mz,binned.LONmid,binned.LATmid] = twodmed(PSAT.Longitude(PSAT.DayNight == i),PSAT.Latitude(PSAT.DayNight == i),...
        PSAT.Depth(PSAT.DayNight == i),binned.LONedges,binned.LATedges);
    if i == 1
        bins.median_depth_day = binned.mz.';
    elseif i == 0
        bins.median_depth_night = binned.mz.';
    end

    m_pcolor(binned.LONmid,binned.LATmid,binned.mz);

    hold on

    %% Plot land.

    m_gshhs_i('patch',[.7 .7 .7]);

    hold on

    %% Plot ICCAT management line.

    m_line([-45 -45],[15 70],'linewi',2,'color','k','linestyle','--')

    %% Plot hotspots.

    m_plot(regions.Nordic(1,:),regions.Nordic(2,:),'k-','LineWidth',2)
    m_plot(regions.NB(1,:),regions.NB(2,:),'k-','LineWidth',2)
    m_plot(regions.CI(1,:),regions.CI(2,:),'k-','LineWidth',2)
    m_plot(regions.Med(1,:),regions.Med(2,:),'k-','LineWidth',2)
    m_plot(regions.WEB(1,:),regions.WEB(2,:),'k-','LineWidth',2)

    %% Create figure border.

    m_grid('linewi',2,'tickdir','in','linest','none','fontsize',18);

    %% Add north arrow and scale bar.

    m_northarrow(-75,65,4,'type',2,'linewi',2);
    m_ruler([.1 .3],.1,2,'fontsize',16,'ticklength',0.01);

    %% Add colorbar

    h = colorbar('FontSize',14,'Location','southoutside');
    tmp = getPyPlot_cMap('gnuplot2_r',48);
    colormap(tmp(5:end-3,:));
    set(h,'Position',[0.6338 0.3178 0.2325 0.0244])
    caxis([0 150]);

    if i == 0
        ylabel(h,'Median Night Depth (m)','FontSize',16,'FontWeight','bold');
    elseif i == 1
        ylabel(h,'Median Day Depth (m)','FontSize',16,'FontWeight','bold');
    end

    %% Set location of figure to match bin_map

    set(gca,'Position',[0.1300 0.1100 0.7750 0.8150]);

    %% Save

    cd([fdir '/figures']);
    if i == 0
        exportgraphics(gcf,'median_night_depth_map.png','Resolution',300);
    elseif i == 1
        exportgraphics(gcf,'median_day_depth_map.png','Resolution',300);
    end

    %% Clear

    clear h* binned *LIMS
    clear ans

    close gcf

end
clear i