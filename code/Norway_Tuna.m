%% Norway Tuna %%
% The following runs code to process, analyze and plot data related to 
% tag deployments on tuna from Norway.
%
% Author: Camille Pagniello, Stanford University (cpagniel@stanford.edu)
% 
% Last Update: 07/11/2023

%% Requirements

warning off

fdir = '/Users/cpagniello/Library/CloudStorage/GoogleDrive-cpagniel@stanford.edu/My Drive/Projects/NorwayTuna';

%% Load Data

run load_meta_NT
run load_SSM_NT

%% Define Hotspots

% 1 = Norwegian Sea
% 2 = North Sea
% 3 = Coastal Ireland
% 4 = Newfoundland Basin
% 5 = Canary Islands
% 6 = Mediterranean
% 7 = West European Basin
% 8 = Bay of Biscay
% 9 = Outside

% regions.NwS.bndry = [-1.15 -3.23 -13.5007 -9.06 22 6 -1.15; 60.8608 58.61 64.97 69.7 69.7 60.8608 60.8608];
% regions.NoS.bndry = [1.78 -3.23 -0.81 6 10.74 12.9375 1.78; 50.9672 58.61 60.8608 60.8608 59.94 56.46 50.9672];
% regions.CoI.bndry = [-16 -16 -6 -6 -9.2957 -16; 52 60 60 50 50 52];
% regions.NB.bndry = [-33 -50 -44 -33 -33; 39 39 52 52 39];
% regions.CaI.bndry = [-21.9904 -21.9904 -9.8127 -9.8127 -21.9904; 24.5847 34.2891 34.2891 24.5847 24.5847];
% % regions.CaI.bndry = [-20.6197 -20.6197 -11.77 -5.4745 -16.87 -20.6197; 15 30 33.1989 33.1989 15 15];
% regions.Med.bndry = [-5.61 -5.61 5 22 22 -5.61; 30 40 46 46 30 30];
% regions.WEB.bndry = [-16 -16 -9.2957 -9.2957 -16; 42.92 52 50 42.92 42.92];
% % regions.WEB.bndry = [-23 -23 -16 -9.2957 -9.2957 -23; 36.99 52 52 50 36.99 36.99];
% regions.BB.bndry = [-9.2957 -9.2957 0.2 0.2 -9.2957; 42.92 50 50 42.92 42.92];
% 
% SSM.Region = ones(length(SSM.Latitude),1)*9;
% SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.NwS.bndry(1,:),regions.NwS.bndry(2,:))) = 1;
% SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.NoS.bndry(1,:),regions.NoS.bndry(2,:))) = 2;
% SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.CoI.bndry(1,:),regions.CoI.bndry(2,:))) = 3;
% SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 4;
% SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.CaI.bndry(1,:),regions.CaI.bndry(2,:))) = 5;
% SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 6;
% SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 7;
% SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.BB.bndry(1,:),regions.BB.bndry(2,:))) = 8;
% 
% cmap.regions = [...
%     240 2 127;...
%     191 91 23;...
%     127 201 127;...
%     56 108 176;...
%     166 206 227;...
%     253 192 134;...
%     190 174 212;...
%     255 255 153;...
%     128 128 128]./256;

%% Load Tag Data

run load_archive_NT

%% Identification of Oceanographic Provinces

run daily_TD_profiles_NT


%% Residency Statistics

run stats_NT

%% Plot Geographic Maps

run plot_overview_map_NT
run plot_bin_map_NT
run plot_seasonal_map_NT
run plot_individual_tracks_NT

%% Mixed Layear Depth

run calc_mld_NT

%% Vertical Diving Behavior

run detect_dives_NT

%% Plot Timeseries

run plot_timeseries_NT
run plot_pdt_NT
run plot_TaD_NT
run plot_meso_NT
run plot_mean_max_daily_depth_map_NT
run plot_median_daynight_depth_map_NT
run plot_TaT_NT

