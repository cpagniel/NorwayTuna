%% classify_ocean_provinces_NT.m
% Sub-function of Norway_Tuna; uses daily temperature-depth profiles to
% identify oceanographic provinces. Profiles compared using dynamic time
% warping.

%% List of toppIDs

toppID = unique(PSAT.TOPPID);

%% Create matrices of temperature and depth.

for i = 1:length(toppID)
    maxEl = max(arrayfun(@(x) numel(cell2mat(x)),pfl(i).Temperature)); % Maximum Number of Points

    plt(i).Temperature = cell2mat(arrayfun(@(x) ...
        [cell2mat(x); NaN(maxEl-numel(cell2mat(x)),1)],[pfl(i).Temperature],...
        'uni',0));

    plt(i).Depth = cell2mat(arrayfun(@(x) ...
        [cell2mat(x); NaN(maxEl-numel(cell2mat(x)),1)],[pfl(i).Depth],...
        'uni',0));

    clear maxEl
end

temp = [];
depth = [];
for i = 1:length(toppID)
    l1 = size(temp,1);
    l2 = size(plt(i).Temperature,1);
    
    if i == 1
        temp = [temp, plt(i).Temperature];
        depth = [depth, plt(i).Depth];
    elseif l1 > l2
        temp = [temp, [plt(i).Temperature; NaN(l1 - l2,size(plt(i).Temperature,2))]];
        depth = [depth, [plt(i).Depth; NaN(l1 - l2,size(plt(i).Depth,2))]];
    elseif l1 < l2
        temp = [[temp; NaN(l2 - l1,size(temp,2))], plt(i).Temperature];
        depth = [[depth; NaN(l2 - l1,size(depth,2))], plt(i).Depth];
    end
end
clear i
clear l1 l2

lon = [];
lat = [];
dt = [];
id = [];
for i = 1:length(toppID)
    lon = [lon; SSM.Longitude(SSM.TOPPID == toppID(i))];
    lat = [lat; SSM.Latitude(SSM.TOPPID == toppID(i))];
    dt = [dt; SSM.Date(SSM.TOPPID == toppID(i))];
    id = [id; toppID(i)*ones(sum(SSM.TOPPID == toppID(i)),1)];
end
clear i

%% Prepare data for DTW.

% Only keep depths where at least 90% of profiles have measurements.
tmp = temp(sum(isnan(temp),2)./size(temp,2) < 0.90,:);

% % Standardize each profile.
% for j = 1:size(tmp,2)
%     tmp(1:sum(~isnan(tmp(:,j))),j) = zscore(tmp(~isnan(tmp(:,j)),j));
% end

% Weight less at surface.
% tmp = tmp.*flipud(sum(~isnan(tmp),2)./size(tmp,2));

% Sort by Day and Month - make all years 2020.
[~,ind] = sort(datetime(2020,month(dt),day(dt)));
tmp = tmp(:,ind);

%% Calculate distance between profiles using dynamic time warping.
% Adjust DTW. Why are things of really different shape clustering together?
% Try adjusting maxsamp parameter.

tic
dist = NaN(size(tmp,2),size(tmp,2));
K = size(tmp,2);

parfor j = 1:size(tmp,2)
    for k = 1:K
        dist(j,k) = dtw(tmp(~isnan(tmp(:,j)),j),tmp(~isnan(tmp(:,k)),k));
    end
end
clear j
toc

%% Classificaiton

Y = linkage(dist,'ward');
evaluation = evalclusters(dist,"linkage","gap","KList",1:15);
% dendrogram(Y)

%% Plot

cnt = 12;

idx = cluster(Y,'MaxClust',cnt);

t_lon = lon(ind);
t_lat = lat(ind);

figure;
LATLIMS = [15 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_gshhs_i('patch',[.7 .7 .7]);
hold on
m_line([-45 -45],[15 70],'linewi',2,'color','k','linestyle','--')

cmap = jet(cnt);
for i = 1:cnt
    m_plot(t_lon(idx == i),t_lat(idx == i),'ko','MarkerFaceColor',cmap(i,:));
    hold on
end

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);
m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

figure;
cmap = jet(cnt);
for i = 1:cnt
    subplot(4,3,i)

    LATLIMS = [15 70]; LONLIMS = [-80 40];
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_gshhs_i('patch',[.7 .7 .7]);
    hold on
    m_line([-45 -45],[15 70],'linewi',2,'color','k','linestyle','--')

    m_plot(t_lon(idx == i),t_lat(idx == i),'ko','MarkerFaceColor',cmap(i,:));
    xlim([-50 20]);
    ylim([20 65])

    m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);
    m_northarrow(-75,65,4,'type',2,'linewi',2);
    m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

end

t_temp = temp(:,ind);
t_depth = depth(:,ind);

figure;
for i = 1:cnt
    plot(t_temp(:,idx == i),t_depth(:, idx == i),'-','Color',cmap(i,:));
    hold on
    set(gca,'ydir','reverse')
    xlabel('Temperature (^oC)');
    ylabel('Depth (m)')
    axis square
    grid on
    grid minor
end

figure;
for i = 1:cnt
    subplot(4,3,i)
    plot(t_temp(:,idx == i),t_depth(:, idx == i),'-','Color',cmap(i,:));
    set(gca,'ydir','reverse')
    ylim([0 1200])
    xlim([0 30])
    xlabel('Temperature (^oC)');
    ylabel('Depth (m)')
        axis square
    grid on
    grid minor
end