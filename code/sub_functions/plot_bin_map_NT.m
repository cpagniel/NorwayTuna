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

% [binned.N,binned.LONmid,binned.LATmid] = twodhist(SSM.Longitude,SSM.Latitude,binned.LONedges,binned.LATedges);

[binned.N,~,~,binned.indLON,binned.indLAT] = histcounts2(SSM.Longitude,SSM.Latitude,binned.LONedges,binned.LATedges); % number of daily geolocations
SSM.Index = sub2ind(size(binned.N),binned.indLON,binned.indLAT);

tmp = groupcounts(groupcounts(SSM,["Index" "TOPPID" ]),"Index");
binned.n = zeros(size(binned.N)); % number of unique TOPPIDs per bin
binned.n(tmp.Index) = tmp.GroupCount;
clear tmp

binned.Nn = (binned.n./length(unique(SSM.TOPPID))).*binned.N; % number of daily geolocations x number of tags in bin/total number of tags

binned.LONmid = diff(binned.LONedges)/2 + -80:1:40;
binned.LATmid = diff(binned.LATedges)/2 + 15:1:70;

m_pcolor(binned.LONmid,binned.LATmid,binned.Nn.');

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

h = colorbar('FontSize',16); 
colormap(flipud(hot(20)));
ylabel(h,'Total Daily Geolocations x Propotion of Total Tags','FontSize',16);
caxis([0 20]);

set(gca,'Position',p);

clear cmap
clear p

%% Save

cd([fdir '/figures']);
exportgraphics(gcf,'bin_map.png','Resolution',300)

%% Clear

clear h* binned *LIMS
clear ans

close gcf