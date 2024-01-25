%% plot_example_NT.m
% Sub-function of Norway_Tuna.m; plots track and timeseries of
% 5121087/20P2985 and zoomed into each hotspot.

%% TOPPID

t = 5121087;

%% Plot track.

% Create figure and axes for bathymetry.
figure('Position',[476 334 716 532]);

% Set projection of map.
LATLIMS = [15 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

% Plot bathymetry.
[cs,ch] = m_etopo2('contourf',-8000:500:0,'edgecolor','none');
colormap(m_colmap('blue'));

hold on

% Plot land.
m_gshhs_i('patch',[.7 .7 .7]);

hold on

% Set colormap by month.
MM = unique(month(SSM.Date));
cmap.month = [0.122,0.122,1 ; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
    0.914,1,0.745; 1,1,0; 1,0.666,0; 1,0,0; 0.659,0,0; 0.8,0.745,0.639;...
    0.663,0,0.902; 1,1,1];

% Plot SSM Positions
tmp.lon = SSM.Longitude(SSM.TOPPID == t);
tmp.lat = SSM.Latitude(SSM.TOPPID == t);
tmp.date = SSM.Date(SSM.TOPPID == t);

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

% Add location of Zoomed In Plots
m_plot(tmp.lon(tmp.date == datetime(2021,10,04)),...
    tmp.lat(tmp.date == datetime(2021,10,04)),...
    'kp','MarkerFaceColor',cmap.regions(2,:),'MarkerSize',25,'LineWidth',3)

m_plot(tmp.lon(tmp.date == datetime(2021,12,15)),...
    tmp.lat(tmp.date == datetime(2021,12,15)),...
    'kp','MarkerFaceColor',cmap.regions(3,:),'MarkerSize',25,'LineWidth',3)

m_plot(tmp.lon(tmp.date == datetime(2022,02,14)),...
    tmp.lat(tmp.date == datetime(2022,02,14)),...
    'kp','MarkerFaceColor',cmap.regions(6,:),'MarkerSize',25,'LineWidth',3)

m_plot(tmp.lon(tmp.date == datetime(2022,04,21)),...
    tmp.lat(tmp.date == datetime(2022,04,21)),...
    'kp','MarkerFaceColor',cmap.regions(4,:),'MarkerSize',25,'LineWidth',3)

m_plot(tmp.lon(tmp.date == datetime(2022,06,06)),...
    tmp.lat(tmp.date == datetime(2022,06,06)),...
    'kp','MarkerFaceColor',cmap.regions(5,:),'MarkerSize',25,'LineWidth',3)

clear tmp

% Plot ICCAT regions.
m_line([-45 -45],[15 70],'linewi',2,'color','k','linestyle','--')

% Plot hotspots.
m_plot(regions.Nordic(1,:),regions.Nordic(2,:),'k-','LineWidth',2)
m_plot(regions.NB(1,:),regions.NB(2,:),'k-','LineWidth',2)
m_plot(regions.CI(1,:),regions.CI(2,:),'k-','LineWidth',2)
m_plot(regions.Med(1,:),regions.Med(2,:),'k-','LineWidth',2)
m_plot(regions.WEB(1,:),regions.WEB(2,:),'k-','LineWidth',2)

% Plot Tagging and Pop-Up Locations
m_plot(META.TaggingLongitudeE(META.TOPPID == t),META.TaggingLatitudeN(META.TOPPID == t),...
    'ks','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',14,'LineStyle','none','LineWidth',1);

hold on

m_plot(META.PopUpLongitudeE(META.TOPPID == t),META.PopUpLatitudeN(META.TOPPID == t),...
    'kv','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',12,'LineStyle','none','LineWidth',1);

% Create figure border.
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',18);

% Add north arrow and scale bar.
m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.1 .3],.1,2,'fontsize',16,'ticklength',0.01);

% Bathymetry Bar
h1 = m_contfbar([.65 .95],.27,cs,ch,'endpiece','no','FontSize',14);
xlabel(h1,'Bottom Depth (m)','FontWeight','bold');

% Add TOPP ID
patch([0.6 1 1 0.6],[1.325 1.325 1.45 1.45],'w');
text(0.65,1.385,META.PSAT{ismember(META.TOPPID,t)},'color','k','FontSize',20);

% Save figure.
cd([fdir '/figures/example']);
exportgraphics(gcf,['track_' num2str(t) '.png'],'Resolution',300);

% Clear
clear ax* h* m MM *LIMS
clear cs ch
clear ans

% close gcf

%% Plot timeseries.

% Create figure.
figure('Position',[112 219 1272 532]);

% Plot timeseries.
scatter(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),PSAT.Depth(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    4,PSAT.Temperature(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),'filled');

set(gca,'ydir','reverse','FontSize',24,'LineWidth',3);
xlabel('Date','FontSize',30); ylabel('Depth (m)','FontSize',30);

% Set colormap for timeseries.
colormap(getPyPlot_cMap('Spectral_r'));

h = colorbar; ylabel(h,'Temperature (^oC)','FontSize',28);
h.FontSize = 26;
caxis([0 30]); h.Ticks = 0:5:30;

clear h

% Set axes.
tmp = PSAT.DateTime(PSAT.TOPPID == t);
if year(tmp(1)) == 2020
    xlim([datetime(2020,08,30) datetime(2021,10,15)]);
elseif year(tmp(1)) == 2021
    xlim([datetime(2021,08,30) datetime(2022,10,15)]);
elseif year(tmp(1)) == 2022
    xlim([datetime(2022,08,30) datetime(2023,10,15)]);
end

ylim([-50 1200]);

box on;

hold on

% Plot hotspot.
tmp = PSAT(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t),:);

ind = ischange(tmp.Region(tmp.TOPPID == t));
ind = [1; find(ind); length(tmp.Region(tmp.TOPPID == t))];

for j = 1:length(ind)-1
    p(j) = patch([tmp.DateTime(ind(j)) tmp.DateTime(ind(j)) ...
        tmp.DateTime(ind(j+1)-1) tmp.DateTime(ind(j+1)-1) tmp.DateTime(ind(j))],...
        [-10 -50 -50 -10 -10],cmap.regions(tmp.Region(ind(j))+1,:),'EdgeColor','none');
end
clear j
clear ind
clear tmp

% Plot zoomed in dates.
plot(datetime(2021,10,04),-25,'pk','MarkerSize',20,'LineWidth',2)
plot(datetime(2021,12,15),-25,'pk','MarkerSize',20,'LineWidth',2)
plot(datetime(2022,02,14),-25,'pk','MarkerSize',20,'LineWidth',2)
plot(datetime(2022,04,21),-25,'pk','MarkerSize',20,'LineWidth',2)
plot(datetime(2022,06,06),-25,'pk','MarkerSize',20,'LineWidth',2)

% Save figure.
cd([fdir '/figures/example']);
exportgraphics(gcf,['timeseries_' num2str(t) '.png'],'Resolution',300);

% close gcf

%% Plot NOR.

figure('Position',[710 148 550 535]);

tmp.lon = SSM.Longitude(SSM.TOPPID == t);
tmp.lat = SSM.Latitude(SSM.TOPPID == t);
tmp.date = SSM.Date(SSM.TOPPID == t);

[SRISE,SSET] = sunrise(tmp.lat(tmp.date == datetime(2021,10,04)),tmp.lon(tmp.date == datetime(2021,10,04)),0,0,datetime(2021,10,04));

patch([datetime(2021,10,04) datetime(2021,10,04) datetime(SRISE,'ConvertFrom','datenum') datetime(SRISE,'ConvertFrom','datenum') datetime(2021,10,04)],...
    [0 600 600 0 0],[0.7 0.7 0.7])

hold on

patch([datetime(SSET,'ConvertFrom','datenum') datetime(SSET,'ConvertFrom','datenum') datetime(2021,10,05) datetime(2021,10,05) datetime(SSET,'ConvertFrom','datenum')],...
    [0 600 600 0 0],[0.7 0.7 0.7])

hold on

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Depth(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'k-','LineWidth',2);
xlim([datetime(2021,10,04) datetime(2021,10,05)]); ylim([0 600]);
yticks(0:50:300); yticklabels(0:50:300);

set(gca,'ydir','reverse','FontSize',20,'LineWidth',2);

box on

y = ylabel('Depth (m)','FontSize',24); xlabel('Date','FontSize',24);
y.Position(2) = 150;

hold on

yyaxis right

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Temperature(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'r-','LineWidth',2);
xlim([datetime(2021,10,04) datetime(2021,10,05)]); ylim([0 60]);
yticks(0:5:30); yticklabels(0:5:30);

set(gca,'LineWidth',2,'YColor','r'); 

y = ylabel('Temperature (^oC)','FontSize',24);
pos = get(gca,'Position');
y.Position(2) = 15;
set(gca,'Position',pos)

% Save figure.
cd([fdir '/figures/example']);
exportgraphics(gcf,['NOR_Oct42021_' num2str(t) '.png'],'Resolution',300);

%% Plot NB.

figure('Position',[710 148 550 535]);

[SRISE,SSET] = sunrise(tmp.lat(tmp.date == datetime(2021,12,15)),tmp.lon(tmp.date == datetime(2021,12,15)),0,0,datetime(2021,12,15));

patch([datetime(2021,12,15) datetime(2021,12,15) datetime(SRISE,'ConvertFrom','datenum') datetime(SRISE,'ConvertFrom','datenum') datetime(2021,12,15)],...
    [0 600 600 0 0],[0.7 0.7 0.7])

hold on

patch([datetime(SSET,'ConvertFrom','datenum') datetime(SSET,'ConvertFrom','datenum') datetime(2021,12,16) datetime(2021,12,16) datetime(SSET,'ConvertFrom','datenum')],...
    [0 600 600 0 0],[0.7 0.7 0.7])

hold on

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Depth(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'k-','LineWidth',2);
xlim([datetime(2021,12,15) datetime(2021,12,16)]); ylim([0 600]);
yticks(0:50:400); yticklabels(0:50:400);

set(gca,'ydir','reverse','FontSize',20,'LineWidth',2);

box on

y = ylabel('Depth (m)','FontSize',24); xlabel('Date','FontSize',24);
y.Position(2) = 200;

hold on

yyaxis right

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Temperature(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'r-','LineWidth',2);
xlim([datetime(2021,12,15) datetime(2021,12,16)]); ylim([0 60]);
yticks(0:5:30); yticklabels(0:5:30);

set(gca,'LineWidth',2,'YColor','r'); 

y = ylabel('Temperature (^oC)','FontSize',24);
pos = get(gca,'Position');
y.Position(2) = 15;
set(gca,'Position',pos)

% Save figure.
cd([fdir '/figures/example']);
exportgraphics(gcf,['NB_Dec152021_' num2str(t) '.png'],'Resolution',300);

%% Plot WEB

figure('Position',[710 148 550 535]);

[SRISE,SSET] = sunrise(tmp.lat(tmp.date == datetime(2022,02,14)),tmp.lon(tmp.date == datetime(2022,02,14)),0,0,datetime(2022,02,14));

patch([datetime(2022,02,14) datetime(2022,02,14) datetime(SRISE,'ConvertFrom','datenum') datetime(SRISE,'ConvertFrom','datenum') datetime(2022,02,14)],...
    [0 1000 1000 0 0],[0.7 0.7 0.7])

hold on

patch([datetime(SSET,'ConvertFrom','datenum') datetime(SSET,'ConvertFrom','datenum') datetime(2022,02,15) datetime(2022,02,15) datetime(SSET,'ConvertFrom','datenum')],...
    [0 1000 1000 0 0],[0.7 0.7 0.7])

hold on

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Depth(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'k-','LineWidth',2);
xlim([datetime(2022,02,14) datetime(2022,02,15)]); ylim([0 1000]);
yticks(0:100:700); yticklabels(0:100:700);

set(gca,'ydir','reverse','FontSize',20,'LineWidth',2);

box on

y = ylabel('Depth (m)','FontSize',24); xlabel('Date','FontSize',24);
y.Position(2) = 350;

hold on

yyaxis right

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Temperature(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'r-','LineWidth',2);
xlim([datetime(2022,02,14) datetime(2022,02,15)]); ylim([0 60]);
yticks(0:5:30); yticklabels(0:5:30);

set(gca,'LineWidth',2,'YColor','r'); 

y = ylabel('Temperature (^oC)','FontSize',24);
pos = get(gca,'Position');
y.Position(2) = 15;
set(gca,'Position',pos)

% Save figure.
cd([fdir '/figures/example']);
exportgraphics(gcf,['WEB_Feb142022_' num2str(t) '.png'],'Resolution',300);

%% Plot Canaries

figure('Position',[710 148 550 535]);

[SRISE,SSET] = sunrise(tmp.lat(tmp.date == datetime(2022,04,21)),tmp.lon(tmp.date == datetime(2022,04,21)),0,0,datetime(2022,04,21));

patch([datetime(2022,04,21) datetime(2022,04,21) datetime(SRISE,'ConvertFrom','datenum') datetime(SRISE,'ConvertFrom','datenum') datetime(2022,04,21)],...
    [0 1000 1000 0 0],[0.7 0.7 0.7])

hold on

patch([datetime(SSET,'ConvertFrom','datenum') datetime(SSET,'ConvertFrom','datenum') datetime(2022,04,22) datetime(2022,04,22) datetime(SSET,'ConvertFrom','datenum')],...
    [0 1000 1000 0 0],[0.7 0.7 0.7])

hold on

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Depth(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'k-','LineWidth',2);
xlim([datetime(2022,04,21) datetime(2022,04,22)]); ylim([0 1000]);
yticks(0:100:600); yticklabels(0:100:600);

set(gca,'ydir','reverse','FontSize',20,'LineWidth',2);

box on

y = ylabel('Depth (m)','FontSize',24); xlabel('Date','FontSize',24);
y.Position(2) = 300;

hold on

yyaxis right

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Temperature(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'r-','LineWidth',2);
xlim([datetime(2022,04,21) datetime(2022,04,22)]); ylim([0 60]);
yticks(0:5:30); yticklabels(0:5:30);

set(gca,'LineWidth',2,'YColor','r'); 

y = ylabel('Temperature (^oC)','FontSize',24);
pos = get(gca,'Position');
y.Position(2) = 15;
set(gca,'Position',pos)

% Save figure.
cd([fdir '/figures/example']);
exportgraphics(gcf,['Canaries_Apr212022_' num2str(t) '.png'],'Resolution',300);

%% Plot Med

figure('Position',[710 148 550 535]);

[SRISE,SSET] = sunrise(tmp.lat(tmp.date == datetime(2022,06,06)),tmp.lon(tmp.date == datetime(2022,06,06)),0,0,datetime(2022,06,06));

patch([datetime(2022,06,06) datetime(2022,06,06) datetime(SRISE,'ConvertFrom','datenum') datetime(SRISE,'ConvertFrom','datenum') datetime(2022,06,06)],...
    [0 1000 1000 0 0],[0.7 0.7 0.7])

hold on

patch([datetime(SSET,'ConvertFrom','datenum') datetime(SSET,'ConvertFrom','datenum') datetime(2022,06,07) datetime(2022,06,07) datetime(SSET,'ConvertFrom','datenum')],...
    [0 1000 1000 0 0],[0.7 0.7 0.7])

hold on

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Depth(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'k-','LineWidth',2);
xlim([datetime(2022,06,06) datetime(2022,06,07)]); ylim([0 100]);
yticks(0:10:100); yticklabels(0:10:100);

set(gca,'ydir','reverse','FontSize',20,'LineWidth',2);

box on

y = ylabel('Depth (m)','FontSize',24); xlabel('Date','FontSize',24);
y.Position(2) = 50;

hold on

yyaxis right

plot(PSAT.DateTime(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    PSAT.Temperature(PSAT.TOPPID == t & PSAT.Date <= META.PopUpDate(META.TOPPID == t)),...
    'r-','LineWidth',2);
xlim([datetime(2022,06,06) datetime(2022,06,07)]); ylim([0 60]);
yticks(0:5:30); yticklabels(0:5:30);

set(gca,'LineWidth',2,'YColor','r'); 

y = ylabel('Temperature (^oC)','FontSize',24);
pos = get(gca,'Position');
y.Position(2) = 15;
set(gca,'Position',pos)

% Save figure.
cd([fdir '/figures/example']);
exportgraphics(gcf,['Med_Jun062022_' num2str(t) '.png'],'Resolution',300);

%% Clear

clear ans
clear pos
clear SRISE
clear SSET
clear t
clear tmp
clear TOPPid
clear toppIDs_omit
clear y
