%% detect_dives_NT.m
% Sub-function of Norway_Tuna; detects dives based on return excursions
% through a threshold defined as the median depth of all tags.

%% Create list of unique toppIDs.

toppID = unique(PSAT.TOPPID);

%% Apply median filter with 25-minute window to smooth data.

for i = 1:length(toppID)
    PSAT.DepthSmooth(PSAT.TOPPID == toppID(i)) = smoothdata(PSAT.Depth(PSAT.TOPPID == toppID(i)),'movmedian',15); % median filter with window length of 25 minutes
end

%% Calculate depth threshold.

T = median(roundn(PSAT.DepthSmooth(PSAT.DepthSmooth <= 20),0)); % m
% T = mode(roundn(PSAT.DepthSmooth,0)); % m

%% Generate indices of start and end of dives.
% Compute max, min, mean and median depth (m). Compute dive duration
% (hours) and inter-dive-interval (hours). Compute maximum descent and
% ascent rate (m/s)

for i = 1:length(toppID)
    tmp.smoothdepth = PSAT.DepthSmooth(PSAT.TOPPID == toppID(i));
    tmp.depth = PSAT.Depth(PSAT.TOPPID == toppID(i));
    tmp.time = PSAT.DateTime(PSAT.TOPPID == toppID(i));

    ind = PSAT.DepthSmooth(PSAT.TOPPID == toppID(i)) >= T; % is the depth above or below the threshold?
    ind = ischange(double(ind)); % determine where there is a change from 0 to 1 and 1 to 0
    ind = find(ind);

    ind = ind(tmp.depth(ind) < 5);

    tbl = table([[1; ind], [ind; length(PSAT.DepthSmooth(PSAT.TOPPID == toppID(i)))]],'VariableNames',{'index'}); % start and end index of each potential dive
    clear ind

    for j = 1:length(tbl.index)
        tmp.dive_depth(j,:) = [max(tmp.smoothdepth(tbl.index(j,1):tbl.index(j,2))); min(tmp.smoothdepth(tbl.index(j,1):tbl.index(j,2)))];
        tmp.depthrange = tmp.dive_depth(:,1) - tmp.dive_depth(:,2);
    end
    clear j

    ind = tmp.depthrange >= 5;
    tbl = tbl(ind,:);
    clear ind

    tbl.start_time = tmp.time(tbl.index(:,1));
    tbl.end_time = tmp.time(tbl.index(:,2));
    tbl.duration = hours(tbl.end_time - tbl.start_time);
    tbl.IDI = [hours(tbl.start_time(2:end) - tbl.end_time(1:end-1)); NaN];

    tbl.month = month(tbl.start_time);
    tbl.day = datetime(year(tbl.start_time),month(tbl.start_time),day(tbl.start_time));
    tbl.hour = datetime(year(tbl.start_time),month(tbl.start_time),day(tbl.start_time),hour(tbl.start_time),0,0);

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

    if ~exist('dives','var')
        dives = tbl;
    else
        dives = [dives; tbl];
    end

    clear tbl
end
clear i

clear T

%% Compute dive frequency per day and per hour.

