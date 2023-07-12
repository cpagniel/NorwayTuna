%% plot_mean_max_daily_depth_map_NT.m
% Sub-function of Norway_Tuna.m; plots mean maximum daily dive depth in 
% 1 x 1 degree bins.

%% Compute maximum daily dive depth per TOPPID.

tmp = groupsummary(PSAT,{'TOPPID','Date'},'max','Depth');
tmp = removevars(tmp,'GroupCount');

SSM = outerjoin(SSM,tmp,'keys',[1 2],'MergeKeys',true);

clear tmp

%% Create figure and axes for bathymetry. 

figure('Position',[476 334 716 532]);

%% Set projection of map.

LATLIMS = [15 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

%% Compute mean of daily maximum dive depth in each bin.

binned.LONedges = -80:1:40;
binned.LATedges = 15:1:70;

[binned.mz,binned.LONmid,binned.LATmid,~,binned.stdz] = twodstats(SSM.Longitude,SSM.Latitude,SSM.max_Depth,binned.LONedges,binned.LATedges);

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
ylabel(h,'Mean Daily Maximum Depth (m)','FontSize',16);
caxis([0 600]);

set(gca,'Position',p);

clear p

%% Save

cd([fdir '/figures']);
exportgraphics(gcf,'mean_max_daily_depth_map.png','Resolution',300)

%% Clear

clear h* binned *LIMS
clear ans

close gcf