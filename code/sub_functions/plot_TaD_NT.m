%% plot_TaD_NT.m
% Sub-function of Norway_Tuna.m; plots time at depth during the day and at 
% night from recovered PSAT tags in each hotspot.

%% Create list of TOPP IDs.

toppID = unique(PSAT.TOPPID);

%% Define bins.

bins.Depth = [0 5 10 50:50:200 1200];

%% Loop through hotspots.

for i = 1:length(fieldnames(regions))+1

    %% Loop through day and night.

    for j = 1:2

        %% Loop through tags.

        for k = 1:length(toppID)

            %% Bin data.
    
            [binned.N(k,:),~,binned.binD] = histcounts(...
                PSAT.Depth(PSAT.Region == i & PSAT.DayNight == j-1 & PSAT.TOPPID == toppID(k)),...
                bins.Depth);
            binned.N(binned.N == 0) = NaN;
    
            N(k) = sum(PSAT.Region == i & PSAT.DayNight == j-1 & PSAT.TOPPID == toppID(k));

        end

        %% Mean and standard deviation of bins.

        binned.mean = mean(binned.N./N.'.*100,'omitnan');
        binned.std = std(binned.N./N.'.*100,'omitnan');

        %% Plot data.

        if j == 1
            figure('Position',[476 568 283 298]);

            b = barh(binned.mean.*-1,'histc');
            b.EdgeColor = 'k';
            b.FaceColor = [0.6 0.6 0.6];
            b.LineWidth = 1;

            hold on

            er = errorbar(binned.mean.*-1,1.5:1:7.5,binned.std,[],'horizontal');
            er.Color = [0 0 0];                            
            er.LineStyle = 'none';
            er.LineWidth = 1;

        elseif j == 2
            b = barh(binned.mean,'histc');
            b.EdgeColor = 'k';
            b.LineWidth = 1;
            b.FaceColor = 'w';

            hold on

            er = errorbar(binned.mean,1.5:1:7.5,[],binned.std,'horizontal');
            er.Color = [0 0 0];                            
            er.LineStyle = 'none'; 
            er.LineWidth = 1;

            set(gca,'ydir','reverse','FontSize',16,'linewidth',2,'tickdir','out');
            xlabel('Mean % Time at Depth','FontSize',20); ylabel('Depth (m)','FontSize',20);
            xlim([-100 100]); set(gca,'XTick',-100:50:100);
            set(gca,'XTickLabels',{'100';'50';'0';'50';'100'});
            set(gca,'YTick',1.5:1:7.5);
            set(gca,'YTickLabels',{'0-5'; '5-10'; '10-50'; '50-100'; '100-150'; '150-200'; '>200'});
        end

        clear binned
        clear N
        clear b
        clear er

    end

    %% Save figure.

    if i == 1
        rg = 'NwS';
    elseif i == 2
        rg = 'NoS';
    elseif i == 3
        rg = 'CoI';
    elseif i == 4
        rg = 'NB';
    elseif i == 5
        rg = 'CaI';
    elseif i == 6
        rg = 'Med';
    elseif i == 7
        rg = 'WEB';
    elseif i == 8
        rg = 'BoB';
    elseif i == 9
        rg = 'Out';
    end

    cd([fdir '/figures/TaD']);
    exportgraphics(gcf,[rg '.png'],'Resolution',300);

    close gcf

    %% Clear

    clear rg

end
clear i j k
clear bins
clear toppID

