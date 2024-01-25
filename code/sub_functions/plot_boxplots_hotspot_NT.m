%% plot_boxplots_hotspots_NT %%
% Sub-function of Norway_Tuna.m; plots boxplots of vertical diving behavior
% by hotspots.

%% Speed (m/s)

B.speed.Region = zeros(height(B.speed.TOPPID),1);
B.speed.Region(inpolygon(B.speed.Longitude,B.speed.Latitude,regions.Nordic(1,:),regions.Nordic(2,:))) = 1;
B.speed.Region(inpolygon(B.speed.Longitude,B.speed.Latitude,regions.NB(1,:),regions.NB(2,:))) = 2;
B.speed.Region(inpolygon(B.speed.Longitude,B.speed.Latitude,regions.CI(1,:),regions.CI(2,:))) = 3;
B.speed.Region(inpolygon(B.speed.Longitude,B.speed.Latitude,regions.Med(1,:),regions.Med(2,:))) = 4;
B.speed.Region(inpolygon(B.speed.Longitude,B.speed.Latitude,regions.WEB(1,:),regions.WEB(2,:))) = 5;

figure('Position',[476 516 787 350]);

cnt = 1;
for i = [1:5 0]
    b = boxchart(cnt*ones(sum(B.speed.Region == i),1),B.speed.Speed_m_per_s(B.speed.Region == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    cnt = cnt + 1;

    if i == 5
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Hotspot','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Speed (m/s)','FontSize',24,'FontWeight','Bold');
        xlim([0 7]); xticks(1:1:6);
        ylim([0 2.5]);
        set(gca,'XTickLabel',{'NOR','NB','CI','Med','WEB','Migratory'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_speed_hotspot.png','Resolution',300);

[~,~,tmp] = kruskalwallis(B.speed.Speed_m_per_s,B.speed.Region);
figure; c = multcompare(tmp);
stats.dive.hotspot.p_speed = c(:,[1:2 6]);

close all
clear b
clear tmp
clear ylab

%% Dive Frequency (no./day)

figure('Position',[476 516 787 350]);

cnt = 1;
for i = [1:5 0]
    b = boxchart(cnt*ones(sum(SSM.Region == i),1),SSM.DivesPerDay(SSM.Region == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    cnt = cnt + 1;

    if i == 5
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Hotspot','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Dive Frequency (no./day)','FontSize',24,'FontWeight','Bold');
        xlim([0 7]); xticks(1:1:6);
        ylim([0 80]);
        set(gca,'XTickLabel',{'NOR','NB','CI','Med','WEB','Migratory'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_diveF_hotspot.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.DivesPerDay,SSM.Region);
figure; c = multcompare(tmp);
stats.dive.hotspot.p_diveF = c(:,[1:2 6]);

close all
clear b
clear tmp
clear ylab

%% Duration (hours)

figure('Position',[476 516 787 350]);

cnt = 1;
for i = [1:5 0]
    b = boxchart(cnt*ones(sum(B.dives.hotspot == i),1),B.dives.duration(B.dives.hotspot == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    cnt = cnt + 1;

    if i == 5
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Hotspot','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Duration (hours)','FontSize',24,'FontWeight','Bold');
        xlim([0 7]); xticks(1:1:6);
        ylim([0 2]);
        set(gca,'XTickLabel',{'NOR','NB','CI','Med','WEB','Migratory'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_duration_hotspot.png','Resolution',300);

[~,~,tmp] = kruskalwallis(B.dives.duration,B.dives.hotspot);
figure; c = multcompare(tmp);
stats.dive.hotspot.p_duration = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Descent Rate (m/s)

figure('Position',[476 516 787 350]);

cnt = 1;
for i = [1:5 0]
    b = boxchart(cnt*ones(sum(B.dives.hotspot == i),1),B.dives.max_descent(B.dives.hotspot == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    cnt = cnt + 1;

    if i == 5
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Hotspot','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Descent Rate (m/s)','FontSize',24,'FontWeight','Bold');
        xlim([0 7]); xticks(1:1:6);
        ylim([0 5]);
        set(gca,'XTickLabel',{'NOR','NB','CI','Med','WEB','Migratory'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_descent_hotspot.png','Resolution',300);

[~,~,tmp] = kruskalwallis(B.dives.max_descent,B.dives.hotspot);
figure; c = multcompare(tmp);
stats.dive.hotspot.p_descentrate = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Median Day Depth (m)

figure('Position',[476 516 787 350]);

cnt = 1;
for i = [1:5 0]
    b = boxchart(cnt*ones(sum(SSM.Region == i),1),SSM.median_Depth_day(SSM.Region == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    cnt = cnt + 1;

    if i == 5
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Hotspot','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Median Day Depth (m)','FontSize',24,'FontWeight','Bold');
        xlim([0 7]); xticks(1:1:6);
        ylim([0 250]);
        set(gca,'XTickLabel',{'NOR','NB','CI','Med','WEB','Migratory'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_meddayD_hotspot.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.median_Depth_day,SSM.Region);
figure; c = multcompare(tmp);
stats.dive.hotspot.p_medDaydepth = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Median Night Depth (m)

figure('Position',[476 516 787 350]);

cnt = 1;
for i = [1:5 0]
    b = boxchart(cnt*ones(sum(SSM.Region == i),1),SSM.median_Depth_night(SSM.Region == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    cnt = cnt + 1;

    if i == 5
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Hotspot','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Median Night Depth (m)','FontSize',24,'FontWeight','Bold');
        xlim([0 7]); xticks(1:1:6);
        ylim([0 120]);
        set(gca,'XTickLabel',{'NOR','NB','CI','Med','WEB','Migratory'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_mednightD_hotspot.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.median_Depth_night,SSM.Region);
figure; c = multcompare(tmp);
stats.dive.hotspot.p_medNightdepth = c(:,[1:2 6]);

close all
clear b
clear ylab

%% Daily Maximum Depth (m)

figure('Position',[476 516 787 350]);

cnt = 1;
for i = [1:5 0]
    b = boxchart(cnt*ones(sum(SSM.Region == i),1),SSM.max_Depth(SSM.Region == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    cnt = cnt + 1;

    if i == 5
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Hotspot','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Daily Max Depth (m)','FontSize',24,'FontWeight','Bold');
        xlim([0 7]); xticks(1:1:6);
        ylim([0 700]);
        set(gca,'XTickLabel',{'NOR','NB','CI','Med','WEB','Migratory'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_maxD_hotspot.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.max_Depth,SSM.Region);
figure; c = multcompare(tmp);
stats.dive.hotspot.p_dailymaxdepth = c(:,[1:2 6]);

close all
clear b
clear ylab

%% % Time in Mesopelagic

figure('Position',[476 516 787 350]);

cnt = 1;
for i = [1:5 0]
    b = boxchart(cnt*ones(sum(SSM.Region == i),1),SSM.TimeinMeso(SSM.Region == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = 'none';

    hold on

    cnt = cnt + 1;

    if i == 5
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Hotspot','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('% Time in Mesopelagic','FontSize',24,'FontWeight','Bold');
        xlim([0 7]); xticks(1:1:6);
        ylim([0 25]);
        set(gca,'XTickLabel',{'NOR','NB','CI','Med','WEB','Migratory'});
    end
end
clear i
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_meso_hotspot.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.TimeinMeso,SSM.Region);
figure; c = multcompare(tmp);
stats.dive.hotspot.p_timeinmeso = c(:,[1:2 6]);

close all
clear b
clear ylab