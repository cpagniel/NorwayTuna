%% calc_MLD_SST_etc_NT.m
% Sub-function of Norway_Tuna; calculates mixed layer depth and sea surface
% temperature every day by (1) averaging data into 1-m bins, (2) vertically
% interpolating data onto a 1-m regular grid, (3) smoothed with a 20-m
% window and (4) computes MLD using threshold definition from
% Boyer Montégut et al (2004).

% Requires Climate Data Toolbox (http://www.chadagreene.com/CDT/CDT_Contents.html)

%% Loop through each tag.

toppID = unique(PSAT.TOPPID);

oce = struct();
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

        % Interpolate onto a 1-m regular grid between minimum and maximum depth.
        interp.d = min(bins.d_bin):1:max(bins.d_bin);
        interp.t = gsw_t_interp(bins.t_binned,bins.d_binned,interp.d);

        % Remove NaNs.
        interp.d = interp.d(~isnan(interp.t));
        interp.t = interp.t(~isnan(interp.t));

        % Smooth profile applying moving median with a window 20 m window.
        pfl.Depth = interp.d.';
        pfl.Temperature = smoothdata(interp.t,'movmedian',20);

        % Add NaNs from 0 to minimum depth if profile does not start at 0 m.
        if min(bins.d_bin) ~= 0
            pfl.Depth = [transpose(0:min(bins.d_bin)-1); pfl.Depth];
            pfl.Temperature = [NaN(length(0:min(bins.d_bin)-1),1); pfl.Temperature];
        end

        %% Calculate mixed layer depth using threshold definition from Boyer Montégut et al (2004).
        % Δ_T = 0.2 deg C greater than the temperature at 10 m depth
        % Also compute temperature at the MLD, depth of the temperature
        % mininum and max depth of profiles.

        if length(pfl.Depth(~isnan(pfl.Temperature))) <= 25 % must have a profile spanning at least 25 meters to compute MLD

            oce(i).mld(j) = NaN;
            oce(i).T_at_mld(j) = NaN;
            oce(i).SST(j) = median(pfl.Temperature(~isnan(pfl.Temperature) & pfl.Depth <= 5));
            oce(i).min_d(j) = min(pfl.Depth(~isnan(pfl.Temperature)));
            oce(i).max_d(j) = max(pfl.Depth(~isnan(pfl.Temperature)));
            oce(i).min_T(j) = min(pfl.Temperature(~isnan(pfl.Temperature)));
            oce(i).max_T(j) = max(pfl.Temperature(~isnan(pfl.Temperature)));

        elseif min(pfl.Depth(~isnan(pfl.Temperature))) <= 10 % must have a mininmum depth less than 10 m

            oce(i).mld(j) = mld(pfl.Depth(~isnan(pfl.Temperature)),pfl.Temperature(~isnan(pfl.Temperature)),'metric','threshold','tthresh',0.2); % m
            oce(i).T_at_mld(j) = interp1(pfl.Depth(~isnan(pfl.Temperature)),pfl.Temperature(~isnan(pfl.Temperature)),oce(i).mld(j));
            oce(i).SST(j) = median(pfl.Temperature(~isnan(pfl.Temperature) & pfl.Depth <= 5));
            oce(i).min_d(j) = min(pfl.Depth(~isnan(pfl.Temperature)));
            oce(i).max_d(j) = max(pfl.Depth(~isnan(pfl.Temperature)));
            oce(i).min_T(j) = min(pfl.Temperature(~isnan(pfl.Temperature)));
            oce(i).max_T(j) = max(pfl.Temperature(~isnan(pfl.Temperature)));

            if oce(i).mld(j) == 0 % mixed layer depth is not 0 m anywhere
                oce(i).mld(j) = NaN;
                oce(i).T_at_mld(j) = NaN;
            end

        else

            oce(i).mld(j) = NaN;
            oce(i).T_at_mld(j) = NaN;
            oce(i).SST(j) = median(pfl.Temperature(~isnan(pfl.Temperature) & pfl.Depth <= 5));
            oce(i).min_d(j) = min(pfl.Depth(~isnan(pfl.Temperature)));
            oce(i).max_d(j) = max(pfl.Depth(~isnan(pfl.Temperature)));
            oce(i).min_T(j) = min(pfl.Temperature(~isnan(pfl.Temperature)));
            oce(i).max_T(j) = max(pfl.Temperature(~isnan(pfl.Temperature)));

        end

        oce(i).toppID(j) = toppID(i);

        %% Clear

        clear tmp
        clear bins
        clear interp
        clear pfl

    end
    clear j

    oce(i).t = t;

    oce(i).region = NaN(length(t),1);
    for j = 1:length(t)
        ind_time = find(SSM.Date == t(j));
        ind_topp = find(SSM.TOPPID == toppID(i));

        ind = intersect(ind_time,ind_topp);

        oce(i).region(j) = SSM.Region(ind);
    end
    clear j
    clear ind*

    oce(i).season = NaN(length(t),1);
    for j = 1:length(t)
        ind_time = find(SSM.Date == t(j));
        ind_topp = find(SSM.TOPPID == toppID(i));

        ind = intersect(ind_time,ind_topp);

        oce(i).season(j) = SSM.Season(ind);
    end
    clear j
    clear ind*

    clear t

end
clear i
clear toppID

%% Summary Statistics

tmp.mld = [oce.mld];
tmp.t_at_mld = [oce.T_at_mld];
tmp.sst = [oce.SST];
tmp.min_d = [oce.min_d];
tmp.max_d = [oce.max_d];
tmp.min_T = [oce.min_T];
tmp.max_T = [oce.max_T];
tmp.region = vertcat(oce.region).';
tmp.season = vertcat(oce.season).';
tmp.t = vertcat(oce.t).';
tmp.toppID = [oce.toppID];

oce = tmp;
clear tmp

%% SST

stats.sst.Nordic.Fall.median = median(oce.sst(oce.region == 1 & oce.season == 1),'omitnan');
stats.sst.Nordic.Fall.mad = mad(oce.sst(oce.region == 1 & oce.season == 1),1);
stats.sst.Nordic.Fall.min = min(oce.sst(oce.region == 1 & oce.season == 1));
stats.sst.Nordic.Fall.max = max(oce.sst(oce.region == 1 & oce.season == 1));

stats.sst.Nordic.Winter.median = median(oce.sst(oce.region == 1 & oce.season == 2),'omitnan');
stats.sst.Nordic.Winter.mad = mad(oce.sst(oce.region == 1 & oce.season == 2),1);
stats.sst.Nordic.Winter.min = min(oce.sst(oce.region == 1 & oce.season == 2));
stats.sst.Nordic.Winter.max = max(oce.sst(oce.region == 1 & oce.season == 2));

stats.sst.Nordic.Spring.median = median(oce.sst(oce.region == 1 & oce.season == 3),'omitnan');
stats.sst.Nordic.Spring.mad = mad(oce.sst(oce.region == 1 & oce.season == 3),1);
stats.sst.Nordic.Spring.min = min(oce.sst(oce.region == 1 & oce.season == 3));
stats.sst.Nordic.Spring.max = max(oce.sst(oce.region == 1 & oce.season == 3));

stats.sst.Nordic.Summer.median = median(oce.sst(oce.region == 1 & oce.season == 4),'omitnan');
stats.sst.Nordic.Summer.mad = mad(oce.sst(oce.region == 1 & oce.season == 4),1);
stats.sst.Nordic.Summer.min = min(oce.sst(oce.region == 1 & oce.season == 4));
stats.sst.Nordic.Summer.max = max(oce.sst(oce.region == 1 & oce.season == 4));

stats.sst.NB.Fall.median = median(oce.sst(oce.region == 2 & oce.season == 1),'omitnan');
stats.sst.NB.Fall.mad = mad(oce.sst(oce.region == 2 & oce.season == 1),1);
stats.sst.NB.Fall.min = min(oce.sst(oce.region == 2 & oce.season == 1));
stats.sst.NB.Fall.max = max(oce.sst(oce.region == 2 & oce.season == 1));

stats.sst.NB.Winter.median = median(oce.sst(oce.region == 2 & oce.season == 2),'omitnan');
stats.sst.NB.Winter.mad = mad(oce.sst(oce.region == 2 & oce.season == 2),1);
stats.sst.NB.Winter.min = min(oce.sst(oce.region == 2 & oce.season == 2));
stats.sst.NB.Winter.max = max(oce.sst(oce.region == 2 & oce.season == 2));

stats.sst.NB.Spring.median = median(oce.sst(oce.region == 2 & oce.season == 3),'omitnan');
stats.sst.NB.Spring.mad = mad(oce.sst(oce.region == 2 & oce.season == 3),1);
stats.sst.NB.Spring.min = min(oce.sst(oce.region == 2 & oce.season == 3));
stats.sst.NB.Spring.max = max(oce.sst(oce.region == 2 & oce.season == 3));

stats.sst.NB.Summer.median = median(oce.sst(oce.region == 2 & oce.season == 4),'omitnan');
stats.sst.NB.Summer.mad = mad(oce.sst(oce.region == 2 & oce.season == 4),1);
stats.sst.NB.Summer.min = min(oce.sst(oce.region == 2 & oce.season == 4));
stats.sst.NB.Summer.max = max(oce.sst(oce.region == 2 & oce.season == 4));

stats.sst.CI.Fall.median = median(oce.sst(oce.region == 3 & oce.season == 1),'omitnan');
stats.sst.CI.Fall.mad = mad(oce.sst(oce.region == 3 & oce.season == 1),1);
stats.sst.CI.Fall.min = min(oce.sst(oce.region == 3 & oce.season == 1));
stats.sst.CI.Fall.max = max(oce.sst(oce.region == 3 & oce.season == 1));

stats.sst.CI.Winter.median = median(oce.sst(oce.region == 3 & oce.season == 2),'omitnan');
stats.sst.CI.Winter.mad = mad(oce.sst(oce.region == 3 & oce.season == 2),1);
stats.sst.CI.Winter.min = min(oce.sst(oce.region == 3 & oce.season == 2));
stats.sst.CI.Winter.max = max(oce.sst(oce.region == 3 & oce.season == 2));

stats.sst.CI.Spring.median = median(oce.sst(oce.region == 3 & oce.season == 3),'omitnan');
stats.sst.CI.Spring.mad = mad(oce.sst(oce.region == 3 & oce.season == 3),1);
stats.sst.CI.Spring.min = min(oce.sst(oce.region == 3 & oce.season == 3));
stats.sst.CI.Spring.max = max(oce.sst(oce.region == 3 & oce.season == 3));

stats.sst.CI.Summer.median = median(oce.sst(oce.region == 3 & oce.season == 4),'omitnan');
stats.sst.CI.Summer.mad = mad(oce.sst(oce.region == 3 & oce.season == 4),1);
stats.sst.CI.Summer.min = min(oce.sst(oce.region == 3 & oce.season == 4));
stats.sst.CI.Summer.max = max(oce.sst(oce.region == 3 & oce.season == 4));

stats.sst.Med.Fall.median = median(oce.sst(oce.region == 4 & oce.season == 1),'omitnan');
stats.sst.Med.Fall.mad = mad(oce.sst(oce.region == 4 & oce.season == 1),1);
stats.sst.Med.Fall.min = min(oce.sst(oce.region == 4 & oce.season == 1));
stats.sst.Med.Fall.max = max(oce.sst(oce.region == 4 & oce.season == 1));

stats.sst.Med.Winter.median = median(oce.sst(oce.region == 4 & oce.season == 2),'omitnan');
stats.sst.Med.Winter.mad = mad(oce.sst(oce.region == 4 & oce.season == 2),1);
stats.sst.Med.Winter.min = min(oce.sst(oce.region == 4 & oce.season == 2));
stats.sst.Med.Winter.max = max(oce.sst(oce.region == 4 & oce.season == 2));

stats.sst.Med.Spring.median = median(oce.sst(oce.region == 4 & oce.season == 3),'omitnan');
stats.sst.Med.Spring.mad = mad(oce.sst(oce.region == 4 & oce.season == 3),1);
stats.sst.Med.Spring.min = min(oce.sst(oce.region == 4 & oce.season == 3));
stats.sst.Med.Spring.max = max(oce.sst(oce.region == 4 & oce.season == 3));

stats.sst.Med.Summer.median = median(oce.sst(oce.region == 4 & oce.season == 4),'omitnan');
stats.sst.Med.Summer.mad = mad(oce.sst(oce.region == 4 & oce.season == 4),1);
stats.sst.Med.Summer.min = min(oce.sst(oce.region == 4 & oce.season == 4));
stats.sst.Med.Summer.max = max(oce.sst(oce.region == 4 & oce.season == 4));

stats.sst.WEB.Fall.median = median(oce.sst(oce.region == 5 & oce.season == 1),'omitnan');
stats.sst.WEB.Fall.mad = mad(oce.sst(oce.region == 5 & oce.season == 1),1);
stats.sst.WEB.Fall.min = min(oce.sst(oce.region == 5 & oce.season == 1));
stats.sst.WEB.Fall.max = max(oce.sst(oce.region == 5 & oce.season == 1));

stats.sst.WEB.Winter.median = median(oce.sst(oce.region == 5 & oce.season == 2),'omitnan');
stats.sst.WEB.Winter.mad = mad(oce.sst(oce.region == 5 & oce.season == 2),1);
stats.sst.WEB.Winter.min = min(oce.sst(oce.region == 5 & oce.season == 2));
stats.sst.WEB.Winter.max = max(oce.sst(oce.region == 5 & oce.season == 2));

stats.sst.WEB.Spring.median = median(oce.sst(oce.region == 5 & oce.season == 3),'omitnan');
stats.sst.WEB.Spring.mad = mad(oce.sst(oce.region == 5 & oce.season == 3),1);
stats.sst.WEB.Spring.min = min(oce.sst(oce.region == 5 & oce.season == 3));
stats.sst.WEB.Spring.max = max(oce.sst(oce.region == 5 & oce.season == 3));

stats.sst.WEB.Summer.median = median(oce.sst(oce.region == 5 & oce.season == 4),'omitnan');
stats.sst.WEB.Summer.mad = mad(oce.sst(oce.region == 5 & oce.season == 4),1);
stats.sst.WEB.Summer.min = min(oce.sst(oce.region == 5 & oce.season == 4));
stats.sst.WEB.Summer.max = max(oce.sst(oce.region == 5 & oce.season == 4));

stats.sst.Migratory.Fall.median = median(oce.sst(oce.region == 0 & oce.season == 1),'omitnan');
stats.sst.Migratory.Fall.mad = mad(oce.sst(oce.region == 0 & oce.season == 1),1);
stats.sst.Migratory.Fall.min = min(oce.sst(oce.region == 0 & oce.season == 1));
stats.sst.Migratory.Fall.max = max(oce.sst(oce.region == 0 & oce.season == 1));

stats.sst.Migratory.Winter.median = median(oce.sst(oce.region == 0 & oce.season == 2),'omitnan');
stats.sst.Migratory.Winter.mad = mad(oce.sst(oce.region == 0 & oce.season == 2),1);
stats.sst.Migratory.Winter.min = min(oce.sst(oce.region == 0 & oce.season == 2));
stats.sst.Migratory.Winter.max = max(oce.sst(oce.region == 0 & oce.season == 2));

stats.sst.Migratory.Spring.median = median(oce.sst(oce.region == 0 & oce.season == 3),'omitnan');
stats.sst.Migratory.Spring.mad = mad(oce.sst(oce.region == 0 & oce.season == 3),1);
stats.sst.Migratory.Spring.min = min(oce.sst(oce.region == 0 & oce.season == 3));
stats.sst.Migratory.Spring.max = max(oce.sst(oce.region == 0 & oce.season == 3));

stats.sst.Migratory.Summer.median = median(oce.sst(oce.region == 0 & oce.season == 4),'omitnan');
stats.sst.Migratory.Summer.mad = mad(oce.sst(oce.region == 0 & oce.season == 4),1);
stats.sst.Migratory.Summer.min = min(oce.sst(oce.region == 0 & oce.season == 4));
stats.sst.Migratory.Summer.max = max(oce.sst(oce.region == 0 & oce.season == 4));

%% MLD

stats.mld.Nordic.Fall.median = median(oce.mld(oce.region == 1 & oce.season == 1),'omitnan');
stats.mld.Nordic.Fall.mad = mad(oce.mld(oce.region == 1 & oce.season == 1),1);
stats.mld.Nordic.Fall.min = min(oce.mld(oce.region == 1 & oce.season == 1));
stats.mld.Nordic.Fall.max = max(oce.mld(oce.region == 1 & oce.season == 1));

stats.mld.Nordic.Winter.median = median(oce.mld(oce.region == 1 & oce.season == 2),'omitnan');
stats.mld.Nordic.Winter.mad = mad(oce.mld(oce.region == 1 & oce.season == 2),1);
stats.mld.Nordic.Winter.min = min(oce.mld(oce.region == 1 & oce.season == 2));
stats.mld.Nordic.Winter.max = max(oce.mld(oce.region == 1 & oce.season == 2));

stats.mld.Nordic.Spring.median = median(oce.mld(oce.region == 1 & oce.season == 3),'omitnan');
stats.mld.Nordic.Spring.mad = mad(oce.mld(oce.region == 1 & oce.season == 3),1);
stats.mld.Nordic.Spring.min = min(oce.mld(oce.region == 1 & oce.season == 3));
stats.mld.Nordic.Spring.max = max(oce.mld(oce.region == 1 & oce.season == 3));

stats.mld.Nordic.Summer.median = median(oce.mld(oce.region == 1 & oce.season == 4),'omitnan');
stats.mld.Nordic.Summer.mad = mad(oce.mld(oce.region == 1 & oce.season == 4),1);
stats.mld.Nordic.Summer.min = min(oce.mld(oce.region == 1 & oce.season == 4));
stats.mld.Nordic.Summer.max = max(oce.mld(oce.region == 1 & oce.season == 4));

stats.mld.NB.Fall.median = median(oce.mld(oce.region == 2 & oce.season == 1),'omitnan');
stats.mld.NB.Fall.mad = mad(oce.mld(oce.region == 2 & oce.season == 1),1);
stats.mld.NB.Fall.min = min(oce.mld(oce.region == 2 & oce.season == 1));
stats.mld.NB.Fall.max = max(oce.mld(oce.region == 2 & oce.season == 1));

stats.mld.NB.Winter.median = median(oce.mld(oce.region == 2 & oce.season == 2),'omitnan');
stats.mld.NB.Winter.mad = mad(oce.mld(oce.region == 2 & oce.season == 2),1);
stats.mld.NB.Winter.min = min(oce.mld(oce.region == 2 & oce.season == 2));
stats.mld.NB.Winter.max = max(oce.mld(oce.region == 2 & oce.season == 2));

stats.mld.NB.Spring.median = median(oce.mld(oce.region == 2 & oce.season == 3),'omitnan');
stats.mld.NB.Spring.mad = mad(oce.mld(oce.region == 2 & oce.season == 3),1);
stats.mld.NB.Spring.min = min(oce.mld(oce.region == 2 & oce.season == 3));
stats.mld.NB.Spring.max = max(oce.mld(oce.region == 2 & oce.season == 3));

stats.mld.NB.Summer.median = median(oce.mld(oce.region == 2 & oce.season == 4),'omitnan');
stats.mld.NB.Summer.mad = mad(oce.mld(oce.region == 2 & oce.season == 4),1);
stats.mld.NB.Summer.min = min(oce.mld(oce.region == 2 & oce.season == 4));
stats.mld.NB.Summer.max = max(oce.mld(oce.region == 2 & oce.season == 4));

stats.mld.CI.Fall.median = median(oce.mld(oce.region == 3 & oce.season == 1),'omitnan');
stats.mld.CI.Fall.mad = mad(oce.mld(oce.region == 3 & oce.season == 1),1);
stats.mld.CI.Fall.min = min(oce.mld(oce.region == 3 & oce.season == 1));
stats.mld.CI.Fall.max = max(oce.mld(oce.region == 3 & oce.season == 1));

stats.mld.CI.Winter.median = median(oce.mld(oce.region == 3 & oce.season == 2),'omitnan');
stats.mld.CI.Winter.mad = mad(oce.mld(oce.region == 3 & oce.season == 2),1);
stats.mld.CI.Winter.min = min(oce.mld(oce.region == 3 & oce.season == 2));
stats.mld.CI.Winter.max = max(oce.mld(oce.region == 3 & oce.season == 2));

stats.mld.CI.Spring.median = median(oce.mld(oce.region == 3 & oce.season == 3),'omitnan');
stats.mld.CI.Spring.mad = mad(oce.mld(oce.region == 3 & oce.season == 3),1);
stats.mld.CI.Spring.min = min(oce.mld(oce.region == 3 & oce.season == 3));
stats.mld.CI.Spring.max = max(oce.mld(oce.region == 3 & oce.season == 3));

stats.mld.CI.Summer.median = median(oce.mld(oce.region == 3 & oce.season == 4),'omitnan');
stats.mld.CI.Summer.mad = mad(oce.mld(oce.region == 3 & oce.season == 4),1);
stats.mld.CI.Summer.min = min(oce.mld(oce.region == 3 & oce.season == 4));
stats.mld.CI.Summer.max = max(oce.mld(oce.region == 3 & oce.season == 4));

stats.mld.Med.Fall.median = median(oce.mld(oce.region == 4 & oce.season == 1),'omitnan');
stats.mld.Med.Fall.mad = mad(oce.mld(oce.region == 4 & oce.season == 1),1);
stats.mld.Med.Fall.min = min(oce.mld(oce.region == 4 & oce.season == 1));
stats.mld.Med.Fall.max = max(oce.mld(oce.region == 4 & oce.season == 1));

stats.mld.Med.Winter.median = median(oce.mld(oce.region == 4 & oce.season == 2),'omitnan');
stats.mld.Med.Winter.mad = mad(oce.mld(oce.region == 4 & oce.season == 2),1);
stats.mld.Med.Winter.min = min(oce.mld(oce.region == 4 & oce.season == 2));
stats.mld.Med.Winter.max = max(oce.mld(oce.region == 4 & oce.season == 2));

stats.mld.Med.Spring.median = median(oce.mld(oce.region == 4 & oce.season == 3),'omitnan');
stats.mld.Med.Spring.mad = mad(oce.mld(oce.region == 4 & oce.season == 3),1);
stats.mld.Med.Spring.min = min(oce.mld(oce.region == 4 & oce.season == 3));
stats.mld.Med.Spring.max = max(oce.mld(oce.region == 4 & oce.season == 3));

stats.mld.Med.Summer.median = median(oce.mld(oce.region == 4 & oce.season == 4),'omitnan');
stats.mld.Med.Summer.mad = mad(oce.mld(oce.region == 4 & oce.season == 4),1);
stats.mld.Med.Summer.min = min(oce.mld(oce.region == 4 & oce.season == 4));
stats.mld.Med.Summer.max = max(oce.mld(oce.region == 4 & oce.season == 4));

stats.mld.WEB.Fall.median = median(oce.mld(oce.region == 5 & oce.season == 1),'omitnan');
stats.mld.WEB.Fall.mad = mad(oce.mld(oce.region == 5 & oce.season == 1),1);
stats.mld.WEB.Fall.min = min(oce.mld(oce.region == 5 & oce.season == 1));
stats.mld.WEB.Fall.max = max(oce.mld(oce.region == 5 & oce.season == 1));

stats.mld.WEB.Winter.median = median(oce.mld(oce.region == 5 & oce.season == 2),'omitnan');
stats.mld.WEB.Winter.mad = mad(oce.mld(oce.region == 5 & oce.season == 2),1);
stats.mld.WEB.Winter.min = min(oce.mld(oce.region == 5 & oce.season == 2));
stats.mld.WEB.Winter.max = max(oce.mld(oce.region == 5 & oce.season == 2));

stats.mld.WEB.Spring.median = median(oce.mld(oce.region == 5 & oce.season == 3),'omitnan');
stats.mld.WEB.Spring.mad = mad(oce.mld(oce.region == 5 & oce.season == 3),1);
stats.mld.WEB.Spring.min = min(oce.mld(oce.region == 5 & oce.season == 3));
stats.mld.WEB.Spring.max = max(oce.mld(oce.region == 5 & oce.season == 3));

stats.mld.WEB.Summer.median = median(oce.mld(oce.region == 5 & oce.season == 4),'omitnan');
stats.mld.WEB.Summer.mad = mad(oce.mld(oce.region == 5 & oce.season == 4),1);
stats.mld.WEB.Summer.min = min(oce.mld(oce.region == 5 & oce.season == 4));
stats.mld.WEB.Summer.max = max(oce.mld(oce.region == 5 & oce.season == 4));

stats.mld.Migratory.Fall.median = median(oce.mld(oce.region == 0 & oce.season == 1),'omitnan');
stats.mld.Migratory.Fall.mad = mad(oce.mld(oce.region == 0 & oce.season == 1),1);
stats.mld.Migratory.Fall.min = min(oce.mld(oce.region == 0 & oce.season == 1));
stats.mld.Migratory.Fall.max = max(oce.mld(oce.region == 0 & oce.season == 1));

stats.mld.Migratory.Winter.median = median(oce.mld(oce.region == 0 & oce.season == 2),'omitnan');
stats.mld.Migratory.Winter.mad = mad(oce.mld(oce.region == 0 & oce.season == 2),1);
stats.mld.Migratory.Winter.min = min(oce.mld(oce.region == 0 & oce.season == 2));
stats.mld.Migratory.Winter.max = max(oce.mld(oce.region == 0 & oce.season == 2));

stats.mld.Migratory.Spring.median = median(oce.mld(oce.region == 0 & oce.season == 3),'omitnan');
stats.mld.Migratory.Spring.mad = mad(oce.mld(oce.region == 0 & oce.season == 3),1);
stats.mld.Migratory.Spring.min = min(oce.mld(oce.region == 0 & oce.season == 3));
stats.mld.Migratory.Spring.max = max(oce.mld(oce.region == 0 & oce.season == 3));

stats.mld.Migratory.Summer.median = median(oce.mld(oce.region == 0 & oce.season == 4),'omitnan');
stats.mld.Migratory.Summer.mad = mad(oce.mld(oce.region == 0 & oce.season == 4),1);
stats.mld.Migratory.Summer.min = min(oce.mld(oce.region == 0 & oce.season == 4));
stats.mld.Migratory.Summer.max = max(oce.mld(oce.region == 0 & oce.season == 4));

%% T @ MLD

stats.t_at_mld.Nordic.Fall.median = median(oce.t_at_mld(oce.region == 1 & oce.season == 1),'omitnan');
stats.t_at_mld.Nordic.Fall.mad = mad(oce.t_at_mld(oce.region == 1 & oce.season == 1),1);
stats.t_at_mld.Nordic.Fall.min = min(oce.t_at_mld(oce.region == 1 & oce.season == 1));
stats.t_at_mld.Nordic.Fall.max = max(oce.t_at_mld(oce.region == 1 & oce.season == 1));

stats.t_at_mld.Nordic.Winter.median = median(oce.t_at_mld(oce.region == 1 & oce.season == 2),'omitnan');
stats.t_at_mld.Nordic.Winter.mad = mad(oce.t_at_mld(oce.region == 1 & oce.season == 2),1);
stats.t_at_mld.Nordic.Winter.min = min(oce.t_at_mld(oce.region == 1 & oce.season == 2));
stats.t_at_mld.Nordic.Winter.max = max(oce.t_at_mld(oce.region == 1 & oce.season == 2));

stats.t_at_mld.Nordic.Spring.median = median(oce.t_at_mld(oce.region == 1 & oce.season == 3),'omitnan');
stats.t_at_mld.Nordic.Spring.mad = mad(oce.t_at_mld(oce.region == 1 & oce.season == 3),1);
stats.t_at_mld.Nordic.Spring.min = min(oce.t_at_mld(oce.region == 1 & oce.season == 3));
stats.t_at_mld.Nordic.Spring.max = max(oce.t_at_mld(oce.region == 1 & oce.season == 3));

stats.t_at_mld.Nordic.Summer.median = median(oce.t_at_mld(oce.region == 1 & oce.season == 4),'omitnan');
stats.t_at_mld.Nordic.Summer.mad = mad(oce.t_at_mld(oce.region == 1 & oce.season == 4),1);
stats.t_at_mld.Nordic.Summer.min = min(oce.t_at_mld(oce.region == 1 & oce.season == 4));
stats.t_at_mld.Nordic.Summer.max = max(oce.t_at_mld(oce.region == 1 & oce.season == 4));

stats.t_at_mld.NB.Fall.median = median(oce.t_at_mld(oce.region == 2 & oce.season == 1),'omitnan');
stats.t_at_mld.NB.Fall.mad = mad(oce.t_at_mld(oce.region == 2 & oce.season == 1),1);
stats.t_at_mld.NB.Fall.min = min(oce.t_at_mld(oce.region == 2 & oce.season == 1));
stats.t_at_mld.NB.Fall.max = max(oce.t_at_mld(oce.region == 2 & oce.season == 1));

stats.t_at_mld.NB.Winter.median = median(oce.t_at_mld(oce.region == 2 & oce.season == 2),'omitnan');
stats.t_at_mld.NB.Winter.mad = mad(oce.t_at_mld(oce.region == 2 & oce.season == 2),1);
stats.t_at_mld.NB.Winter.min = min(oce.t_at_mld(oce.region == 2 & oce.season == 2));
stats.t_at_mld.NB.Winter.max = max(oce.t_at_mld(oce.region == 2 & oce.season == 2));

stats.t_at_mld.NB.Spring.median = median(oce.t_at_mld(oce.region == 2 & oce.season == 3),'omitnan');
stats.t_at_mld.NB.Spring.mad = mad(oce.t_at_mld(oce.region == 2 & oce.season == 3),1);
stats.t_at_mld.NB.Spring.min = min(oce.t_at_mld(oce.region == 2 & oce.season == 3));
stats.t_at_mld.NB.Spring.max = max(oce.t_at_mld(oce.region == 2 & oce.season == 3));

stats.t_at_mld.NB.Summer.median = median(oce.t_at_mld(oce.region == 2 & oce.season == 4),'omitnan');
stats.t_at_mld.NB.Summer.mad = mad(oce.t_at_mld(oce.region == 2 & oce.season == 4),1);
stats.t_at_mld.NB.Summer.min = min(oce.t_at_mld(oce.region == 2 & oce.season == 4));
stats.t_at_mld.NB.Summer.max = max(oce.t_at_mld(oce.region == 2 & oce.season == 4));

stats.t_at_mld.CI.Fall.median = median(oce.t_at_mld(oce.region == 3 & oce.season == 1),'omitnan');
stats.t_at_mld.CI.Fall.mad = mad(oce.t_at_mld(oce.region == 3 & oce.season == 1),1);
stats.t_at_mld.CI.Fall.min = min(oce.t_at_mld(oce.region == 3 & oce.season == 1));
stats.t_at_mld.CI.Fall.max = max(oce.t_at_mld(oce.region == 3 & oce.season == 1));

stats.t_at_mld.CI.Winter.median = median(oce.t_at_mld(oce.region == 3 & oce.season == 2),'omitnan');
stats.t_at_mld.CI.Winter.mad = mad(oce.t_at_mld(oce.region == 3 & oce.season == 2),1);
stats.t_at_mld.CI.Winter.min = min(oce.t_at_mld(oce.region == 3 & oce.season == 2));
stats.t_at_mld.CI.Winter.max = max(oce.t_at_mld(oce.region == 3 & oce.season == 2));

stats.t_at_mld.CI.Spring.median = median(oce.t_at_mld(oce.region == 3 & oce.season == 3),'omitnan');
stats.t_at_mld.CI.Spring.mad = mad(oce.t_at_mld(oce.region == 3 & oce.season == 3),1);
stats.t_at_mld.CI.Spring.min = min(oce.t_at_mld(oce.region == 3 & oce.season == 3));
stats.t_at_mld.CI.Spring.max = max(oce.t_at_mld(oce.region == 3 & oce.season == 3));

stats.t_at_mld.CI.Summer.median = median(oce.t_at_mld(oce.region == 3 & oce.season == 4),'omitnan');
stats.t_at_mld.CI.Summer.mad = mad(oce.t_at_mld(oce.region == 3 & oce.season == 4),1);
stats.t_at_mld.CI.Summer.min = min(oce.t_at_mld(oce.region == 3 & oce.season == 4));
stats.t_at_mld.CI.Summer.max = max(oce.t_at_mld(oce.region == 3 & oce.season == 4));

stats.t_at_mld.Med.Fall.median = median(oce.t_at_mld(oce.region == 4 & oce.season == 1),'omitnan');
stats.t_at_mld.Med.Fall.mad = mad(oce.t_at_mld(oce.region == 4 & oce.season == 1),1);
stats.t_at_mld.Med.Fall.min = min(oce.t_at_mld(oce.region == 4 & oce.season == 1));
stats.t_at_mld.Med.Fall.max = max(oce.t_at_mld(oce.region == 4 & oce.season == 1));

stats.t_at_mld.Med.Winter.median = median(oce.t_at_mld(oce.region == 4 & oce.season == 2),'omitnan');
stats.t_at_mld.Med.Winter.mad = mad(oce.t_at_mld(oce.region == 4 & oce.season == 2),1);
stats.t_at_mld.Med.Winter.min = min(oce.t_at_mld(oce.region == 4 & oce.season == 2));
stats.t_at_mld.Med.Winter.max = max(oce.t_at_mld(oce.region == 4 & oce.season == 2));

stats.t_at_mld.Med.Spring.median = median(oce.t_at_mld(oce.region == 4 & oce.season == 3),'omitnan');
stats.t_at_mld.Med.Spring.mad = mad(oce.t_at_mld(oce.region == 4 & oce.season == 3),1);
stats.t_at_mld.Med.Spring.min = min(oce.t_at_mld(oce.region == 4 & oce.season == 3));
stats.t_at_mld.Med.Spring.max = max(oce.t_at_mld(oce.region == 4 & oce.season == 3));

stats.t_at_mld.Med.Summer.median = median(oce.t_at_mld(oce.region == 4 & oce.season == 4),'omitnan');
stats.t_at_mld.Med.Summer.mad = mad(oce.t_at_mld(oce.region == 4 & oce.season == 4),1);
stats.t_at_mld.Med.Summer.min = min(oce.t_at_mld(oce.region == 4 & oce.season == 4));
stats.t_at_mld.Med.Summer.max = max(oce.t_at_mld(oce.region == 4 & oce.season == 4));

stats.t_at_mld.WEB.Fall.median = median(oce.t_at_mld(oce.region == 5 & oce.season == 1),'omitnan');
stats.t_at_mld.WEB.Fall.mad = mad(oce.t_at_mld(oce.region == 5 & oce.season == 1),1);
stats.t_at_mld.WEB.Fall.min = min(oce.t_at_mld(oce.region == 5 & oce.season == 1));
stats.t_at_mld.WEB.Fall.max = max(oce.t_at_mld(oce.region == 5 & oce.season == 1));

stats.t_at_mld.WEB.Winter.median = median(oce.t_at_mld(oce.region == 5 & oce.season == 2),'omitnan');
stats.t_at_mld.WEB.Winter.mad = mad(oce.t_at_mld(oce.region == 5 & oce.season == 2),1);
stats.t_at_mld.WEB.Winter.min = min(oce.t_at_mld(oce.region == 5 & oce.season == 2));
stats.t_at_mld.WEB.Winter.max = max(oce.t_at_mld(oce.region == 5 & oce.season == 2));

stats.t_at_mld.WEB.Spring.median = median(oce.t_at_mld(oce.region == 5 & oce.season == 3),'omitnan');
stats.t_at_mld.WEB.Spring.mad = mad(oce.t_at_mld(oce.region == 5 & oce.season == 3),1);
stats.t_at_mld.WEB.Spring.min = min(oce.t_at_mld(oce.region == 5 & oce.season == 3));
stats.t_at_mld.WEB.Spring.max = max(oce.t_at_mld(oce.region == 5 & oce.season == 3));

stats.t_at_mld.WEB.Summer.median = median(oce.t_at_mld(oce.region == 5 & oce.season == 4),'omitnan');
stats.t_at_mld.WEB.Summer.mad = mad(oce.t_at_mld(oce.region == 5 & oce.season == 4),1);
stats.t_at_mld.WEB.Summer.min = min(oce.t_at_mld(oce.region == 5 & oce.season == 4));
stats.t_at_mld.WEB.Summer.max = max(oce.t_at_mld(oce.region == 5 & oce.season == 4));

stats.t_at_mld.Migratory.Fall.median = median(oce.t_at_mld(oce.region == 0 & oce.season == 1),'omitnan');
stats.t_at_mld.Migratory.Fall.mad = mad(oce.t_at_mld(oce.region == 0 & oce.season == 1),1);
stats.t_at_mld.Migratory.Fall.min = min(oce.t_at_mld(oce.region == 0 & oce.season == 1));
stats.t_at_mld.Migratory.Fall.max = max(oce.t_at_mld(oce.region == 0 & oce.season == 1));

stats.t_at_mld.Migratory.Winter.median = median(oce.t_at_mld(oce.region == 0 & oce.season == 2),'omitnan');
stats.t_at_mld.Migratory.Winter.mad = mad(oce.t_at_mld(oce.region == 0 & oce.season == 2),1);
stats.t_at_mld.Migratory.Winter.min = min(oce.t_at_mld(oce.region == 0 & oce.season == 2));
stats.t_at_mld.Migratory.Winter.max = max(oce.t_at_mld(oce.region == 0 & oce.season == 2));

stats.t_at_mld.Migratory.Spring.median = median(oce.t_at_mld(oce.region == 0 & oce.season == 3),'omitnan');
stats.t_at_mld.Migratory.Spring.mad = mad(oce.t_at_mld(oce.region == 0 & oce.season == 3),1);
stats.t_at_mld.Migratory.Spring.min = min(oce.t_at_mld(oce.region == 0 & oce.season == 3));
stats.t_at_mld.Migratory.Spring.max = max(oce.t_at_mld(oce.region == 0 & oce.season == 3));

stats.t_at_mld.Migratory.Summer.median = median(oce.t_at_mld(oce.region == 0 & oce.season == 4),'omitnan');
stats.t_at_mld.Migratory.Summer.mad = mad(oce.t_at_mld(oce.region == 0 & oce.season == 4),1);
stats.t_at_mld.Migratory.Summer.min = min(oce.t_at_mld(oce.region == 0 & oce.season == 4));
stats.t_at_mld.Migratory.Summer.max = max(oce.t_at_mld(oce.region == 0 & oce.season == 4));

%% Min Depth

stats.min_d.Nordic.Fall.median = median(oce.min_d(oce.region == 1 & oce.season == 1),'omitnan');
stats.min_d.Nordic.Fall.mad = mad(oce.min_d(oce.region == 1 & oce.season == 1),1);
stats.min_d.Nordic.Fall.min = min(oce.min_d(oce.region == 1 & oce.season == 1));
stats.min_d.Nordic.Fall.max = max(oce.min_d(oce.region == 1 & oce.season == 1));

stats.min_d.Nordic.Winter.median = median(oce.min_d(oce.region == 1 & oce.season == 2),'omitnan');
stats.min_d.Nordic.Winter.mad = mad(oce.min_d(oce.region == 1 & oce.season == 2),1);
stats.min_d.Nordic.Winter.min = min(oce.min_d(oce.region == 1 & oce.season == 2));
stats.min_d.Nordic.Winter.max = max(oce.min_d(oce.region == 1 & oce.season == 2));

stats.min_d.Nordic.Spring.median = median(oce.min_d(oce.region == 1 & oce.season == 3),'omitnan');
stats.min_d.Nordic.Spring.mad = mad(oce.min_d(oce.region == 1 & oce.season == 3),1);
stats.min_d.Nordic.Spring.min = min(oce.min_d(oce.region == 1 & oce.season == 3));
stats.min_d.Nordic.Spring.max = max(oce.min_d(oce.region == 1 & oce.season == 3));

stats.min_d.Nordic.Summer.median = median(oce.min_d(oce.region == 1 & oce.season == 4),'omitnan');
stats.min_d.Nordic.Summer.mad = mad(oce.min_d(oce.region == 1 & oce.season == 4),1);
stats.min_d.Nordic.Summer.min = min(oce.min_d(oce.region == 1 & oce.season == 4));
stats.min_d.Nordic.Summer.max = max(oce.min_d(oce.region == 1 & oce.season == 4));

stats.min_d.NB.Fall.median = median(oce.min_d(oce.region == 2 & oce.season == 1),'omitnan');
stats.min_d.NB.Fall.mad = mad(oce.min_d(oce.region == 2 & oce.season == 1),1);
stats.min_d.NB.Fall.min = min(oce.min_d(oce.region == 2 & oce.season == 1));
stats.min_d.NB.Fall.max = max(oce.min_d(oce.region == 2 & oce.season == 1));

stats.min_d.NB.Winter.median = median(oce.min_d(oce.region == 2 & oce.season == 2),'omitnan');
stats.min_d.NB.Winter.mad = mad(oce.min_d(oce.region == 2 & oce.season == 2),1);
stats.min_d.NB.Winter.min = min(oce.min_d(oce.region == 2 & oce.season == 2));
stats.min_d.NB.Winter.max = max(oce.min_d(oce.region == 2 & oce.season == 2));

stats.min_d.NB.Spring.median = median(oce.min_d(oce.region == 2 & oce.season == 3),'omitnan');
stats.min_d.NB.Spring.mad = mad(oce.min_d(oce.region == 2 & oce.season == 3),1);
stats.min_d.NB.Spring.min = min(oce.min_d(oce.region == 2 & oce.season == 3));
stats.min_d.NB.Spring.max = max(oce.min_d(oce.region == 2 & oce.season == 3));

stats.min_d.NB.Summer.median = median(oce.min_d(oce.region == 2 & oce.season == 4),'omitnan');
stats.min_d.NB.Summer.mad = mad(oce.min_d(oce.region == 2 & oce.season == 4),1);
stats.min_d.NB.Summer.min = min(oce.min_d(oce.region == 2 & oce.season == 4));
stats.min_d.NB.Summer.max = max(oce.min_d(oce.region == 2 & oce.season == 4));

stats.min_d.CI.Fall.median = median(oce.min_d(oce.region == 3 & oce.season == 1),'omitnan');
stats.min_d.CI.Fall.mad = mad(oce.min_d(oce.region == 3 & oce.season == 1),1);
stats.min_d.CI.Fall.min = min(oce.min_d(oce.region == 3 & oce.season == 1));
stats.min_d.CI.Fall.max = max(oce.min_d(oce.region == 3 & oce.season == 1));

stats.min_d.CI.Winter.median = median(oce.min_d(oce.region == 3 & oce.season == 2),'omitnan');
stats.min_d.CI.Winter.mad = mad(oce.min_d(oce.region == 3 & oce.season == 2),1);
stats.min_d.CI.Winter.min = min(oce.min_d(oce.region == 3 & oce.season == 2));
stats.min_d.CI.Winter.max = max(oce.min_d(oce.region == 3 & oce.season == 2));

stats.min_d.CI.Spring.median = median(oce.min_d(oce.region == 3 & oce.season == 3),'omitnan');
stats.min_d.CI.Spring.mad = mad(oce.min_d(oce.region == 3 & oce.season == 3),1);
stats.min_d.CI.Spring.min = min(oce.min_d(oce.region == 3 & oce.season == 3));
stats.min_d.CI.Spring.max = max(oce.min_d(oce.region == 3 & oce.season == 3));

stats.min_d.CI.Summer.median = median(oce.min_d(oce.region == 3 & oce.season == 4),'omitnan');
stats.min_d.CI.Summer.mad = mad(oce.min_d(oce.region == 3 & oce.season == 4),1);
stats.min_d.CI.Summer.min = min(oce.min_d(oce.region == 3 & oce.season == 4));
stats.min_d.CI.Summer.max = max(oce.min_d(oce.region == 3 & oce.season == 4));

stats.min_d.Med.Fall.median = median(oce.min_d(oce.region == 4 & oce.season == 1),'omitnan');
stats.min_d.Med.Fall.mad = mad(oce.min_d(oce.region == 4 & oce.season == 1),1);
stats.min_d.Med.Fall.min = min(oce.min_d(oce.region == 4 & oce.season == 1));
stats.min_d.Med.Fall.max = max(oce.min_d(oce.region == 4 & oce.season == 1));

stats.min_d.Med.Winter.median = median(oce.min_d(oce.region == 4 & oce.season == 2),'omitnan');
stats.min_d.Med.Winter.mad = mad(oce.min_d(oce.region == 4 & oce.season == 2),1);
stats.min_d.Med.Winter.min = min(oce.min_d(oce.region == 4 & oce.season == 2));
stats.min_d.Med.Winter.max = max(oce.min_d(oce.region == 4 & oce.season == 2));

stats.min_d.Med.Spring.median = median(oce.min_d(oce.region == 4 & oce.season == 3),'omitnan');
stats.min_d.Med.Spring.mad = mad(oce.min_d(oce.region == 4 & oce.season == 3),1);
stats.min_d.Med.Spring.min = min(oce.min_d(oce.region == 4 & oce.season == 3));
stats.min_d.Med.Spring.max = max(oce.min_d(oce.region == 4 & oce.season == 3));

stats.min_d.Med.Summer.median = median(oce.min_d(oce.region == 4 & oce.season == 4),'omitnan');
stats.min_d.Med.Summer.mad = mad(oce.min_d(oce.region == 4 & oce.season == 4),1);
stats.min_d.Med.Summer.min = min(oce.min_d(oce.region == 4 & oce.season == 4));
stats.min_d.Med.Summer.max = max(oce.min_d(oce.region == 4 & oce.season == 4));

stats.min_d.WEB.Fall.median = median(oce.min_d(oce.region == 5 & oce.season == 1),'omitnan');
stats.min_d.WEB.Fall.mad = mad(oce.min_d(oce.region == 5 & oce.season == 1),1);
stats.min_d.WEB.Fall.min = min(oce.min_d(oce.region == 5 & oce.season == 1));
stats.min_d.WEB.Fall.max = max(oce.min_d(oce.region == 5 & oce.season == 1));

stats.min_d.WEB.Winter.median = median(oce.min_d(oce.region == 5 & oce.season == 2),'omitnan');
stats.min_d.WEB.Winter.mad = mad(oce.min_d(oce.region == 5 & oce.season == 2),1);
stats.min_d.WEB.Winter.min = min(oce.min_d(oce.region == 5 & oce.season == 2));
stats.min_d.WEB.Winter.max = max(oce.min_d(oce.region == 5 & oce.season == 2));

stats.min_d.WEB.Spring.median = median(oce.min_d(oce.region == 5 & oce.season == 3),'omitnan');
stats.min_d.WEB.Spring.mad = mad(oce.min_d(oce.region == 5 & oce.season == 3),1);
stats.min_d.WEB.Spring.min = min(oce.min_d(oce.region == 5 & oce.season == 3));
stats.min_d.WEB.Spring.max = max(oce.min_d(oce.region == 5 & oce.season == 3));

stats.min_d.WEB.Summer.median = median(oce.min_d(oce.region == 5 & oce.season == 4),'omitnan');
stats.min_d.WEB.Summer.mad = mad(oce.min_d(oce.region == 5 & oce.season == 4),1);
stats.min_d.WEB.Summer.min = min(oce.min_d(oce.region == 5 & oce.season == 4));
stats.min_d.WEB.Summer.max = max(oce.min_d(oce.region == 5 & oce.season == 4));

stats.min_d.Migratory.Fall.median = median(oce.min_d(oce.region == 0 & oce.season == 1),'omitnan');
stats.min_d.Migratory.Fall.mad = mad(oce.min_d(oce.region == 0 & oce.season == 1),1);
stats.min_d.Migratory.Fall.min = min(oce.min_d(oce.region == 0 & oce.season == 1));
stats.min_d.Migratory.Fall.max = max(oce.min_d(oce.region == 0 & oce.season == 1));

stats.min_d.Migratory.Winter.median = median(oce.min_d(oce.region == 0 & oce.season == 2),'omitnan');
stats.min_d.Migratory.Winter.mad = mad(oce.min_d(oce.region == 0 & oce.season == 2),1);
stats.min_d.Migratory.Winter.min = min(oce.min_d(oce.region == 0 & oce.season == 2));
stats.min_d.Migratory.Winter.max = max(oce.min_d(oce.region == 0 & oce.season == 2));

stats.min_d.Migratory.Spring.median = median(oce.min_d(oce.region == 0 & oce.season == 3),'omitnan');
stats.min_d.Migratory.Spring.mad = mad(oce.min_d(oce.region == 0 & oce.season == 3),1);
stats.min_d.Migratory.Spring.min = min(oce.min_d(oce.region == 0 & oce.season == 3));
stats.min_d.Migratory.Spring.max = max(oce.min_d(oce.region == 0 & oce.season == 3));

stats.min_d.Migratory.Summer.median = median(oce.min_d(oce.region == 0 & oce.season == 4),'omitnan');
stats.min_d.Migratory.Summer.mad = mad(oce.min_d(oce.region == 0 & oce.season == 4),1);
stats.min_d.Migratory.Summer.min = min(oce.min_d(oce.region == 0 & oce.season == 4));
stats.min_d.Migratory.Summer.max = max(oce.min_d(oce.region == 0 & oce.season == 4));

%% Max Depth

stats.max_d.Nordic.Fall.median = median(oce.max_d(oce.region == 1 & oce.season == 1),'omitnan');
stats.max_d.Nordic.Fall.mad = mad(oce.max_d(oce.region == 1 & oce.season == 1),1);
stats.max_d.Nordic.Fall.min = min(oce.max_d(oce.region == 1 & oce.season == 1));
stats.max_d.Nordic.Fall.max = max(oce.max_d(oce.region == 1 & oce.season == 1));

stats.max_d.Nordic.Winter.median = median(oce.max_d(oce.region == 1 & oce.season == 2),'omitnan');
stats.max_d.Nordic.Winter.mad = mad(oce.max_d(oce.region == 1 & oce.season == 2),1);
stats.max_d.Nordic.Winter.min = min(oce.max_d(oce.region == 1 & oce.season == 2));
stats.max_d.Nordic.Winter.max = max(oce.max_d(oce.region == 1 & oce.season == 2));

stats.max_d.Nordic.Spring.median = median(oce.max_d(oce.region == 1 & oce.season == 3),'omitnan');
stats.max_d.Nordic.Spring.mad = mad(oce.max_d(oce.region == 1 & oce.season == 3),1);
stats.max_d.Nordic.Spring.min = min(oce.max_d(oce.region == 1 & oce.season == 3));
stats.max_d.Nordic.Spring.max = max(oce.max_d(oce.region == 1 & oce.season == 3));

stats.max_d.Nordic.Summer.median = median(oce.max_d(oce.region == 1 & oce.season == 4),'omitnan');
stats.max_d.Nordic.Summer.mad = mad(oce.max_d(oce.region == 1 & oce.season == 4),1);
stats.max_d.Nordic.Summer.min = min(oce.max_d(oce.region == 1 & oce.season == 4));
stats.max_d.Nordic.Summer.max = max(oce.max_d(oce.region == 1 & oce.season == 4));

stats.max_d.NB.Fall.median = median(oce.max_d(oce.region == 2 & oce.season == 1),'omitnan');
stats.max_d.NB.Fall.mad = mad(oce.max_d(oce.region == 2 & oce.season == 1),1);
stats.max_d.NB.Fall.min = min(oce.max_d(oce.region == 2 & oce.season == 1));
stats.max_d.NB.Fall.max = max(oce.max_d(oce.region == 2 & oce.season == 1));

stats.max_d.NB.Winter.median = median(oce.max_d(oce.region == 2 & oce.season == 2),'omitnan');
stats.max_d.NB.Winter.mad = mad(oce.max_d(oce.region == 2 & oce.season == 2),1);
stats.max_d.NB.Winter.min = min(oce.max_d(oce.region == 2 & oce.season == 2));
stats.max_d.NB.Winter.max = max(oce.max_d(oce.region == 2 & oce.season == 2));

stats.max_d.NB.Spring.median = median(oce.max_d(oce.region == 2 & oce.season == 3),'omitnan');
stats.max_d.NB.Spring.mad = mad(oce.max_d(oce.region == 2 & oce.season == 3),1);
stats.max_d.NB.Spring.min = min(oce.max_d(oce.region == 2 & oce.season == 3));
stats.max_d.NB.Spring.max = max(oce.max_d(oce.region == 2 & oce.season == 3));

stats.max_d.NB.Summer.median = median(oce.max_d(oce.region == 2 & oce.season == 4),'omitnan');
stats.max_d.NB.Summer.mad = mad(oce.max_d(oce.region == 2 & oce.season == 4),1);
stats.max_d.NB.Summer.min = min(oce.max_d(oce.region == 2 & oce.season == 4));
stats.max_d.NB.Summer.max = max(oce.max_d(oce.region == 2 & oce.season == 4));

stats.max_d.CI.Fall.median = median(oce.max_d(oce.region == 3 & oce.season == 1),'omitnan');
stats.max_d.CI.Fall.mad = mad(oce.max_d(oce.region == 3 & oce.season == 1),1);
stats.max_d.CI.Fall.min = min(oce.max_d(oce.region == 3 & oce.season == 1));
stats.max_d.CI.Fall.max = max(oce.max_d(oce.region == 3 & oce.season == 1));

stats.max_d.CI.Winter.median = median(oce.max_d(oce.region == 3 & oce.season == 2),'omitnan');
stats.max_d.CI.Winter.mad = mad(oce.max_d(oce.region == 3 & oce.season == 2),1);
stats.max_d.CI.Winter.min = min(oce.max_d(oce.region == 3 & oce.season == 2));
stats.max_d.CI.Winter.max = max(oce.max_d(oce.region == 3 & oce.season == 2));

stats.max_d.CI.Spring.median = median(oce.max_d(oce.region == 3 & oce.season == 3),'omitnan');
stats.max_d.CI.Spring.mad = mad(oce.max_d(oce.region == 3 & oce.season == 3),1);
stats.max_d.CI.Spring.min = min(oce.max_d(oce.region == 3 & oce.season == 3));
stats.max_d.CI.Spring.max = max(oce.max_d(oce.region == 3 & oce.season == 3));

stats.max_d.CI.Summer.median = median(oce.max_d(oce.region == 3 & oce.season == 4),'omitnan');
stats.max_d.CI.Summer.mad = mad(oce.max_d(oce.region == 3 & oce.season == 4),1);
stats.max_d.CI.Summer.min = min(oce.max_d(oce.region == 3 & oce.season == 4));
stats.max_d.CI.Summer.max = max(oce.max_d(oce.region == 3 & oce.season == 4));

stats.max_d.Med.Fall.median = median(oce.max_d(oce.region == 4 & oce.season == 1),'omitnan');
stats.max_d.Med.Fall.mad = mad(oce.max_d(oce.region == 4 & oce.season == 1),1);
stats.max_d.Med.Fall.min = min(oce.max_d(oce.region == 4 & oce.season == 1));
stats.max_d.Med.Fall.max = max(oce.max_d(oce.region == 4 & oce.season == 1));

stats.max_d.Med.Winter.median = median(oce.max_d(oce.region == 4 & oce.season == 2),'omitnan');
stats.max_d.Med.Winter.mad = mad(oce.max_d(oce.region == 4 & oce.season == 2),1);
stats.max_d.Med.Winter.min = min(oce.max_d(oce.region == 4 & oce.season == 2));
stats.max_d.Med.Winter.max = max(oce.max_d(oce.region == 4 & oce.season == 2));

stats.max_d.Med.Spring.median = median(oce.max_d(oce.region == 4 & oce.season == 3),'omitnan');
stats.max_d.Med.Spring.mad = mad(oce.max_d(oce.region == 4 & oce.season == 3),1);
stats.max_d.Med.Spring.min = min(oce.max_d(oce.region == 4 & oce.season == 3));
stats.max_d.Med.Spring.max = max(oce.max_d(oce.region == 4 & oce.season == 3));

stats.max_d.Med.Summer.median = median(oce.max_d(oce.region == 4 & oce.season == 4),'omitnan');
stats.max_d.Med.Summer.mad = mad(oce.max_d(oce.region == 4 & oce.season == 4),1);
stats.max_d.Med.Summer.min = min(oce.max_d(oce.region == 4 & oce.season == 4));
stats.max_d.Med.Summer.max = max(oce.max_d(oce.region == 4 & oce.season == 4));

stats.max_d.WEB.Fall.median = median(oce.max_d(oce.region == 5 & oce.season == 1),'omitnan');
stats.max_d.WEB.Fall.mad = mad(oce.max_d(oce.region == 5 & oce.season == 1),1);
stats.max_d.WEB.Fall.min = min(oce.max_d(oce.region == 5 & oce.season == 1));
stats.max_d.WEB.Fall.max = max(oce.max_d(oce.region == 5 & oce.season == 1));

stats.max_d.WEB.Winter.median = median(oce.max_d(oce.region == 5 & oce.season == 2),'omitnan');
stats.max_d.WEB.Winter.mad = mad(oce.max_d(oce.region == 5 & oce.season == 2),1);
stats.max_d.WEB.Winter.min = min(oce.max_d(oce.region == 5 & oce.season == 2));
stats.max_d.WEB.Winter.max = max(oce.max_d(oce.region == 5 & oce.season == 2));

stats.max_d.WEB.Spring.median = median(oce.max_d(oce.region == 5 & oce.season == 3),'omitnan');
stats.max_d.WEB.Spring.mad = mad(oce.max_d(oce.region == 5 & oce.season == 3),1);
stats.max_d.WEB.Spring.min = min(oce.max_d(oce.region == 5 & oce.season == 3));
stats.max_d.WEB.Spring.max = max(oce.max_d(oce.region == 5 & oce.season == 3));

stats.max_d.WEB.Summer.median = median(oce.max_d(oce.region == 5 & oce.season == 4),'omitnan');
stats.max_d.WEB.Summer.mad = mad(oce.max_d(oce.region == 5 & oce.season == 4),1);
stats.max_d.WEB.Summer.min = min(oce.max_d(oce.region == 5 & oce.season == 4));
stats.max_d.WEB.Summer.max = max(oce.max_d(oce.region == 5 & oce.season == 4));

stats.max_d.Migratory.Fall.median = median(oce.max_d(oce.region == 0 & oce.season == 1),'omitnan');
stats.max_d.Migratory.Fall.mad = mad(oce.max_d(oce.region == 0 & oce.season == 1),1);
stats.max_d.Migratory.Fall.min = min(oce.max_d(oce.region == 0 & oce.season == 1));
stats.max_d.Migratory.Fall.max = max(oce.max_d(oce.region == 0 & oce.season == 1));

stats.max_d.Migratory.Winter.median = median(oce.max_d(oce.region == 0 & oce.season == 2),'omitnan');
stats.max_d.Migratory.Winter.mad = mad(oce.max_d(oce.region == 0 & oce.season == 2),1);
stats.max_d.Migratory.Winter.min = min(oce.max_d(oce.region == 0 & oce.season == 2));
stats.max_d.Migratory.Winter.max = max(oce.max_d(oce.region == 0 & oce.season == 2));

stats.max_d.Migratory.Spring.median = median(oce.max_d(oce.region == 0 & oce.season == 3),'omitnan');
stats.max_d.Migratory.Spring.mad = mad(oce.max_d(oce.region == 0 & oce.season == 3),1);
stats.max_d.Migratory.Spring.min = min(oce.max_d(oce.region == 0 & oce.season == 3));
stats.max_d.Migratory.Spring.max = max(oce.max_d(oce.region == 0 & oce.season == 3));

stats.max_d.Migratory.Summer.median = median(oce.max_d(oce.region == 0 & oce.season == 4),'omitnan');
stats.max_d.Migratory.Summer.mad = mad(oce.max_d(oce.region == 0 & oce.season == 4),1);
stats.max_d.Migratory.Summer.min = min(oce.max_d(oce.region == 0 & oce.season == 4));
stats.max_d.Migratory.Summer.max = max(oce.max_d(oce.region == 0 & oce.season == 4));

%% N

stats.N.Nordic.Fall = length(oce.max_d(oce.region == 1 & oce.season == 1));
stats.N.Nordic.Winter = length(oce.max_d(oce.region == 1 & oce.season == 2));
stats.N.Nordic.Spring = length(oce.max_d(oce.region == 1 & oce.season == 3));
stats.N.Nordic.Summer = length(oce.max_d(oce.region == 1 & oce.season == 4));

stats.N.NB.Fall = length(oce.max_d(oce.region == 2 & oce.season == 1));
stats.N.NB.Winter = length(oce.max_d(oce.region == 2 & oce.season == 2));
stats.N.NB.Spring = length(oce.max_d(oce.region == 2 & oce.season == 3));
stats.N.NB.Summer = length(oce.max_d(oce.region == 2 & oce.season == 4));

stats.N.CI.Fall = length(oce.max_d(oce.region == 3 & oce.season == 1));
stats.N.CI.Winter = length(oce.max_d(oce.region == 3 & oce.season == 2));
stats.N.CI.Spring = length(oce.max_d(oce.region == 3 & oce.season == 3));
stats.N.CI.Summer = length(oce.max_d(oce.region == 3 & oce.season == 4));

stats.N.Med.Fall = length(oce.max_d(oce.region == 4 & oce.season == 1));
stats.N.Med.Winter = length(oce.max_d(oce.region == 4 & oce.season == 2));
stats.N.Med.Spring = length(oce.max_d(oce.region == 4 & oce.season == 3));
stats.N.Med.Summer = length(oce.max_d(oce.region == 4 & oce.season == 4));

stats.N.WEB.Fall = length(oce.max_d(oce.region == 5 & oce.season == 1));
stats.N.WEB.Winter = length(oce.max_d(oce.region == 5 & oce.season == 2));
stats.N.WEB.Spring = length(oce.max_d(oce.region == 5 & oce.season == 3));
stats.N.WEB.Summer = length(oce.max_d(oce.region == 5 & oce.season == 4));

stats.N.Migratory.Fall = length(oce.max_d(oce.region == 0 & oce.season == 1));
stats.N.Migratory.Winter = length(oce.max_d(oce.region == 0 & oce.season == 2));
stats.N.Migratory.Spring = length(oce.max_d(oce.region == 0 & oce.season == 3));
stats.N.Migratory.Summer = length(oce.max_d(oce.region == 0 & oce.season == 4));

%% Kruskal-Wallis

[~,~,tmp] = kruskalwallis(oce.mld,oce.region);
figure; c = multcompare(tmp);
stats.mld.p_hotspot = c(:,[1:2 6]);
close all

[~,~,tmp] = kruskalwallis(oce.t_at_mld,oce.region);
figure; c = multcompare(tmp);
stats.t_at_mld.p_hotspot = c(:,[1:2 6]);
close all

[~,~,tmp] = kruskalwallis(oce.sst,oce.region);
figure; c = multcompare(tmp);
stats.sst.p_hotspot = c(:,[1:2 6]);
close all

[~,~,tmp] = kruskalwallis(oce.mld,oce.season);
figure; c = multcompare(tmp);
stats.mld.p_season = c(:,[1:2 6]);
close all

[~,~,tmp] = kruskalwallis(oce.t_at_mld,oce.season);
figure; c = multcompare(tmp);
stats.t_at_mld.p_season = c(:,[1:2 6]);
close all

oce.ind = [];
for i = 1:length(oce.mld)
    if oce.region(i) == 1 && oce.season(i) == 1
        oce.ind(i) = 1;
    elseif oce.region(i) == 1 && oce.season(i) == 2
        oce.ind(i) = 2;
    elseif oce.region(i) == 1 && oce.season(i) == 3
        oce.ind(i) = 3;
    elseif oce.region(i) == 1 && oce.season(i) == 4
        oce.ind(i) = 4;
    elseif oce.region(i) == 2 && oce.season(i) == 1
        oce.ind(i) = 5;
    elseif oce.region(i) == 2 && oce.season(i) == 2
        oce.ind(i) = 6;
    elseif oce.region(i) == 2 && oce.season(i) == 3
        oce.ind(i) = 7;
    elseif oce.region(i) == 2 && oce.season(i) == 4
        oce.ind(i) = 8;
    elseif oce.region(i) == 3 && oce.season(i) == 1
        oce.ind(i) = 9;
    elseif oce.region(i) == 3 && oce.season(i) == 2
        oce.ind(i) = 10;
    elseif oce.region(i) == 3 && oce.season(i) == 3
        oce.ind(i) = 11;
    elseif oce.region(i) == 3 && oce.season(i) == 4
        oce.ind(i) = 12;
    elseif oce.region(i) == 4 && oce.season(i) == 1
        oce.ind(i) = 13;
    elseif oce.region(i) == 4 && oce.season(i) == 2
        oce.ind(i) = 14;
    elseif oce.region(i) == 4 && oce.season(i) == 3
        oce.ind(i) = 15;
    elseif oce.region(i) == 4 && oce.season(i) == 4
        oce.ind(i) = 16;
    elseif oce.region(i) == 5 && oce.season(i) == 1
        oce.ind(i) = 17;
    elseif oce.region(i) == 5 && oce.season(i) == 2
        oce.ind(i) = 18;
    elseif oce.region(i) == 5 && oce.season(i) == 3
        oce.ind(i) = 19;
    elseif oce.region(i) == 5 && oce.season(i) == 4
        oce.ind(i) = 20;
    elseif oce.region(i) == 0 && oce.season(i) == 1
        oce.ind(i) = 21;
    elseif oce.region(i) == 0 && oce.season(i) == 2
        oce.ind(i) = 22;
    elseif oce.region(i) == 0 && oce.season(i) == 3
        oce.ind(i) = 23;
    elseif oce.region(i) == 0 && oce.season(i) == 4
        oce.ind(i) = 24;
    end
end
clear i

[~,~,tmp] = kruskalwallis(oce.mld,oce.ind);
figure; c = multcompare(tmp);
stats.mld.p_hotspot_and_season = c(:,[1:2 6]);
close all

[~,~,tmp] = kruskalwallis(oce.t_at_mld,oce.ind);
figure; c = multcompare(tmp);
stats.t_at_mld.p_hotspot_and_season = c(:,[1:2 6]);
close all

clear tmp
clear c