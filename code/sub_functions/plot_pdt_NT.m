%% plot_pdt_NT.m
% Sub-function of Norway_Tuna.m; plots PDTs by hotspots and season.

%% Define bins.

bins.Temp = 0:0.5:28;
bins.Depth = 0:2:1200;

%% Loop through hotspots.

for i = 1:length(fieldnames(regions))+1

    %% Loop through seasons.

    for j = 1:length(unique(PSAT.Season))

        %% Bin data.

        [binned.N,~,~,binned.binT,binned.binD] = histcounts2(...
            PSAT.Temperature(PSAT.Region == i & PSAT.Season == j),...
            PSAT.Depth(PSAT.Region == i & PSAT.Season == j),...
            bins.Temp,bins.Depth);
        binned.N(binned.N == 0) = NaN;

        N = sum(PSAT.Region == i & PSAT.Season == j);

        %% Plot data.

        figure('Position',[476 446 283 420]);

        imagescn(bins.Temp,bins.Depth,log(binned.N).');
        shading flat;

        set(gca,'ydir','reverse','FontSize',18,'linewidth',2);
        xlabel('Temperature (^oC)','FontSize',20); ylabel('Depth (m)','FontSize',20);
        xlim([bins.Temp(1) bins.Temp(end)]); ylim([bins.Depth(1) 1300]);

        colormap(turbo);
        caxis([0 13.5]);

        text(1.5,1225,['n = ' num2str(N)],'FontSize',20,'FontWeight','bold');

        % h = colorbar('eastoutside'); 
        % ylabel(h,'ln(Frequency of Occurence)','FontSize',14);

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

        if j == 1
            ss = 'Fall';
        elseif j == 2
            ss = 'Winter';
        elseif j == 3
            ss = 'Spring';
        elseif j == 4
            ss = 'Summer';
        end

        cd([fdir '/figures/pdts']);
        exportgraphics(gcf,[rg '_' ss '.png'],'Resolution',300);
        % exportgraphics(gcf,'legend.png','Resolution',300);

        close gcf

        %% Clear

        clear N
        clear ss rg
        clear binned

    end
end
clear i j
clear tmp
clear bins
clear h
