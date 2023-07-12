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

    m_pcolor(binned.LONmid,binned.LATmid,binned.mz);

    hold on

    %% Plot land.

    m_gshhs_i('patch',[.7 .7 .7]);

    hold on

    %% Plot regions.

    m_line(regions.NB.bndry(1,:),regions.NB.bndry(2,:),'linewi',2,'color','k');
    m_line(regions.CoI.bndry(1,:),regions.CoI.bndry(2,:),'linewi',2,'color','k');
    m_line(regions.BB.bndry(1,:),regions.BB.bndry(2,:),'linewi',2,'color','k');
    m_line(regions.WEB.bndry(1,:),regions.WEB.bndry(2,:),'linewi',2,'color','k');
    m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');
    m_line(regions.NwS.bndry(1,:),regions.NwS.bndry(2,:),'linewi',2,'color','k');
    m_line(regions.NoS.bndry(1,:),regions.NoS.bndry(2,:),'linewi',2,'color','k');
    m_line(regions.CaI.bndry(1,:),regions.CaI.bndry(2,:),'linewi',2,'color','k');

    %% Create figure border.

    m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

    %% Add north arrow and scale bar.

    m_northarrow(-75,65,4,'type',2,'linewi',2);
    m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

    %% Add colorbar

    p = get(gca,'Position');
    p(1) = p(1)-0.03;

    h = colorbar('FontSize',16); cmap = colormap('parula'); colormap(flipud(cmap));
    if i == 0
        ylabel(h,'Median Night Depth (m)','FontSize',16);
    elseif i == 1
        ylabel(h,'Median Day Depth (m)','FontSize',16);
    end
    caxis([0 80]);

    set(gca,'Position',p);

    clear p

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