%% plot_seasonal_map_NT.m
% Sub-function of Norway_Tuna.m; plots SSM tracks of all tags in each season
% colored by month.

%% Determine season.

% 1 = Fall which includes September, October and November. 
% 2 = Winter which includes December, January and February. 
% 3 = Spring which includes March, April and May. 
% 4 = Summer which includes June, July and August. 

season = zeros(height(SSM),1);
season(month(SSM.Date) == 9 | month(SSM.Date) == 10 | month(SSM.Date) == 11) = 1;
season(month(SSM.Date) == 12 | month(SSM.Date) == 1 | month(SSM.Date) == 2) = 2;
season(month(SSM.Date) == 3 | month(SSM.Date) == 4 | month(SSM.Date) == 5) = 3;
season(month(SSM.Date) == 6 | month(SSM.Date) == 7 | month(SSM.Date) == 8) = 4;

SSM.Season = season;

clear season

%% Loop through each season.

for i = 1:length(unique(SSM.Season))

    %% Create figure.

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

    %% Set colormap by month.

    MM = unique(month(SSM.Date));
%     cmap.month = [0.122,0.122,1; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
%         0.914,1,0.745; 0.9843,0.6039,0.6000; 1,0,0; 0.659,0,0;  0.9365,0.4000,0.0681; 
%         1,0.666,0; 0.9943,0.8627,0.7294; 0.6510,0.8078,0.8902];
    cmap.month = [0.122,0.122,1 ; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;... 
        0.914,1,0.745; 1,1,0; 1,0.666,0; 1,0,0; 0.659,0,0; 0.8,0.745,0.639;...
        0.663,0,0.902; 1,1,1];

    %% Plot SSM positions of tuna colored by month.

    % Plot each tag.
    for j = 1:length(MM)
        if i == 1 && (j == 12 || j == 1 || j == 2)
            m(j) = m_plot(SSM.Longitude(MM(j) == month(SSM.Date)),...
                SSM.Latitude(MM(j) == month(SSM.Date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',5);
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',5);
        end
        if i == 2 && (j == 3 || j == 4 || j == 5)
            m(j) = m_plot(SSM.Longitude(MM(j) == month(SSM.Date)),...
                SSM.Latitude(MM(j) == month(SSM.Date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',5);
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',5);
        end

        if i == 3 && (j == 6 || j == 7 || j == 8)
            m(j) = m_plot(SSM.Longitude(MM(j) == month(SSM.Date)),...
                SSM.Latitude(MM(j) == month(SSM.Date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerSize',5,'MarkerEdgeColor','k');
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',5);
        end

        if i == 4 && (j == 9 || j == 10 || j == 11)
            m(j) = m_plot(SSM.Longitude(MM(j) == month(SSM.Date)),...
                SSM.Latitude(MM(j) == month(SSM.Date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerSize',5,'MarkerEdgeColor','k');
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',5);
        end
    end
    clear j

    %% Plot ICCAT regions.

    m_line([-45 -45],[15 70],'linewi',2,'color','k','linestyle','--')

    %% Plot regions.

%     m_line(regions.NB.bndry(1,:),regions.NB.bndry(2,:),'linewi',2,'color','k');
%     m_line(regions.CoI.bndry(1,:),regions.CoI.bndry(2,:),'linewi',2,'color','k');
%     m_line(regions.BB.bndry(1,:),regions.BB.bndry(2,:),'linewi',2,'color','k');
%     m_line(regions.WEB.bndry(1,:),regions.WEB.bndry(2,:),'linewi',2,'color','k');
%     m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');
%     m_line(regions.NwS.bndry(1,:),regions.NwS.bndry(2,:),'linewi',2,'color','k');
%     m_line(regions.NoS.bndry(1,:),regions.NoS.bndry(2,:),'linewi',2,'color','k');
%     m_line(regions.CaI.bndry(1,:),regions.CaI.bndry(2,:),'linewi',2,'color','k');

    %% Create figure border.

    m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

    %% Add north arrow and scale bar.

    m_northarrow(-75,65,4,'type',2,'linewi',2);
    m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

    %% Save figure.

    cd([fdir '/figures']);
    if i == 1
        exportgraphics(gcf,'seasonal_map_winter_ICCAT.png','Resolution',300);
    elseif i == 2
        exportgraphics(gcf,'seasonal_map_spring_ICCAT.png','Resolution',300);
    elseif i == 3
        exportgraphics(gcf,'seasonal_map_summer_ICCAT.png','Resolution',300);
    elseif i == 4
        exportgraphics(gcf,'seasonal_map_fall_ICCAT.png','Resolution',300);
    end

    %% Add Legend

    if i == 4

        [~,icon] = legend(m,{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'},...
            'FontSize',14,'Location','eastoutside');
        icons = findobj(icon, 'type', 'line');
        set(icons,'MarkerSize',12);
        clear MM
        clear icon*

        exportgraphics(gcf,'monthly_legend.png','Resolution',300);

    end

    %% Clear

    clear ax* h* m MM *LIMS
    clear ans

    close gcf

end
clear i