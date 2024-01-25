%% plot_corr_MLD_NT %%
% Sub-function of Norway_Tuna.m; plots scatter plots showing correlation 
% between dive metrics and MLD with dots colored by hotspots.

%% Plot Correlations of Dive Metrics vs. MLD

% Dive F vs. MLD
figure;
scatter(bins.MLD,bins.daily_dive_f,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('MLD (m)','FontSize',26); y = ylabel('Dive Frequency (no./day)','FontSize',26);
y.Position(1) = -65;
colormap(cmap.regions)
text(300, 57, ['\rho = ' num2str(roundn(stats.corr.rho.diveF_vs_MLD,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'diveF_vs_MLD.png','Resolution',300)
close all
clear y

% Duration vs. MLD
figure;
scatter(bins.MLD,bins.duration,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('MLD (m)','FontSize',26); y = ylabel('Dive Duration (hours)','FontSize',26);
y.Position(1) = -65;
colormap(cmap.regions)
text(300, 47, ['\rho = ' num2str(roundn(stats.corr.rho.Ddur_vs_MLD,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'dur_vs_MLD.png','Resolution',300)
close all
clear y

% Descent Rate vs. MLD
figure;
scatter(bins.MLD,bins.descent_rate,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('MLD (m)','FontSize',26); y = ylabel('Descent Rate (m/s)','FontSize',26);
y.Position(1) = -65;
colormap(cmap.regions)
text(300, 9.3, ['\rho = ' num2str(roundn(stats.corr.rho.desR_vs_MLD,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'desR_vs_MLD.png','Resolution',300)
close all
clear y

% Median Day Depth vs. MLD
figure;
scatter(bins.MLD,bins.median_depth_day,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('MLD (m)','FontSize',26); y = ylabel('Median Day Depth (m)','FontSize',26);
y.Position(1) = -65;
colormap(cmap.regions)
text(300, 470, ['\rho = ' num2str(roundn(stats.corr.rho.medDay_vs_MLD,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'medDay_vs_MLD.png','Resolution',300)
close all
clear y

% Median Night Depth vs. MLD
figure;
scatter(bins.MLD,bins.median_depth_night,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('MLD (m)','FontSize',26); y = ylabel('Median Night Depth (m)','FontSize',26);
y.Position(1) = -65;
colormap(cmap.regions)
text(300, 325, ['\rho = ' num2str(roundn(stats.corr.rho.medNight_vs_MLD,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'medNight_vs_MLD.png','Resolution',300)
close all
clear y

% Daily Max Depth vs. MLD
figure;
scatter(bins.MLD,bins.daily_max_d,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('MLD (m)','FontSize',26); y = ylabel('Daily Max Depth (m)','FontSize',26);
y.Position(1) = -65;
colormap(cmap.regions)
text(300, 1125, ['\rho = ' num2str(roundn(stats.corr.rho.maxD_vs_MLD,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'maxD_vs_MLD.png','Resolution',300)
close all
clear y

% Time in Meso vs. MLD
figure;
scatter(bins.MLD,bins.time_in_meso,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('MLD (m)','FontSize',26); y = ylabel('% Time in Mesopelagic','FontSize',26);
y.Position(1) = -65;
colormap(cmap.regions)
text(300, 47, ['\rho = ' num2str(roundn(stats.corr.rho.timeM_vs_MLD,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'timeM_vs_MLD.png','Resolution',300)
close all
clear y