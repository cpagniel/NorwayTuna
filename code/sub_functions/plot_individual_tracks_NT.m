%% plot_individual_tracks_NT.m
% Sub-function of Norway_Tuna.m; plots SSM tracks of each tags
% colored by month.

%% Get Unique TOPP IDs

toppID = unique(SSM.TOPPID);

%% Loop Through All TOPP IDs

for t = 1:length(toppID)

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

    %% Set colormap by month.

    MM = unique(month(SSM.Date));
    %     cmap.month = [0.122,0.122,1; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
    %         0.914,1,0.745; 0.9843,0.6039,0.6000; 1,0,0; 0.659,0,0;  0.9365,0.4000,0.0681;
    %         1,0.666,0; 0.9943,0.8627,0.7294; 0.6510,0.8078,0.8902];
    cmap.month = [0.122,0.122,1 ; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
        0.914,1,0.745; 1,1,0; 1,0.666,0; 1,0,0; 0.659,0,0; 0.8,0.745,0.639;...
        0.663,0,0.902; 1,1,1];

    %% Plot SSM Positions

    tmp.lon = SSM.Longitude(SSM.TOPPID == toppID(t));
    tmp.lat = SSM.Latitude(SSM.TOPPID == toppID(t));
    tmp.date = SSM.Date(SSM.TOPPID == toppID(t));

    m_plot(tmp.lon,tmp.lat,'k-');

    hold on

    for j = 1:length(MM)
        if isempty(tmp.lon(MM(j) == month(tmp.date)))
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',7,'LineWidth',1);
            hold on
        else
            m(j) = m_plot(tmp.lon(MM(j) == month(tmp.date)),...
                tmp.lat(MM(j) == month(tmp.date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',7,'LineWidth',1);
            hold on
        end
    end
    clear j
    clear tmp

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

    %% Plot Tagging and Pop-Up Locations

    m_plot(META.TaggingLongitudeE(META.TOPPID == toppID(t)),META.TaggingLatitudeN(META.TOPPID == toppID(t)),...
        'ks','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);

    hold on

    m_plot(META.PopUpLongitudeE(META.TOPPID == toppID(t)),META.PopUpLatitudeN(META.TOPPID == toppID(t)),...
        'kv','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',10,'LineStyle','none','LineWidth',1);

    %% Create figure border.

    m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

    %% Add north arrow and scale bar.

    m_northarrow(-75,65,4,'type',2,'linewi',2);
    m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

    %% Add TOPP ID

    patch([0.6 1 1 0.6],[1.325 1.325 1.45 1.45],'w');
    text(0.65,1.385,num2str(toppID(t)),'color','k','FontSize',20);

    %% Save figure.

    cd([fdir '/figures/individual_tracks']);
    exportgraphics(gcf,[num2str(toppID(t)) '_ICCAT.png'],'Resolution',300);

    %% Clear

    clear ax* h* m MM *LIMS
    clear ans

    close gcf

end
clear t*