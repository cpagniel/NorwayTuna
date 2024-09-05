%% plot_horizontal_speed_map_NT.m
% Sub-function of Norway_Tuna.m; plots median horizontal speeed in 
% 1 x 1 degree bins.

%% Create list of unique toppIDs.

toppID = unique(SSM.TOPPID);

%% Compute distance between adjacent daily positions. 

for i = 1:length(toppID)
    tmp.lat = SSM.Latitude(SSM.TOPPID == toppID(i));
    tmp.lon = SSM.Longitude(SSM.TOPPID == toppID(i));
    tmp.date = SSM.Date(SSM.TOPPID == toppID(i));

    tbl = table(toppID(i)*ones(sum(SSM.TOPPID == toppID(i))-1,1),'VariableNames',{'TOPPID'});
    tbl.Distance_km = m_lldist(tmp.lon,tmp.lat);
    tbl.Speed_m_per_s = tbl.Distance_km*1000./86400; % 1 day = 86400 seconds
    tbl.Latitude = tmp.lat(1:end-1);
    tbl.Longitude = tmp.lon(1:end-1);
    tbl.Date = tmp.date(1:end-1);
    
    if isfield(B,'speed')
        B.speed = [B.speed; tbl];
    else
        B.speed = tbl;
    end

    clear tbl
    clear tmp

end
clear i

%% Create figure and axes for bathymetry. 

figure('Position',[476 334 716 532]);

%% Set projection of map.

LATLIMS = [15 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

%% Compute median of speed (m/s) in each bin.

binned.LONedges = -80:1:40;
binned.LATedges = 15:1:70;

[binned.mz,binned.LONmid,binned.LATmid] = twodmed(B.speed.Longitude,B.speed.Latitude,...
        B.speed.Speed_m_per_s,binned.LONedges,binned.LATedges);
bins.speed = binned.mz.';

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.mz);

hold on

%% Plot land.

m_coast('patch',[.7 .7 .7]);
% m_gshhs_i('patch',[.7 .7 .7]);

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
colormap(cmocean('deep',8))
set(h,'Position',[0.6338 0.3178 0.2325 0.0244])
ylabel(h,'Speed (m/s)','FontSize',16,'FontWeight','bold');
caxis([0 2]);
h.Ticks = 0:0.5:2;

%% Set location of figure to match bin_map

set(gca,'Position',[0.1300 0.1100 0.7750 0.8150]);

%% Save

cd([fdir '/figures']);
exportgraphics(gcf,'speed_map.png','Resolution',300)

%% Clear

clear h* binned *LIMS
clear tmp
clear ans

close gcf