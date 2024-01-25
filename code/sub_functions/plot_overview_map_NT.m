%% plot_overview_map_NT %%
% Sub-function of Norway_Tuna.m; plots SSM tracks of all tags colored by
% year.

%% Create figure and axes for bathymetry.

figure('Position',[476 334 716 532]);

%% Set projection of map.

LATLIMS = [15 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

%% Plot bathymetry.

[cs,ch] = m_etopo2('contourf',-8000:500:0,'edgecolor','none');

colormap(m_colmap('blue'));

hold on

%% Plot land.

m_gshhs_i('patch',[.7 .7 .7]);

hold on

%% Set colormap.

% by tag

% cmap.tag = getPyPlot_cMap('gist_ncar',14);
% cmap.tag([2 4 5],:) = [];
% cmap.tag = [cmap.tag(9,:); cmap.tag];
% cmap.tag = [cmap.tag(8+1,:); cmap.tag];
% cmap.tag = [cmap.tag(10+2,:); cmap.tag];
% cmap.tag = [cmap.tag(11+3,:); cmap.tag];
% cmap.tag(12:end,:) = [];
% cmap.tag(3,:) = [1 0 1];
% cmap.tag = flipud(cmap.tag);

% by year

% green, yellow, purple
% cmap.year = [0.149,0.451,0; 1,1,0; 0.663,0,0.902];

% red, orange, yellow
% cmap.year = [1,1,0; 1,0.666,0; 1,0,0];

% white, yellow, purple
% cmap.year = [1,1,1; 1,1,0; 0.663,0,0.902];

% white, yellow, red
cmap.year = [1,1,1; 1,1,0; 1,0,0];

%% Get unique TOPP IDs and PSAT IDs.

TOPPid = unique(SSM.TOPPID);
PSATid = META.PSAT(ismember(META.TOPPID,TOPPid));

%% Get unique deployment years.

yy = unique(year(META.TagginDate));

%% Plot SSM positions.

% by tag
% for i = 1:length(TOPPid)
%     m_plot(SSM.Longitude(SSM.TOPPID == TOPPid(i),:),SSM.Latitude(SSM.TOPPID == TOPPid(i),:),...
%         'k-','Color',[0.5 0.5 0.5]);
% 
%     hold on
% 
%     m_plot(SSM.Longitude(SSM.TOPPID == TOPPid(i),:),SSM.Latitude(SSM.TOPPID == TOPPid(i),:),...
%         'ko','MarkerFaceColor',cmap.tag(i,:),'MarkerEdgeColor','k','MarkerSize',4,'LineStyle','none','LineWidth',1);
% 
%     hold on
% 
%     m(i) = m_plot(-100,100,'o','MarkerFaceColor',cmap.tag(i,:),'MarkerEdgeColor','k','MarkerSize',5,'LineWidth',1);
% end
% clear i

% by deployment year
for i = fliplr(1:length(TOPPid))
    m_plot(SSM.Longitude(SSM.TOPPID == TOPPid(i),:),SSM.Latitude(SSM.TOPPID == TOPPid(i),:),...
        'k-','Color',[0.5 0.5 0.5]);

    hold on

    if year(META.TagginDate(META.TOPPID == TOPPid(i))) == 2020
        m_plot(SSM.Longitude(SSM.TOPPID == TOPPid(i),:),SSM.Latitude(SSM.TOPPID == TOPPid(i),:),...
            'ko','MarkerFaceColor',cmap.year(1,:),'MarkerEdgeColor','k','MarkerSize',4,'LineStyle','none','LineWidth',1);
    elseif year(META.TagginDate(META.TOPPID == TOPPid(i))) == 2021
        m_plot(SSM.Longitude(SSM.TOPPID == TOPPid(i),:),SSM.Latitude(SSM.TOPPID == TOPPid(i),:),...
            'ko','MarkerFaceColor',cmap.year(2,:),'MarkerEdgeColor','k','MarkerSize',4,'LineStyle','none','LineWidth',1);
    elseif year(META.TagginDate(META.TOPPID == TOPPid(i))) == 2022
        m_plot(SSM.Longitude(SSM.TOPPID == TOPPid(i),:),SSM.Latitude(SSM.TOPPID == TOPPid(i),:),...
            'ko','MarkerFaceColor',cmap.year(3,:),'MarkerEdgeColor','k','MarkerSize',4,'LineStyle','none','LineWidth',1);
    end

    hold on

end
clear i

m(1) = m_plot(-100,100,'o','MarkerFaceColor',cmap.year(1,:),'MarkerEdgeColor','k','MarkerSize',5,'LineWidth',1);
m(2) = m_plot(-100,100,'o','MarkerFaceColor',cmap.year(2,:),'MarkerEdgeColor','k','MarkerSize',5,'LineWidth',1);
m(3) = m_plot(-100,100,'o','MarkerFaceColor',cmap.year(3,:),'MarkerEdgeColor','k','MarkerSize',5,'LineWidth',1);

%% Plot ICCAT regions.

m_line([-45 -45],[15 70],'linewi',2,'color','k','linestyle','--')

%% Plot Tagging and Pop-Up Locations

% for i = 1:length(TOPPid)
%     m_plot(META.TaggingLongitudeE(META.TOPPID == TOPPid(i)),META.TaggingLatitudeN(META.TOPPID == TOPPid(i)),...
%         'ks','MarkerFaceColor',cmap.tag(i,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);
% 
%     hold on
% 
%     m_plot(META.PopUpLongitudeE(META.TOPPID == TOPPid(i)),META.PopUpLatitudeN(META.TOPPID == TOPPid(i)),...
%         'kv','MarkerFaceColor',cmap.tag(i,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);
% end
% clear i

for i = fliplr(1:length(TOPPid))

    if year(META.TagginDate(META.TOPPID == TOPPid(i))) == 2020
        m_plot(META.TaggingLongitudeE(META.TOPPID == TOPPid(i)),META.TaggingLatitudeN(META.TOPPID == TOPPid(i)),...
         'ks','MarkerFaceColor',cmap.year(1,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);

        hold on

        m_plot(META.PopUpLongitudeE(META.TOPPID == TOPPid(i)),META.PopUpLatitudeN(META.TOPPID == TOPPid(i)),...
         'kv','MarkerFaceColor',cmap.year(1,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);
    elseif year(META.TagginDate(META.TOPPID == TOPPid(i))) == 2021
        m_plot(META.TaggingLongitudeE(META.TOPPID == TOPPid(i)),META.TaggingLatitudeN(META.TOPPID == TOPPid(i)),...
         'ks','MarkerFaceColor',cmap.year(2,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);

        hold on

        m_plot(META.PopUpLongitudeE(META.TOPPID == TOPPid(i)),META.PopUpLatitudeN(META.TOPPID == TOPPid(i)),...
         'kv','MarkerFaceColor',cmap.year(2,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);
    elseif year(META.TagginDate(META.TOPPID == TOPPid(i))) == 2022
        m_plot(META.TaggingLongitudeE(META.TOPPID == TOPPid(i)),META.TaggingLatitudeN(META.TOPPID == TOPPid(i)),...
         'ks','MarkerFaceColor',cmap.year(3,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);

        hold on

        m_plot(META.PopUpLongitudeE(META.TOPPID == TOPPid(i)),META.PopUpLatitudeN(META.TOPPID == TOPPid(i)),...
         'kv','MarkerFaceColor',cmap.year(3,:),'MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);
    end

    hold on

end
clear i

%% Create figure border.

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',18);

%% Add north arrow and scale bar.

m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.1 .3],.1,2,'fontsize',16,'ticklength',0.01);

%% Bathymetry Bar

h1 = m_contfbar([.65 .95],.27,cs,ch,'endpiece','no','FontSize',14);

xlabel(h1,'Bottom Depth (m)','FontWeight','bold');

%% Set location of figure to match bin_map

set(gca,'Position',[0.1300 0.1100 0.7750 0.8150]);

%% Save figure.

cd([fdir '/figures']);
exportgraphics(gcf,'overview_map.png','Resolution',300);

%% Add Legend

% delete(h1);
% 
% t = m_plot(0,0,'ks','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',8,'LineStyle','none');
% p = m_plot(0,0,'kv','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',8,'LineStyle','none');
% 
% [~,icon] = legend([m, t, p],[PSATid;{'Tagging'};{'Pop-Up'}],'FontSize',14,'Location','eastoutside');
% icons = findobj(icon, 'type', 'line');
% set(icons,'MarkerSize',12);
% clear PSATid
% clear icon*
% clear t p

delete(h1);

t = m_plot(0,0,'ks','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',8,'LineStyle','none');
p = m_plot(0,0,'kv','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',8,'LineStyle','none');

[~,icon] = legend([m, t, p],[str2cell(string(yy));"Tagging";"Pop-Up"],'FontSize',14,'Location','eastoutside');
icons = findobj(icon, 'type', 'line');
set(icons,'MarkerSize',12);
clear yy
clear icon*
clear t p

%% Save figure with legend.

cd([fdir '/figures']);
exportgraphics(gcf,'overview_map_legend.png','Resolution',300);

%% Clear

clear ax* h* m* *LIMS
clear cs ch
clear ans
clear TOPPid
clear PSATid

close gcf