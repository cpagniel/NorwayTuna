%% plot_daylength_hotspot_NT.m
% Sub-function of Norway_Tuna.m; plot boxplot showing day length in each hotspot.

figure('Position',[476 516 787 350]);

cnt = 1;
for i = [1:5 0]
    b = boxchart(cnt*ones(sum(SSM.Region == i),1),SSM.DayLength(SSM.Region == i),"Notch","on");
    b.BoxFaceColor = 'k';
    b.WhiskerLineColor = 'k';
    b.MarkerColor = 'k';
    b.MarkerStyle = '*';

    hold on

    cnt = cnt + 1;

    if i == 5
        box on
        set(gca,'FontSize',18,'LineWidth',1);
        xlabel('Hotspot','FontSize',24,'FontWeight','Bold');
        ylab = ylabel('Day Length (hours)','FontSize',24,'FontWeight','Bold');
        xlim([0 7]); xticks(1:1:6);
        set(gca,'XTickLabel',{'NOR','NB','CI','Med','WEB','Migratory'});
    end
end
clear i
clear cnt
ylab.Position(1) = -0.45;

cd([fdir '/figures']);
exportgraphics(gcf,'boxplot_daylength_hotspot.png','Resolution',300);

[~,~,tmp] = kruskalwallis(SSM.DayLength,SSM.Region);
figure; c = multcompare(tmp);
stats.p_daylength = c(:,[1:2 6]);

close all
clear c
clear b
clear tmp
clear ylab