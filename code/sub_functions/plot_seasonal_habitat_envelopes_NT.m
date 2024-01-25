%% plot_seasonal_habitat_envelopes_NT.m
% Sub-function of Norway_Tuna.m; plots habitat envelopes in 5 regions
% during each season.

% Seasons
% 1 = Fall which includes September, October and November.
% 2 = Winter which includes December, January and February.
% 3 = Spring which includes March, April and May.
% 4 = Summer which includes June, July and August.

% Hotspots
% 0 = Migratory Pathways
% 1 = Norwegian EEZ (formely Nordic Waters)
% 2 = Newfoundland Basin
% 3 = Canary Islands
% 4 = Mediterranean Sea
% 5 = West European Basin

%% Plot habitat envelopes by region and season.

cnt = 0;
for i = 1:length(fieldnames(regions))+1
    for j = 1:length(unique(PSAT.Season))

        binned.Temp = 0:0.5:30; % 0.5 deg C bins
        binned.Depth = 0:2:1200; % 2 m bins

        [binned.N,binned.Temp,binned.Depth,binned.binT,binned.binD] = ...
            histcounts2(PSAT.Temperature(PSAT.Region == i-1 & PSAT.Season == j),...
            PSAT.Depth(PSAT.Region == i-1 & PSAT.Season == j),...
            binned.Temp, binned.Depth);
        binned.N(binned.N == 0) = NaN;

        figure('Position',[476 446 283 420]);

        imagescn(binned.Temp,binned.Depth,log(binned.N).');

        shading flat

        set(gca,'ydir','reverse','FontSize',22,'linewidth',2);
        xlabel('Temperature (^oC)','FontSize',26); ylabel('Depth (m)','FontSize',26);

        xlim([binned.Temp(1) binned.Temp(end)]);
        ylim([binned.Depth(1) binned.Depth(end)]);

        colormap(turbo);
        caxis([0 12]);

        cnt = cnt + 1;
        cd([fdir '/figures']);
        exportgraphics(gcf,['habitat_envelope_' num2str(cnt) '.png'],'Resolution',300);

        clear N
        clear binned
        
        if i == 6 && j == 4
            h = colorbar('eastoutside'); ylabel(h,'ln(Frequency of Occurence)','FontSize',14);
            exportgraphics(gcf,'habitat_envelope_legend.png','Resolution',300);
        end

        close gcf

    end
end
clear i
clear j
clear tmp
clear cnt
clear h
