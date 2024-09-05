%% load_meta_NT.m
% Sub-function of Norway_Tuna.m; loads metadata for all tags.

%% Go To Folder

cd([fdir '/data/meta']);

%% Load MetaData

META = readtable("Table_1.xlsx");
META.Properties.VariableNames = {'TOPPID' 'PSAT' 'TagginDate' ,...
    'ReleaseTime' 'TaggingLatitudeN' 'TaggingLongitudeE' 'CFL_cm' 'PopUpDate',...
    'PopUpLatitudeN' 'PopUpLongitudeE' 'DeploymentDuration' 'Status' 'Reason'};

%% Set pop-up date to capture date for 21P2007 and 21P0045.

ind = find(contains(META.PSAT,'21P2007'));
META.PopUpDate(ind) = datetime(year(META.PopUpDate(ind)),5,30);

ind = find(contains(META.PSAT,'21P0045'));
META.PopUpDate(ind) = datetime(year(META.PopUpDate(ind)),6,10);