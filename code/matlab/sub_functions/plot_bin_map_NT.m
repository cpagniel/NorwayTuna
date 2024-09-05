%% plot_bin_map_NT.m
% Sub-function of Norway_Tuna.m; plots SSM tracks of binned by days in 
% 1 x 1 degree bins.

%% Create figure and axes for bathymetry. 

figure('Position',[476 334 716 532]);

%% Set projection of map.

LATLIMS = [15 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

%% Bin SSM Positions

binned.LONedges = -80:1:40;
binned.LATedges = 15:1:70;

[binned.N,~,~,binned.indLON,binned.indLAT] = histcounts2(SSM.Longitude,SSM.Latitude,binned.LONedges,binned.LATedges); % number of daily geolocations
SSM.Index = sub2ind(size(binned.N),binned.indLON,binned.indLAT);

tmp = groupcounts(groupcounts(SSM,["Index" "TOPPID" ]),"Index");
binned.n = zeros(size(binned.N)); % number of unique TOPPIDs per bin
binned.n(tmp.Index) = tmp.GroupCount;
clear tmp

binned.Nn = (binned.n./length(unique(SSM.TOPPID))).*binned.N; % number of daily geolocations x number of tags in bin/total number of tags

binned.LONmid = diff(binned.LONedges)/2 + -80:1:40;
binned.LATmid = diff(binned.LATedges)/2 + 15:1:70;

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.Nn.');

hold on

%% Plot land.

m_coast('patch',[.7 .7 .7]);
% m_gshhs_i('patch',[.7 .7 .7]);

hold on

%% Plot ICCAT regions.

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

p = get(gca,'Position');

h = colorbar('FontSize',16); 
cmap.bin = flipud(hot(45));
cmap.bin = [1,1,1; cmap.bin(6:end,:)];
colormap(cmap.bin);
ylab = ylabel(h,'Total Daily Geolocations x Propotion of Total Tags','FontSize',16);
caxis([0 40]);

set(gca,'Position',p);
ylab.Position(1) = ylab.Position(1) - 0.13;

clear ylab
clear p

%% Save

cd([fdir '/figures']);
exportgraphics(gcf,'bin_map.png','Resolution',300)

%% Clear

clear h* binned *LIMS
clear ans

close gcf