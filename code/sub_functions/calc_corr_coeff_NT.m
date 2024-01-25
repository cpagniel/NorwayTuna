%% corr_dive_env_NT.m
% Compute Spearman's Rank Correlation Coefficient between dive metrics and
% environmental properties as well as between dive metrics themselves.

% Daily Dive Frequency
% Dive Duration
% Descent Rate
% Median Day Depth
% Median Night Depth
% Daily Max Dpeth
% Time in Mesopelagic

% Latitude
% MLD
% Temperature @ MLD

%% Bin Environmental Properties

binned.LONedges = -80:1:40;
binned.LATedges = 15:1:70;

[binned.mz,binned.LONmid,binned.LATmid] = twodmed(SSM.Longitude,SSM.Latitude,...
        SSM.MLD_m,binned.LONedges,binned.LATedges);
bins.MLD = binned.mz.';

[binned.mz,binned.LONmid,binned.LATmid] = twodmed(SSM.Longitude,SSM.Latitude,...
        SSM.T_at_MLD_degC,binned.LONedges,binned.LATedges);
bins.T_at_MLD = binned.mz.';

bins.Latitude = repmat(binned.LATmid.',[120 1]);
bins.Longitude = repmat(binned.LONmid,[1 55]);

clear binned

bins_NAs = bins;

%% Remove NaNs

ind = (isnan(bins.speed)+isnan(bins.daily_dive_f)+isnan(bins.duration)+...
    isnan(bins.descent_rate)+isnan(bins.median_depth_day)+isnan(bins.median_depth_night)+...
    isnan(bins.daily_max_d)+isnan(bins.time_in_meso)+isnan(bins.MLD)+...
    isnan(bins.T_at_MLD)+isnan(bins.Latitude)+isnan(bins.Longitude)) >= 1;

bins.speed = bins.speed(~ind);
bins.daily_dive_f = bins.daily_dive_f(~ind);
bins.duration = bins.duration(~ind);
bins.descent_rate = bins.descent_rate(~ind);
bins.median_depth_day = bins.median_depth_day(~ind);
bins.median_depth_night = bins.median_depth_night(~ind);
bins.daily_max_d = bins.daily_max_d(~ind);
bins.time_in_meso = bins.time_in_meso(~ind);
bins.MLD = bins.MLD(~ind);
bins.T_at_MLD = bins.T_at_MLD(~ind);
bins.Latitude = bins.Latitude(~ind);
bins.Longitude = bins.Longitude(~ind);

clear ind

%% Spearman's Rank Correlation Coefficient

% Dive Frequency
[stats.corr.rho.diveF_vs_Ddur,stats.corr.p.diveF_vs_Ddur] = corr(bins.daily_dive_f,bins.duration);
[stats.corr.rho.diveF_vs_desR,stats.corr.p.diveF_vs_desR] = corr(bins.daily_dive_f,bins.descent_rate);
[stats.corr.rho.diveF_vs_medDay,stats.corr.p.diveF_vs_medDay] = corr(bins.daily_dive_f,bins.median_depth_day);
[stats.corr.rho.diveF_vs_medNight,stats.corr.p.diveF_vs_medNight] = corr(bins.daily_dive_f,bins.median_depth_night);
[stats.corr.rho.diveF_vs_maxD,stats.corr.p.diveF_vs_maxD] = corr(bins.daily_dive_f,bins.daily_max_d);
[stats.corr.rho.diveF_vs_timeM,stats.corr.p.diveF_vs_timeM] = corr(bins.daily_dive_f,bins.time_in_meso);
[stats.corr.rho.diveF_vs_MLD,stats.corr.p.diveF_vs_MLD] = corr(bins.daily_dive_f,bins.MLD);
[stats.corr.rho.diveF_vs_Tmld,stats.corr.p.diveF_vs_Tmld] = corr(bins.daily_dive_f,bins.T_at_MLD);
[stats.corr.rho.diveF_vs_lat,stats.corr.p.diveF_vs_lat] = corr(bins.daily_dive_f,bins.Latitude);

% Dive Duration
[stats.corr.rho.Ddur_vs_desR,stats.corr.p.Ddur_vs_desR] = corr(bins.duration,bins.descent_rate);
[stats.corr.rho.Ddur_vs_medDay,stats.corr.p.Ddur_vs_medDay] = corr(bins.duration,bins.median_depth_day);
[stats.corr.rho.Ddur_vs_medNight,stats.corr.p.Ddur_vs_medNight] = corr(bins.duration,bins.median_depth_night);
[stats.corr.rho.Ddur_vs_maxD,stats.corr.p.Ddur_vs_maxD] = corr(bins.duration,bins.daily_max_d);
[stats.corr.rho.Ddur_vs_timeM,stats.corr.p.Ddur_vs_timeM] = corr(bins.duration,bins.time_in_meso);
[stats.corr.rho.Ddur_vs_MLD,stats.corr.p.Ddur_vs_MLD] = corr(bins.duration,bins.MLD);
[stats.corr.rho.Ddur_vs_Tmld,stats.corr.p.Ddur_vs_Tmld] = corr(bins.duration,bins.T_at_MLD);
[stats.corr.rho.Ddur_vs_lat,stats.corr.p.Ddur_vs_lat] = corr(bins.duration,bins.Latitude);


% Descent Rate
[stats.corr.rho.desR_vs_medDay,stats.corr.p.desR_vs_medDay] = corr(bins.descent_rate,bins.median_depth_day);
[stats.corr.rho.desR_vs_medNight,stats.corr.p.desR_vs_medNight] = corr(bins.descent_rate,bins.median_depth_night);
[stats.corr.rho.desR_vs_maxD,stats.corr.p.desR_vs_maxD] = corr(bins.descent_rate,bins.daily_max_d);
[stats.corr.rho.desR_vs_timeM,stats.corr.p.desR_vs_timeM] = corr(bins.descent_rate,bins.time_in_meso);
[stats.corr.rho.desR_vs_MLD,stats.corr.p.desR_vs_MLD] = corr(bins.descent_rate,bins.MLD);
[stats.corr.rho.desR_vs_Tmld,stats.corr.p.desR_vs_Tmld] = corr(bins.descent_rate,bins.T_at_MLD);
[stats.corr.rho.desR_vs_lat,stats.corr.p.desR_vs_lat] = corr(bins.descent_rate,bins.Latitude);

% Median Day Depth
[stats.corr.rho.medDay_vs_medNight,stats.corr.p.medDay_vs_medNight] = corr(bins.median_depth_day,bins.median_depth_night);
[stats.corr.rho.medDay_vs_maxD,stats.corr.p.medDay_vs_maxD] = corr(bins.median_depth_day,bins.daily_max_d);
[stats.corr.rho.medDay_vs_timeM,stats.corr.p.medDay_vs_timeM] = corr(bins.median_depth_day,bins.time_in_meso);
[stats.corr.rho.medDay_vs_MLD,stats.corr.p.medDay_vs_MLD] = corr(bins.median_depth_day,bins.MLD);
[stats.corr.rho.medDay_vs_Tmld,stats.corr.p.medDay_vs_Tmld] = corr(bins.median_depth_day,bins.T_at_MLD);
[stats.corr.rho.medDay_vs_lat,stats.corr.p.medDay_vs_lat] = corr(bins.median_depth_day,bins.Latitude);

% Median Night Depth
[stats.corr.rho.medNight_vs_maxD,stats.corr.p.medNight_vs_maxD] = corr(bins.median_depth_night,bins.daily_max_d);
[stats.corr.rho.medNight_vs_timeM,stats.corr.p.medNight_vs_timeM] = corr(bins.median_depth_night,bins.time_in_meso);
[stats.corr.rho.medNight_vs_MLD,stats.corr.p.medNight_vs_MLD] = corr(bins.median_depth_night,bins.MLD);
[stats.corr.rho.medNight_vs_Tmld,stats.corr.p.medNight_vs_Tmld] = corr(bins.median_depth_night,bins.T_at_MLD);
[stats.corr.rho.medNight_vs_lat,stats.corr.p.medNight_vs_lat] = corr(bins.median_depth_night,bins.Latitude);

% Daily Maximum Depth
[stats.corr.rho.maxD_vs_timeM,stats.corr.p.maxD_vs_timeM] = corr(bins.daily_max_d,bins.time_in_meso);
[stats.corr.rho.maxD_vs_MLD,stats.corr.p.maxD_vs_MLD] = corr(bins.daily_max_d,bins.MLD);
[stats.corr.rho.maxD_vs_Tmld,stats.corr.p.maxD_vs_Tmld] = corr(bins.daily_max_d,bins.T_at_MLD);
[stats.corr.rho.maxD_vs_lat,stats.corr.p.maxD_vs_lat] = corr(bins.daily_max_d,bins.Latitude);

% Time in Mesopelagic
[stats.corr.rho.timeM_vs_MLD,stats.corr.p.timeM_vs_MLD] = corr(bins.time_in_meso,bins.MLD);
[stats.corr.rho.timeM_vs_Tmld,stats.corr.p.timeM_vs_Tmld] = corr(bins.time_in_meso,bins.T_at_MLD);
[stats.corr.rho.timeM_vs_lat,stats.corr.p.timeM_vs_lat] = corr(bins.time_in_meso,bins.Latitude);

% MLD
[stats.corr.rho.MLD_vs_Tmld,stats.corr.p.MLD_vs_Tmld] = corr(bins.MLD,bins.T_at_MLD);
[stats.corr.rho.MLD_vs_lat,stats.corr.p.MLD_vs_lat] = corr(bins.MLD,bins.Latitude);

% T at MLD
[stats.corr.rho.Tmld_vs_lat,stats.corr.p.Tmld_vs_lat] = corr(bins.T_at_MLD,bins.Latitude);

%% Determine Hotspot of Each Observation

bins.hotspot = zeros(height(bins.MLD),1);
bins.hotspot(inpolygon(bins.Longitude,bins.Latitude,regions.Nordic(1,:),regions.Nordic(2,:))) = 1;
bins.hotspot(inpolygon(bins.Longitude,bins.Latitude,regions.NB(1,:),regions.NB(2,:))) = 2;
bins.hotspot(inpolygon(bins.Longitude,bins.Latitude,regions.CI(1,:),regions.CI(2,:))) = 3;
bins.hotspot(inpolygon(bins.Longitude,bins.Latitude,regions.Med(1,:),regions.Med(2,:))) = 4;
bins.hotspot(inpolygon(bins.Longitude,bins.Latitude,regions.WEB(1,:),regions.WEB(2,:))) = 5;