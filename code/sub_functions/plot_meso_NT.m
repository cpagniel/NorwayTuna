%% plot_meso_NT.m
% Sub-function of Norway_Tuna.m; plots time in mesopelagic from recovered
% PSAT tags in each hotspot.

%% Create list of TOPP IDs.

toppID = unique(PSAT.TOPPID);

%% Define bins.

bins.Depth = [200 1200];

%% Loop through hotspots.

for i = 1:length(fieldnames(regions))+1

    %% Loop through tags.

    for j = 1:length(toppID)

        %% Bin data.

        [binned.N(i,j),~,binned.binD] = histcounts(...
            PSAT.Depth(PSAT.Region == i & PSAT.TOPPID == toppID(j)),...
            bins.Depth);

        binned.cnt(i,j) = sum(PSAT.Region == i & PSAT.TOPPID == toppID(j));

    end

end
clear i j
clear bins

%% Mean and standard deviation of percent time in bin.

binned.mean = mean(binned.N./binned.cnt.*100,2,'omitnan');
binned.std = std(binned.N./binned.cnt.*100,[],2,'omitnan');

%% Plot data.

figure;

b = bar(binned.mean);
b.FaceColor = 'flat';
b.CData = cmap.regions;

hold on

er = errorbar(1:1:9,binned.mean,[],binned.std);
er.Color = [0 0 0];
er.LineStyle = 'none';

set(gca,'FontSize',20);
xlabel('Hotspot','FontSize',24); ylabel('Mean % Time in Mesopelagic','FontSize',24);
set(gca,'XTickLabels',["NwS" "NoS" "CoI" "NB" "CaI" "Med" "WEB" "BoB" "Outside"]);

clear binned
clear N
clear b
clear er

%% Save figure.

cd([fdir '/figures']);
exportgraphics(gcf,'mean_prct_time_in_mesopelagic.png','Resolution',300);

close gcf

%% Clear

clear toppID