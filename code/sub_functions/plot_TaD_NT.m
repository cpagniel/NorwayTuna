%% plot_TaD_NT.m
% Sub-function of Norway_Tuna.m; plots time at depth during the day and at
% night from recovered PSAT tags in each hotspot by season.

%% Create list of TOPP IDs.

toppID = unique(PSAT.TOPPID);

%% Define bins.

bins.Depth = [0 5 10 50:50:300 500 700 1000 1200];

%% Loop through hotspots.

for i = 1:length(fieldnames(regions))+1

    %% Loop through season.

    for j = 1:4

        %% Loop through day and night.

        for k = 1:2

            %% Loop through tags.

            for l = 1:length(toppID)

                %% Bin data.

                [binned.N(l,:),~,binned.binD] = histcounts(...
                    PSAT.Depth(PSAT.Region == i-1 & PSAT.Season == j & PSAT.DayNight == k-1 & PSAT.TOPPID == toppID(l)),...
                    bins.Depth);
                binned.N(binned.N == 0) = NaN;

                N(l) = sum(PSAT.Region == i-1 & PSAT.Season == j & PSAT.DayNight == k-1 & PSAT.TOPPID == toppID(l));

            end

            %% Mean and standard deviation of bins.

            binned.median = median(binned.N./N.'.*100,'omitnan');
            binned.mad = mad(binned.N./N.'.*100,1);

            %% Plot data.

            if k == 1
                figure('Position',[476 446 283 420]);

                b = barh(binned.median.*-1,'histc');
                b.EdgeColor = 'k';
                b.FaceColor = [0.6 0.6 0.6];
                b.LineWidth = 1;

                hold on

                er = errorbar(binned.median.*-1,1.5:1:12.5,binned.mad,[],'horizontal');
                er.Color = [0 0 0];
                er.LineStyle = 'none';
                er.LineWidth = 1;

            elseif k == 2
                b = barh(binned.median,'histc');
                b.EdgeColor = 'k';
                b.LineWidth = 1;
                b.FaceColor = 'w';

                hold on

                er = errorbar(binned.median,1.5:1:12.5,[],binned.mad,'horizontal');
                er.Color = [0 0 0];
                er.LineStyle = 'none';
                er.LineWidth = 1;

                set(gca,'ydir','reverse','FontSize',14,'linewidth',2,'tickdir','out');
                xlabel('Median % Time at Depth','FontSize',16); ylabel('Depth (m)','FontSize',16);
                xlim([-100 100]); set(gca,'XTick',-100:50:100);
                ylim([1 13]);
                set(gca,'XTickLabels',{'100';'50';'0';'50';'100'});
                set(gca,'YTick',1.5:1:12.5);
                set(gca,'YTickLabels',{'0-5'; '5-10'; '10-50'; '50-100'; '100-150'; '150-200'; '200-250'; ...
                    '250-300'; '300-500'; '500-700'; '700-1000'; '>1000'});
            end

            clear binned
            clear N
            clear b
            clear er

        end

        %% Save figure.

        if i == 1
            rg = 'Migratory';
        elseif i == 2
            rg = 'NOR';
        elseif i == 3
            rg = 'NB';
        elseif i == 4
            rg = 'Canaries';
        elseif i == 5
            rg = 'Med';
        elseif i == 6
            rg = 'WEB';
        end

        if j == 1
            se = 'Fall';
        elseif j == 2
            se = 'Winter';
        elseif j == 3
            se = 'Spring';
        elseif j == 4
            se = 'Summer';
        end

        cd([fdir '/figures/TaD']);
        exportgraphics(gcf,[rg '_' se '.png'],'Resolution',300);

        close gcf

        %% Clear

        clear se

    end

    %% Clear

    clear rg

end
clear i j k l
clear bins
clear toppID
