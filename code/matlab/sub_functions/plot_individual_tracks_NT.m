%% plot_individual_tracks_NT.m
% Sub-function of Norway_Tuna.m; plots SSM tracks of each tags
% colored by month.

%% Get Unique TOPP IDs

toppID = unique(SSM.TOPPID);

%% Loop Through All TOPP IDs

CI = cell(length(toppID),1);

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

    %% Load confidence intervals.

    cd('/Users/cpagniello/Library/CloudStorage/GoogleDrive-cpagniel@stanford.edu/.shortcut-targets-by-id/1IB_xjgI9jsc5TBK4_2kBD3s2DxfWXYCS/ABFT_Norway/SSM_rawoutput/')

    tmp = readmatrix([num2str(toppID(t)) '00_99CI_full.xlsx']);

    %% Plot confidence intervals.

    m_plot(tmp(:,1),tmp(:,2),'k:','LineWidth',2)

    CI{t} = tmp;

    clear tmp

    %% Plot land.

    m_coast('patch',[.7 .7 .7]);
    % m_gshhs_i('patch',[.7 .7 .7]);

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
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',8,'LineWidth',1);
            hold on
        else
            m(j) = m_plot(tmp.lon(MM(j) == month(tmp.date)),...
                tmp.lat(MM(j) == month(tmp.date)),...
                'ko','MarkerFaceColor',cmap.month(j,:),'MarkerEdgeColor','k','MarkerSize',8,'LineWidth',1);
            hold on
        end
    end
    clear j
    clear tmp

    %% Plot ICCAT regions.

    m_line([-45 -45],[15 70],'linewi',2,'color','k','linestyle','--')

    %% Plot hotspots.

    m_plot(regions.Nordic(1,:),regions.Nordic(2,:),'k-','LineWidth',2)
    m_plot(regions.NB(1,:),regions.NB(2,:),'k-','LineWidth',2)
    m_plot(regions.CI(1,:),regions.CI(2,:),'k-','LineWidth',2)
    m_plot(regions.Med(1,:),regions.Med(2,:),'k-','LineWidth',2)
    m_plot(regions.WEB(1,:),regions.WEB(2,:),'k-','LineWidth',2)

    %% Plot Tagging and Pop-Up Locations

    m_plot(META.TaggingLongitudeE(META.TOPPID == toppID(t)),META.TaggingLatitudeN(META.TOPPID == toppID(t)),...
        'ks','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',14,'LineStyle','none','LineWidth',1);

    hold on

    m_plot(META.PopUpLongitudeE(META.TOPPID == toppID(t)),META.PopUpLatitudeN(META.TOPPID == toppID(t)),...
        'kv','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',12,'LineStyle','none','LineWidth',1);

    %% Create figure border.

    m_grid('linewi',2,'tickdir','in','linest','none','fontsize',18);

    %% Add north arrow and scale bar.

    m_northarrow(-75,65,4,'type',2,'linewi',2);
    m_ruler([.1 .3],.1,2,'fontsize',16,'ticklength',0.01);

    %% Bathymetry Bar

    h1 = m_contfbar([.65 .95],.27,cs,ch,'endpiece','no','FontSize',14);

    xlabel(h1,'Bottom Depth (m)','FontWeight','bold');

    %% Add TOPP ID

    patch([0.6 1 1 0.6],[1.325 1.325 1.45 1.45],'w');
    text(0.65,1.385,META.PSAT{ismember(META.TOPPID,toppID(t))},'color','k','FontSize',20);

    %% Save figure.

    cd([fdir '/figures/individual_tracks']);
    exportgraphics(gcf,[num2str(toppID(t)) '.png'],'Resolution',300);

    %% Clear

    clear ax* h* m MM *LIMS
    clear cs ch
    clear ans

    close gcf

end
clear t*