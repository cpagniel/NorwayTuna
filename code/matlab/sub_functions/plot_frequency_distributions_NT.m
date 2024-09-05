%% plot_frequency_distributions_NT.m
% Sub-function of Norway_Tuna.m; plots frequency distributions of temperature
% and depth.

%% Temperature

figure;
histogram(PSAT.Temperature,0:2.5:30,'FaceColor','r')
set(gca,'FontSize',20)
xlabel('Temperature (^oC)','FontSize',24)
ylabel('Number of Observations','FontSize',24)
xlim([0 30])
axis square
grid on 
grid minor

cd([fdir '/figures']);
exportgraphics(gcf,'freq_dist_temp.png','Resolution',300);

close all

%% Depth

figure;
histogram(PSAT.Depth,0:50:1200,'FaceColor','k')
set(gca,'FontSize',20)
xlabel('Depth (m)','FontSize',24)
ylabel('Number of Observations','FontSize',24)
xlim([0 1200])
axis square
grid on 
grid minor

cd([fdir '/figures']);
exportgraphics(gcf,'freq_dist_depth_full.png','Resolution',300);

xlim([200 1200])
ylim([0 1.5*10^6])

cd([fdir '/figures']);
exportgraphics(gcf,'freq_dist_depth_crop.png','Resolution',300);

close all
