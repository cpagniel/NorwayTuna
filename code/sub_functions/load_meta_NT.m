%% load_meta_NT.m
% Sub-function of Norway_Tuna.m; loads metadata for all tags.

%% Go To Folder

cd([fdir '/data/meta']);

%% Load MetaData

META = readtable("Table_1.xlsx");
META.Properties.VariableNames = {'TOPPID' 'PSAT' 'TagginDate' ,...
    'ReleaseTime' 'TaggingLatitudeN' 'TaggingLongitudeE' 'CFL_cm' 'PopUpDate',...
    'PopUpLatitudeN' 'PopUpLongitudeE' 'DeploymentDuration' 'Status' 'Reason'};
