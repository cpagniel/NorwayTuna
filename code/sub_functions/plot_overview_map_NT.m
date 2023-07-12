%% plot_overview_map_NT %%
% Sub-function of Norway_Tuna.m; plots SSM tracks of all tags colored by
% TOPPID.

%% Create figure and axes for bathymetry.

figure('Position',[476 334 716 532]);

%% Set projection of map.

LATLIMS = [15 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

%% Plot bathymetry.

[cs,ch] = m_etopo2('contourf',-8000:500:0,'edgecolor','none');

h1 = m_contfbar([.3 .7],.05,cs,ch,'endpiece','no','FontSize',16);
xlabel(h1,'Bottom Depth (m)');

colormap(m_colmap('blue'));

hold on

%% Plot land.

m_gshhs_i('patch',[.7 .7 .7]);

hold on

%% Set colormap by tag.

cmap.tag = hex2rgb(["#d64a77",...
    "#9c4a3d",...
    "#db4e33",...
    "#bb8037",...
    "#727b2f",...
    "#55a339",...
    "#40936a",...
    "#6477c0",...
    "#7447c9",...   
    "#cd4ec5",...
    "#9a4b84"]);

% cmap.tag = getPyPlot_cMap('Paired',12);
% cmap.tag(1,:) = [];

%% Get unique TOPPIDs

TOPPid = unique(SSM.TOPPID);

%% Plot SSM positions of tuna colored by tag.

% Plot each tag.
for i = 1:length(TOPPid)
    m_plot(SSM.Longitude(SSM.TOPPID == TOPPid(i),:),SSM.Latitude(SSM.TOPPID == TOPPid(i),:),...
        'k-','Color',[0.5 0.5 0.5]);

    hold on

    m_plot(SSM.Longitude(SSM.TOPPID == TOPPid(i),:),SSM.Latitude(SSM.TOPPID == TOPPid(i),:),...
        'ko','MarkerFaceColor',cmap.tag(i,:),'MarkerEdgeColor','k','MarkerSize',5,'LineStyle','none','LineWidth',1);

    hold on

    m(i) = m_plot(-100,100,'o','MarkerFaceColor',cmap.tag(i,:),'MarkerEdgeColor','k','MarkerSize',5,'LineWidth',1);
end
clear i

%% Plot ICCAT regions.

m_line([-45 -45],[15 70],'linewi',2,'color','k','linestyle','--')

%% Plot regions.

m_line(regions.NB.bndry(1,:),regions.NB.bndry(2,:),'linewi',2,'color','k');
m_line(regions.CoI.bndry(1,:),regions.CoI.bndry(2,:),'linewi',2,'color','k');
m_line(regions.BB.bndry(1,:),regions.BB.bndry(2,:),'linewi',2,'color','k');
m_line(regions.WEB.bndry(1,:),regions.WEB.bndry(2,:),'linewi',2,'color','k');
m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');
m_line(regions.NwS.bndry(1,:),regions.NwS.bndry(2,:),'linewi',2,'color','k');
m_line(regions.NoS.bndry(1,:),regions.NoS.bndry(2,:),'linewi',2,'color','k');
m_line(regions.CaI.bndry(1,:),regions.CaI.bndry(2,:),'linewi',2,'color','k');

%% Plot Tagging and Pop-Up Locations

% Plot each tag.
for i = 1:length(TOPPid)
    m_plot(META.TaggingLongitudeE(META.TOPPID == TOPPid(i)),META.TaggingLatitudeN(META.TOPPID == TOPPid(i)),...
        'ks','MarkerFaceColor',cmap.tag(i,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);

    hold on

    m_plot(META.PopUpLongitudeE(META.TOPPID == TOPPid(i)),META.PopUpLatitudeN(META.TOPPID == TOPPid(i)),...
        'kv','MarkerFaceColor',cmap.tag(i,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);
end
clear i

%% Create figure border.

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

%% Add north arrow and scale bar.

m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

%% Add Legend

t = m_plot(0,0,'ks','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',8,'LineStyle','none');
p = m_plot(0,0,'kv','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',8,'LineStyle','none');

[~,icon] = legend([m, t, p],[cell(num2str(TOPPid));{'Tagging'};{'Pop-Up'}],'FontSize',14);
icons = findobj(icon, 'type', 'line');
set(icons,'MarkerSize',12);
clear TOPPid
clear icon*
clear t p

%% Set location of figure to match bin_map

set(gca,'Position',[0.1300 0.1100 0.7750 0.8150]);

%% Save figure.

cd([fdir '/figures']);
exportgraphics(gcf,'overview_map_ICATT.png','Resolution',300);

%% Clear

clear ax* h* m* *LIMS
clear ans

close gcf