%% plot_boxplots_season_NT %%
% Sub-function of Norway_Tuna.m; plots boxplots of vertical diving behavior
% by season.

%% Speed (m/s)

figure('Position',[476 516 787 350]);

B.speed.Season = zeros(height(B.speed.TOPPID),1);
B.speed.Season(month(B.speed.Date) == 9 | month(B.speed.Date) == 10 | month(B.speed.Date) == 11) = 1;
B.speed.Season(month(B.speed.Date) == 12 | month(B.speed.Date) == 1 | month(B.speed.Date) == 2) = 2;
B.speed.Season(month(B.speed.Date) == 3 | month(B.speed.Date) == 4 | month(B.speed.Date) == 5) = 3;
B.speed.Season(month(B.speed.Date) == 6 | month(B.speed.Date) == 7 | month(B.speed.Date) == 8) = 4;

for i = 1:4
    b = boxchart(i*ones(sum(B.speed.Season == i),1),B.speed.Speed_m_per_s(B.speed.Season == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    if i == 4
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Season','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Speed (m/s)','FontSize',24,'FontWeight','Bold');
        xlim([0 5]); xticks(1:1:4);
        ylim([0 2.5]);
        set(gca,'XTickLabel',{'Fall','Winter','Spring','Summer'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_speed_season.png','Resolution',300);

[~,~,tmp] = kruskalwallis(B.speed.Speed_m_per_s,B.speed.Season);
figure; c = multcompare(tmp);
stats.dive.season.p_speed = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Dive Frequency (no./day)

figure('Position',[476 516 787 350]);

for i = 1:4
    b = boxchart(i*ones(sum(SSM.Season == i),1),SSM.DivesPerDay(SSM.Season == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    if i == 4
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Season','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Dive Frequency (no./day)','FontSize',24,'FontWeight','Bold');
        xlim([0 5]); xticks(1:1:4);
        ylim([0 70]);
        set(gca,'XTickLabel',{'Fall','Winter','Spring','Summer'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_diveF_season.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.DivesPerDay,SSM.Season);
figure; c = multcompare(tmp);
stats.dive.season.p_diveF = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Duration (hours)

figure('Position',[476 516 787 350]);

for i = 1:4
    b = boxchart(i*ones(sum(B.dives.season == i),1),B.dives.duration(B.dives.season == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    if i == 4
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Season','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Duration (hours)','FontSize',24,'FontWeight','Bold');
        xlim([0 5]); xticks(1:1:4);
        ylim([0 2]);
        set(gca,'XTickLabel',{'Fall','Winter','Spring','Summer'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_duration_season.png','Resolution',300);

[~,~,tmp] = kruskalwallis(B.dives.duration,B.dives.season);
figure; c = multcompare(tmp);
stats.dive.season.p_duration = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Descent Rate (m/s)

figure('Position',[476 516 787 350]);

for i = 1:4
    b = boxchart(i*ones(sum(B.dives.season == i),1),B.dives.max_descent(B.dives.season == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    if i == 4
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Season','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Descent Rate (m/s)','FontSize',24,'FontWeight','Bold');
        xlim([0 5]); xticks(1:1:4);
        ylim([0 4]);
        set(gca,'XTickLabel',{'Fall','Winter','Spring','Summer'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_descent_season.png','Resolution',300);

[~,~,tmp] = kruskalwallis(B.dives.max_descent,B.dives.season);
figure; c = multcompare(tmp);
stats.dive.season.p_descentrate = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Median Day Depth (m)

figure('Position',[476 516 787 350]);

for i = 1:4
    b = boxchart(i*ones(sum(SSM.Season == i),1),SSM.median_Depth_day(SSM.Season == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    if i == 4
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Season','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Median Day Depth (m)','FontSize',24,'FontWeight','Bold');
        xlim([0 5]); xticks(1:1:4);
        ylim([0 180]);
        set(gca,'XTickLabel',{'Fall','Winter','Spring','Summer'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_meddayD_season.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.median_Depth_day,SSM.Season);
figure; c = multcompare(tmp);
stats.dive.season.p_medDaydepth = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Median Night Depth (m)

figure('Position',[476 516 787 350]);

for i = 1:4
    b = boxchart(i*ones(sum(SSM.Season == i),1),SSM.median_Depth_night(SSM.Season == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    if i == 4
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Season','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Median Night Depth (m)','FontSize',24,'FontWeight','Bold');
        xlim([0 5]); xticks(1:1:4);
        ylim([0 100]);
        set(gca,'XTickLabel',{'Fall','Winter','Spring','Summer'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_mednightD_season.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.median_Depth_night,SSM.Season);
figure; c = multcompare(tmp);
stats.dive.season.p_medNightdepth = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Daily Maximum Depth (m)

figure('Position',[476 516 787 350]);

for i = 1:4
    b = boxchart(i*ones(sum(SSM.Season == i),1),SSM.max_Depth(SSM.Season == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    if i == 4
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Season','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Daily Max Depth (m)','FontSize',24,'FontWeight','Bold');
        xlim([0 5]); xticks(1:1:4);
        ylim([0 700]);
        set(gca,'XTickLabel',{'Fall','Winter','Spring','Summer'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_maxD_season.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.max_Depth,SSM.Season);
figure; c = multcompare(tmp);
stats.dive.season.p_dailymaxdepth = c(:,[1:2 6]);

close all
clear b
clear ylab

%% % Time in Mesopelagic

figure('Position',[476 516 787 350]);

for i = 1:4
    b = boxchart(i*ones(sum(SSM.Season == i),1),SSM.TimeinMeso(SSM.Season == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    if i == 4
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Season','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('% Time in Mesopelagic','FontSize',24,'FontWeight','Bold');
        xlim([0 5]); xticks(1:1:4);
        ylim([0 18]);
        set(gca,'XTickLabel',{'Fall','Winter','Spring','Summer'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_meso_season.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.TimeinMeso,SSM.Season);
figure; c = multcompare(tmp);
stats.dive.season.p_timeinmeso = c(:,[1:2 6]);

close all
clear b
clear ylab