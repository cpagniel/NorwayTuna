%% plot_corr_T_at_MLD_NT %%
% Sub-function of Norway_Tuna.m; plots scatter plots showing correlation 
% between dive metrics and T at MLD with dots colored by hotspots.

%% Plot Correlations of Dive Metrics vs. T at MLD

% Dive F vs. T_at_MLD
figure;
scatter(bins.T_at_MLD,bins.daily_dive_f,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('Temperature at MLD (^oC)','FontSize',26); y = ylabel('Dive Frequency (no./day)','FontSize',26);
y.Position(1) = 7.5;
colormap(cmap.regions)
text(21, 57, ['\rho = ' num2str(roundn(stats.corr.rho.diveF_vs_Tmld,-2))],'FontSize',18, 'FontWeight','bold')

cd([fdir '/figures/corr']);
exportgraphics(gcf,'diveF_vs_T_at_MLD.png','Resolution',300)
close all
clear y

% Duration vs. T_at_MLD
figure;
scatter(bins.T_at_MLD,bins.duration,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('Temperature at MLD (^oC)','FontSize',26); y = ylabel('Dive Duration (hours)','FontSize',26);
y.Position(1) = 7.5;
colormap(cmap.regions)
text(21, 47, ['\rho = ' num2str(roundn(stats.corr.rho.Ddur_vs_Tmld,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'dur_vs_T_at_MLD.png','Resolution',300)
close all
clear y

% Descent Rate vs. T_at_MLD
figure;
scatter(bins.T_at_MLD,bins.descent_rate,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('Temperature at MLD (^oC)','FontSize',26); y = ylabel('Descent Rate (m/s)','FontSize',26);
y.Position(1) = 7.5;
colormap(cmap.regions)
text(21, 9.3, ['\rho = ' num2str(roundn(stats.corr.rho.desR_vs_Tmld,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'desR_vs_T_at_MLD.png','Resolution',300)
close all
clear y

% Median Day Depth vs. T_at_MLD
figure;
scatter(bins.T_at_MLD,bins.median_depth_day,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('Temperature at MLD (^oC)','FontSize',26); y = ylabel('Median Day Depth (m)','FontSize',26);
y.Position(1) = 7.5;
colormap(cmap.regions)
text(21, 470, ['\rho = ' num2str(roundn(stats.corr.rho.medDay_vs_Tmld,-2))],'FontSize',18, 'FontWeight','bold')

cd([fdir '/figures/corr']);
exportgraphics(gcf,'medDay_vs_T_at_MLD.png','Resolution',300)
close all
clear y

% Median Night Depth vs. T_at_MLD
figure;
scatter(bins.T_at_MLD,bins.median_depth_night,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('Temperature at MLD (^oC)','FontSize',26); y = ylabel('Median Night Depth (m)','FontSize',26);
y.Position(1) = 7.5;
colormap(cmap.regions)
text(21, 325, ['\rho = ' num2str(roundn(stats.corr.rho.medNight_vs_Tmld,-2))],'FontSize',18, 'FontWeight','bold')

cd([fdir '/figures/corr']);
exportgraphics(gcf,'medNight_vs_T_at_MLD.png','Resolution',300)
close all
clear y

% Daily Max Depth vs. T_at_MLD
figure;
scatter(bins.T_at_MLD,bins.daily_max_d,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('Temperature at MLD (^oC)','FontSize',26); y = ylabel('Daily Max Depth (m)','FontSize',26);
y.Position(1) = 7.5;
colormap(cmap.regions)
text(21, 1125, ['\rho = ' num2str(roundn(stats.corr.rho.maxD_vs_Tmld,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'maxD_vs_T_at_MLD.png','Resolution',300)
close all
clear y

% Time in Meso vs. T_at_MLD
figure;
scatter(bins.T_at_MLD,bins.time_in_meso,10,bins.hotspot,'filled')
set(gca,'FontSize',22,'LineWidth',2);
axis square; box on;
xlabel('Temperature at MLD (^oC)','FontSize',26); y = ylabel('% Time in Mesopelagic','FontSize',26);
y.Position(1) = 7.5;
colormap(cmap.regions)
text(21, 47, ['\rho = ' num2str(roundn(stats.corr.rho.timeM_vs_Tmld,-2))],'FontSize',18)

cd([fdir '/figures/corr']);
exportgraphics(gcf,'timeM_vs_T_at_MLD.png','Resolution',300)
close all
clear y