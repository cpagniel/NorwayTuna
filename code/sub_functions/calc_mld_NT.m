%% calc_mld_NT.m
% Sub-function of Norway_Tuna; calculates mixed layer depth every 6 hours by
% (1) averaging data into 1-m bins, (2) vertically interpolating data onto
% a 1-m regular grid, and (3) computes MLD using threshold definition from
% Boyer Montégut et al (2004).

% Requires Climate Data Toolbox (http://www.chadagreene.com/CDT/CDT_Contents.html)

%% Load if file exists.

cd([fdir '/data/mld'])

if exist('oce_mld.mat','file') == 2

    load("oce_mld.mat")

else

    %% Loop through each tag.

    t_mld = {};
    oce_mld = NaN;
    toppID = unique(PSAT.TOPPID);

    for i = 1:length(toppID)

        disp(toppID(i));

        %% Create 6-hour datetime vector.

        h_min = datetime(year(min(PSAT.DateTime(PSAT.TOPPID == toppID(i)))),...
            month(min(PSAT.DateTime(PSAT.TOPPID == toppID(i)))),...
            day(min(PSAT.DateTime(PSAT.TOPPID == toppID(i)))),...
            hour(min(PSAT.DateTime(PSAT.TOPPID == toppID(i)))),0,0);

        h_max = datetime(year(max(PSAT.DateTime(PSAT.TOPPID == toppID(i)))),...
            month(max(PSAT.DateTime(PSAT.TOPPID == toppID(i)))),...
            day(max(PSAT.DateTime(PSAT.TOPPID == toppID(i)))),...
            hour(max(PSAT.DateTime(PSAT.TOPPID == toppID(i)))),0,0) + hours(1);

        h = h_min:hours(6):h_max;

        %% Create 1-m bin averaged, interpolated, six hours profiles.

        for j = 1:length(h)-1

            tmp = PSAT(PSAT.TOPPID == toppID(i) & PSAT.DateTime >= h(j) & PSAT.DateTime < h(j+1),:);

            % Average temperature data in 1-m bins.

            bins.d_bin = floor(min(tmp.Depth)):1:ceil(max(tmp.Depth))+1; % create 1-m bins between minimum and maximum depth
            bins.d_cat = discretize(tmp.Depth,bins.d_bin.'); % determine which bin each depth-temperature measurement was made in

            bins.t_avg = accumarray(bins.d_cat,tmp.Temperature,[],@mean); % take average of all temperatures in 1-m bin

            bins.t_binned = bins.t_avg(bins.t_avg ~= 0); bins.d_binned = bins.d_bin(bins.t_avg ~= 0); % remove empty bins between minimum and maximum depth

            % Interpolate onto a 1-m regular grid between minimum and maximum
            % depth.

            interp.d = bins.d_bin;
            interp.t = gsw_t_interp(bins.t_binned,bins.d_binned,interp.d);

            % Smooth profile applying moving median with 10 m window.

            sm.d = bins.d_bin;
            sm.t = smoothdata(interp.t,'movmedian',10);

            %% Calculate mixed layer depth using threshold definition from Boyer Montégut et al (2004).
            % Δ_T = 0.2 deg C greater than the temperature at 10 m depth

            if length(interp.d) <= 12 % must have a profile spanning at least 12 meters to compute

                oce_mld(j,i) = NaN;

            elseif min(sm.d) <= 10 % must have a mininmum depth less than 10 m

                oce_mld(j,i) = mld(sm.d.', sm.t, 'metric', 'threshold', 'tthresh', 0.2); % m

                if oce_mld(j,i) >= max(sm.d) % if mixed layer depth is greater or equal to maximum depth, fish did not swim through mixed layer depth
                    oce_mld(j,i) = NaN;
                end

                if oce_mld(j,i) == 0 % mixed layer depth is not 0 m anywhere
                    oce_mld(j,i) = NaN;
                end

            else

                oce_mld(j,i) = NaN;

            end

            %% Clear

            clear bins
            clear interp
            clear sm

        end
        clear j

        oce_mld(:,i) = smoothdata(oce_mld(:,i),'movmedian',56); % 7-day moving median filter
        t_mld{i} = h;

        clear h*

    end
    clear i

end
