%% Norway Tuna %%
% The following runs code to process, analyze and plot data related to 
% tag deployments on tuna from Norway.
%
% If running from raw data, please run Load Data and Load Tag Data cells.
% Else, start at Calculate Environmental Properties cell.
%
% Author: Camille Pagniello, Stanford University (cpagniel@stanford.edu)
% 
% Last Update: 01/24/2024

%% Requirements

warning off

fdir = '/Users/cpagniello/Library/CloudStorage/GoogleDrive-cpagniel@stanford.edu/My Drive/Projects/NorwayTuna';

%% Load Data

run load_meta_NT
run load_SSM_NT

%% Load Tag Data

run load_archive_NT

%% Calculate Environmental Properties

% Table S4 to S10
run calc_MLD_SST_etc_NT 

tmp = table(oce.toppID.',oce.t.',oce.mld.',oce.t_at_mld.',oce.sst.','VariableNames',{'toppID','Date','MLD_m','T_at_MLD_degC','SST_degC'});
SSM = outerjoin(SSM,tmp,'keys',[1 2],'MergeKeys',true);
SSM.Properties.VariableNames{1} = 'TOPPID';

clear tmp

%% Vertical Diving Behavior

run detect_dives_NT
run daily_dive_stats_NT

tmp = table(oce.toppID.',oce.t.',oce.mld.',oce.t_at_mld.',oce.sst.','VariableNames',{'toppID','day','MLD_m','T_at_MLD_degC','SST_degC'});
B.dives = movevars(B.dives, 'day', 'Before', 'index');
B.dives = outerjoin(B.dives,tmp,'keys',[1 2],'MergeKeys',true);

clear tmp

%% Main Figures

% Figure 1
run plot_overview_map_NT
run plot_seasonal_map_v2_NT
run plot_bin_map_NT

% Figure 2
% see outputs of plot_individual_tracks_NT

% Figure 3
run plot_seasonal_habitat_envelopes_NT

% Figure 4
run plot_example_NT

% Figure 5
run plot_horizontal_speed_map_NT
run plot_daily_dive_frequency_map_NT
run plot_dive_duration_map_NT
run plot_dive_descent_rate_map_NT
run plot_median_daynight_depth_map_NT
run plot_daily_max_depth_map_NT
run plot_time_in_mesopelagic_map_NT

%% Main Tables

% Table 1
run calc_corr_coeff_NT

%% Supplementary Figures and Tables

% Figure S1
run plot_frequency_distributions_NT

% Figure S2
run plot_seasonal_map_NT

% Panels for Figures S3 to S7
run plot_individual_tracks_NT
run plot_timeseries_NT

% Figure S8
run plot_TaD_NT.m 

% Figure S9
run plot_TaT_NT.m

% Figure S10
run plot_boxplots_hotspot_NT

% Figure S11
run plot_boxplots_season_NT.m

% Figure S12
run plot_corr_MLD_NT

% Figure S13
run plot_corr_T_at_MLD_NT

% Figure S14
run plot_daylength_hotspot_NT.m

% Table S1
run calc_hotspot_residency_NT 