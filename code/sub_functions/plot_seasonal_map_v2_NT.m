%% plot_seasonal_map_v2_NT.m
% Sub-function of Norway_Tuna.m; plots SSM tracks of all tags in each season
% colored by month.

%% Create figure.

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

%% Set colormap by month.

MM = unique(month(SSM.Date));
cmap.month = [0.122,0.122,1; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
    0.914,1,0.745; 1,1,0; 1,0.666,0; 1,0,0; 0.659,0,0; 0.8,0.745,0.639;...
    0.663,0,0.902; 1,1,1];

%% Loop through each season and add to same plot.

for i = 1:length(unique(SSM.Season))

    %% Plot SSM positions of tuna colored by month.

    % Plot each tag.
    for j = 1:length(MM)
        if i == 2 && (j == 12 || j == 1 || j == 2)
            m(j) = m_plot(SSM.Longitude(MM(j) == month(SSM.Date)),...
                SSM.Latitude(MM(j) == month(SSM.Date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',4,'LineStyle','none','LineWidth',1);
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',4);
        end
        if i == 3 && (j == 3 || j == 4 || j == 5)
            m(j) = m_plot(SSM.Longitude(MM(j) == month(SSM.Date)),...
                SSM.Latitude(MM(j) == month(SSM.Date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',4,'LineStyle','none','LineWidth',1);
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',4);
        end

        if i == 4 && (j == 6 || j == 7 || j == 8)
            m(j) = m_plot(SSM.Longitude(MM(j) == month(SSM.Date)),...
                SSM.Latitude(MM(j) == month(SSM.Date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerSize',4,'MarkerEdgeColor','k','LineStyle','none','LineWidth',1);
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',4);
        end

        if i == 1 && (j == 9 || j == 10 || j == 11)
            m(j) = m_plot(SSM.Longitude(MM(j) == month(SSM.Date)),...
                SSM.Latitude(MM(j) == month(SSM.Date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerSize',4,'MarkerEdgeColor','k','LineStyle','none','LineWidth',1);
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',4);
        end
    end
    clear j
end
clear i

%% Plot ICCAT regions.

m_line([-45 -45],[15 70],'linewi',2,'color','k','linestyle','--')

%% Plot hotspots.

% m_plot(regions.Nordic(1,:),regions.Nordic(2,:),'k-','LineWidth',2)
% m_plot(regions.NB(1,:),regions.NB(2,:),'k-','LineWidth',2)
% m_plot(regions.CI(1,:),regions.CI(2,:),'k-','LineWidth',2)
% m_plot(regions.Med(1,:),regions.Med(2,:),'k-','LineWidth',2)
% m_plot(regions.WEB(1,:),regions.WEB(2,:),'k-','LineWidth',2)

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
exportgraphics(gcf,'seasonal_map_v2.png','Resolution',300);

%% Add Legend

delete(h1);

[~,icon] = legend(m,{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'},...
    'FontSize',14,'Location','eastoutside');
icons = findobj(icon, 'type', 'line');
set(icons,'MarkerSize',12);
clear MM
clear icon*

exportgraphics(gcf,'monthly_legend.png','Resolution',300);

%% Clear

clear ax* h* m MM *LIMS
clear cs ch
clear ans

close gcf