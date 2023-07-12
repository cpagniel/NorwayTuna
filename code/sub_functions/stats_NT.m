%% stats_NT.m
% Sub-function of Norway_Tuna.m; computes statistics on time in hotspots.

%% Number of Days in Each Hotspot

tmp = groupcounts(SSM,["TOPPID" "Region"],"IncludeEmptyGroups",true);
tmp = reshape(tmp.GroupCount,[length(fieldnames(regions))+1 length(unique(SSM.TOPPID))]);
tmp = tmp.';
stats.daysperhotspot = array2table(tmp);
stats.daysperhotspot.Properties.VariableNames = ["NwS" "NoS" "CoI" "NB" "CaI" "Med" "WEB" "BoB" "Outside"];

stats.daysperhotspot.TOPPID = unique(SSM.TOPPID);

stats.daysperhotspot.Total = sum(tmp,2);

%% Plot Mean Number of Days in Each Hotspot with Standard Deviation

figure;

X = categorical(["NwS" "NoS" "CoI" "NB" "CaI" "Med" "WEB" "BoB" "Outside"]);
X = reordercats(X,cellstr(X)');
Y = mean(stats.daysperhotspot{:,["NwS" "NoS" "CoI" "NB" "CaI" "Med" "WEB" "BoB" "Outside"]});
b = bar(X,Y);
b.FaceColor = 'flat';
b.CData = cmap.regions;

hold on

Z = std(stats.daysperhotspot{:,["NwS" "NoS" "CoI" "NB" "CaI" "Med" "WEB" "BoB" "Outside"]});
er = errorbar(X,Y,[],Z);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

set(gca,'FontSize',20);
xlabel('Hotspot','FontSize',24); ylabel('Mean Number of Days');

cd([fdir '/figures']);
exportgraphics(gcf,'mean_number_of_days_per_hotspot_with_std.png','Resolution',300);

close all

clear X Y Z
clear b er

%% Percentage of Total Number of Days in Each Hotspot

tmp = tmp./sum(tmp,2)*100;
stats.prctdaysperhotspot = array2table(tmp);
stats.prctdaysperhotspot.Properties.VariableNames = ["NwS" "NoS" "CoI" "NB" "CaI" "Med" "WEB" "BoB" "Outside"];

stats.prctdaysperhotspot.TOPPID = unique(SSM.TOPPID);

clear tmp

%% Plot Mean Percentage of Total Number of Days in Each Hotspot with Standard Deviation 

figure;

X = categorical(["NwS" "NoS" "CoI" "NB" "CaI" "Med" "WEB" "BoB" "Outside"]);
X = reordercats(X,cellstr(X)');
Y = mean(stats.prctdaysperhotspot{:,["NwS" "NoS" "CoI" "NB" "CaI" "Med" "WEB" "BoB" "Outside"]});
b = bar(X,Y);
b.FaceColor = 'flat';
b.CData = cmap.regions;

hold on

Z = std(stats.prctdaysperhotspot{:,["NwS" "NoS" "CoI" "NB" "CaI" "Med" "WEB" "BoB" "Outside"]});
er = errorbar(X,Y,[],Z);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

set(gca,'FontSize',20);
xlabel('Hotspot','FontSize',24); ylabel('Mean % of Total Number of Days');

cd([fdir '/figures']);
exportgraphics(gcf,'mean_percent_total_days_per_hotspot_with_std.png','Resolution',300);

close all

clear X Y Z
clear b er