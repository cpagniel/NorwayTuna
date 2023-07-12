%% daily_TD_profiles_NT.m
% Sub-function of Norway_Tuna; creates daily temperature-depth profiles by
% (1) averaging data into 1-m bins, (2) vertically interpolating data onto
% a 1-m regular grid, (3) smoothed with a 10-m window.

%% Loop through each tag.

toppID = unique(PSAT.TOPPID);

pfl = struct();
for i = 1:length(toppID)

    disp(toppID(i));

    %% Create daily datetime vector.

    t = datetime(year(PSAT.DateTime(PSAT.TOPPID == toppID(i))),...
        month(PSAT.DateTime(PSAT.TOPPID == toppID(i))),...
        day(PSAT.DateTime(PSAT.TOPPID == toppID(i))));

    t = unique(t);

    %% Create 1-m bin averaged, interpolated, daily profiles.

    for j = 1:length(t)

        tmp = PSAT(PSAT.TOPPID == toppID(i) & PSAT.Date == t(j),:);

        % Average temperature data in 1-m bins.

        bins.d_bin = floor(min(tmp.Depth)):1:ceil(max(tmp.Depth))+1; % create 1-m bins between minimum and maximum depth
        bins.d_cat = discretize(tmp.Depth,bins.d_bin.'); % determine which bin each depth-temperature measurement was made in

        bins.t_avg = accumarray(bins.d_cat,tmp.Temperature,[],@mean); % take average of all temperatures in 1-m bin
        bins.t_binned = bins.t_avg(bins.t_avg ~= 0); bins.d_binned = bins.d_bin(bins.t_avg ~= 0); % remove empty bins between minimum and maximum depth

        % Interpolate onto a 1-m regular grid between 0 m and maximum
        % depth.

        interp.d = 0:1:max(bins.d_bin);
        interp.t = gsw_t_interp(bins.t_binned,bins.d_binned,interp.d);

        % Smooth profile applying moving median with a window 20 m window.

        pfl(i).Depth{j} = interp.d.';
        pfl(i).Temperature{j} = smoothdata(interp.t,'movmedian',20);

        %% Clear

        clear bins
        clear interp

    end
    clear j

    clear t

end
clear i