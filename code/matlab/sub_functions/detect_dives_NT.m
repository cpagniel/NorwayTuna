%% detect_dives_NT.m
% Sub-function of Norway_Tuna; detects dives based on return excursions
% through a threshold defined as the median depth of all tags.

%% Create list of unique toppIDs.

toppID = unique(PSAT.TOPPID);

%% Apply median filter with 1 minute and 15 second window to smooth data.

for i = 1:length(toppID)
    PSAT.DepthSmooth(PSAT.TOPPID == toppID(i)) = smoothdata(PSAT.Depth(PSAT.TOPPID == toppID(i)),'movmedian',15); 
end

%% Calculate depth threshold.

disp('Depth Threshold')

for i = 1:length(toppID)

    disp(i)

    tmp.smoothdepth = PSAT.DepthSmooth(PSAT.TOPPID == toppID(i));
    tmp.time = PSAT.DateTime(PSAT.TOPPID == toppID(i));

    s_dt = datetime(year(tmp.time(1)),month(tmp.time(1)),day(tmp.time(1)),hour(tmp.time(1)),0,0);
    e_dt = datetime(year(tmp.time(end)),month(tmp.time(end)),day(tmp.time(end)),hour(tmp.time(end))+1,0,0);
    dt = s_dt:hours(18):e_dt;
    if max(dt) < e_dt
        dt = [dt, dt(end) + hours(18)];
    end

    tmp.T = [];
    for j = 1:length(dt)-1
        tmp.T  = [tmp.T; median(roundn(tmp.smoothdepth(tmp.smoothdepth <= 10 & tmp.time > dt(j) & tmp.time <= dt(j+1)),0))*ones(sum(tmp.time > dt(j) & tmp.time <= dt(j+1)),1)]; % m
    end
    tmp.T = fillmissing(tmp.T,'previous');
    B.T{i} = tmp.T;
    clear j
end
clear i
clear *dt

%% Generate indices of start and end of dives.
% Compute max, min, mean and median depth (m). Compute dive duration
% (hours) and inter-dive-interval (hours). Compute maximum descent and
% ascent rate (m/s).

disp('Generate indices')

for i = 1:length(toppID)

    disp(i)
    
    tmp.smoothdepth = PSAT.DepthSmooth(PSAT.TOPPID == toppID(i));
    tmp.depth = PSAT.Depth(PSAT.TOPPID == toppID(i));
    tmp.time = PSAT.DateTime(PSAT.TOPPID == toppID(i));

    ind = PSAT.DepthSmooth(PSAT.TOPPID == toppID(i)) >= B.T{i}; % is the depth above or below the threshold?
    ind = ischange(double(ind)); % determine where there is a change from 0 to 1 and 1 to 0
    ind = find(ind);

    tbl = table([[1; ind-1], [ind; length(PSAT.DepthSmooth(PSAT.TOPPID == toppID(i)))]],'VariableNames',{'index'}); % start and end index of each potential dive
    clear ind

    for j = 1:length(tbl.index)
        tmp.dive_depth(j,:) = [max(tmp.smoothdepth(tbl.index(j,1):tbl.index(j,2))); min(tmp.smoothdepth(tbl.index(j,1):tbl.index(j,2)))];
        tmp.depthrange = tmp.dive_depth(:,1) - tmp.dive_depth(:,2);
    end
    clear j

    ind = tmp.depthrange >= 10; % must span at least 10 m
    tbl = tbl(ind,:);
    clear ind

    tbl.start_time = tmp.time(tbl.index(:,1));
    tbl.end_time = tmp.time(tbl.index(:,2));
    tbl.duration = hours(tbl.end_time - tbl.start_time);
    tbl.IDI = [hours(tbl.start_time(2:end) - tbl.end_time(1:end-1)); NaN];

    tbl.month = month(tbl.start_time);
    tbl.day = datetime(year(tbl.start_time),month(tbl.start_time),day(tbl.start_time));
    tbl.hour = hour(tbl.start_time);

    tbl.start_depth = tmp.depth(tbl.index(:,1));
    tbl.end_depth = tmp.depth(tbl.index(:,2));

    for j = 1:length(tbl.index)
        [tbl.max_depth(j), ind] = max(tmp.depth(tbl.index(j,1):tbl.index(j,2)));
        tbl.min_depth(j) = min(tmp.depth(tbl.index(j,1):tbl.index(j,2)));
        tbl.mean_depth(j) = mean(tmp.depth(tbl.index(j,1):tbl.index(j,2)));
        tbl.median_depth(j) = median(tmp.depth(tbl.index(j,1):tbl.index(j,2)));
        tbl.var_depth(j) = var(tmp.depth(tbl.index(j,1):tbl.index(j,2)));

        sub.time = tmp.time(tbl.index(j,1):tbl.index(j,2));
        sub.depth = tmp.depth(tbl.index(j,1):tbl.index(j,2));
        if ind ~= 1 && ind ~= length(sub.time) % as long as maximum depth is not the first point in the dive or last point in the timeseries
            tbl.max_descent(j) = max((diff(sub.depth(1:ind)))./(seconds(diff(sub.time(1:ind)))));
            t = abs((diff(sub.depth(ind:end)))./(seconds(diff(sub.time(ind:end)))));
            tbl.max_ascent(j) = max(t(t > 0));
        else
            tbl.max_descent(j) = NaN;
            tbl.max_ascent(j) = NaN;
        end

        clear sub
        clear t
    end
    clear j
    clear ind
    clear tmp

    tbl.toppID = toppID(i)*ones(height(tbl),1);
    tbl = movevars(tbl,'toppID','Before','index');

    tbl.hotspot = NaN(height(tbl),1);
    tbl.season = NaN(height(tbl),1);
    for j = 1:height(SSM)

        ind_time = find(SSM.Date(j) == tbl.day);
        ind_topp = find(SSM.TOPPID(j) == tbl.toppID);

        ind = intersect(ind_time,ind_topp);

        tbl.hotspot(ind) = SSM.Region(j);
        tbl.season(ind) = SSM.Season(j);
    end
    clear j
    clear ind*

    tbl(isnan(tbl.hotspot),:) = [];

    tbl.lat = NaN(height(tbl),1);
    tbl.lon = NaN(height(tbl),1);

    tbl.lon = interp1(datenum(SSM.Date(SSM.TOPPID == toppID(i))),...
        SSM.Longitude(SSM.TOPPID == toppID(i)),datenum(tbl.start_time));

    tbl.lat = interp1(datenum(SSM.Date(SSM.TOPPID ==  toppID(i))),...
        SSM.Latitude(SSM.TOPPID ==  toppID(i)),datenum(tbl.start_time));

    if ~exist('dives','var')
        dives = tbl;
    else
        dives = [dives; tbl];
    end

    clear tbl
end
clear i

B.dives = dives;
clear dives

PSAT = movevars(PSAT, 'DepthSmooth', 'Before', 'LightLevel');

%% Find sunrise and sunset time to determine if observation is day or night.

[SRISE,SSET] = sunrise(B.dives.lat,B.dives.lon,0,0,B.dives.start_time);
B.dives.DayNight = zeros(height(B.dives),1);
B.dives.DayNight(B.dives.start_time > datetime(SRISE,'ConvertFrom','datenum') & B.dives.start_time < datetime(SSET,'ConvertFrom','datenum')) = 1;

clear SRISE
clear SSET