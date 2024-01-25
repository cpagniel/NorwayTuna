%% plot_daily_dive_frequency_map_NT.m
% Sub-function of Norway_Tuna.m; plots mean maximum daily dive depth in 
% 1 x 1 degree bins.

%% Create figure and axes for bathymetry. 

figure('Position',[476 334 716 532]);

%% Set projection of map.

LATLIMS = [15 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

%% Compute median of daily dive frequency in each bin.

binned.LONedges = -80:1:40;
binned.LATedges = 15:1:70;

[binned.mz,binned.LONmid,binned.LATmid] = twodmed(SSM.Longitude,SSM.Latitude,...
        SSM.DivesPerDay,binned.LONedges,binned.LATedges);
bins.daily_dive_f = binned.mz.';

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.mz);

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

h = colorbar('FontSize',14,'Location','southoutside'); colormap(getPyPlot_cMap('YlGnBu',12)); 
set(h,'Position',[0.6338 0.3178 0.2325 0.0244])
ylabel(h,'Dive Frequency (no./day)','FontSize',16,'FontWeight','bold');
caxis([0 60]);

%% Set location of figure to match bin_map

set(gca,'Position',[0.1300 0.1100 0.7750 0.8150]);

%% Save

cd([fdir '/figures']);
exportgraphics(gcf,'daily_dive_frequency_map.png','Resolution',300)

%% Clear

clear h* *LIMS
clear binned
clear ans

close gcf