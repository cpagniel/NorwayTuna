%% load_SSM_NT.m
% Sub-function of Norway_Tuna.m; load SSM tracks.

%% Go To Folder

cd([fdir '/data/SSM']);

%% Get List of Files

files = dir('*SSM.txt');

%% Load Files

for i = 1:length(files)

    if i == 1   
        SSM = readtable(files(i).name);
        SSM = SSM(:,1:3);    
        SSM.Properties.VariableNames = {'Date' 'Longitude' 'Latitude'};

        TOPPID = str2double(files(i).name(1:7))*ones(size(SSM,1),1);
        SSM = addvars(SSM,TOPPID,'Before','Date');

        SSM.Date = datetime(year(SSM.Date),month(SSM.Date),day(SSM.Date));
        SSM(SSM.Date > META.PopUpDate(META.TOPPID == TOPPID(1)),:) = [];

    else
        tmp = readtable(files(i).name);
        tmp = tmp(:,1:3);    
        tmp.Properties.VariableNames = {'Date' 'Longitude' 'Latitude'};

        TOPPID = str2double(files(i).name(1:7))*ones(size(tmp,1),1);
        tmp = addvars(tmp,TOPPID,'Before','Date');

        tmp.Date = datetime(year(tmp.Date),month(tmp.Date),day(tmp.Date));
        tmp(tmp.Date > META.PopUpDate(META.TOPPID == TOPPID(1)),:) = [];

        SSM = [SSM; tmp];

        clear tmp
    end

    clear TOPPID

end
clear i
clear files

%% Define hotspots.

% 0 = Migratory Pathways
% 1 = Norwegian EEZ (formely Nordic Waters)
% 2 = Newfoundland Basin
% 3 = Canary Islands
% 4 = Mediterranean Sea
% 5 = West European Basin

% Nordic Waters
% regions.Nordic = [2 12 12 -6 -6 2;...
%     51 51 65 65 60 51];
cd([fdir '/data/eez'])
tmp = shaperead('eez.shp');
regions.Nordic = [tmp.X; tmp.Y];
clear tmp

% Newfoundland Basin
regions.NB = [-33,-50,-44,-33,-33;...
    39,39,52,52,39];

% Canary Islands
regions.CI = [-21 -21 -9 -9 -21;... 
    24 35 35 24 24];

% Mediterranean Sea
regions.Med = [-5.61,-5.61,5,36,36,-5.61;...
   30,40,46,46,30,30];

% West European Basin
regions.WEB = [-20 -20 -16 -9.2957 -9.2957 -20;...
    42.92 52 52 50 42.92 42.92];

SSM.Region = zeros(height(SSM.TOPPID),1);
SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.Nordic(1,:),regions.Nordic(2,:))) = 1;
SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.NB(1,:),regions.NB(2,:))) = 2;
SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.CI(1,:),regions.CI(2,:))) = 3;
SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.Med(1,:),regions.Med(2,:))) = 4;
SSM.Region(inpolygon(SSM.Longitude,SSM.Latitude,regions.WEB(1,:),regions.WEB(2,:))) = 5;

%% Determine season.

% 1 = Fall which includes September, October and November.
% 2 = Winter which includes December, January and February.
% 3 = Spring which includes March, April and May.
% 4 = Summer which includes June, July and August.

season = zeros(height(SSM),1);
season(month(SSM.Date) == 9 | month(SSM.Date) == 10 | month(SSM.Date) == 11) = 1;
season(month(SSM.Date) == 12 | month(SSM.Date) == 1 | month(SSM.Date) == 2) = 2;
season(month(SSM.Date) == 3 | month(SSM.Date) == 4 | month(SSM.Date) == 5) = 3;
season(month(SSM.Date) == 6 | month(SSM.Date) == 7 | month(SSM.Date) == 8) = 4;

SSM.Season = season;

clear season

%% Determine day length.

[SRISE,SSET] = sunrise(SSM.Latitude,SSM.Longitude,0,0,SSM.Date);
SSM.DayLength = hours(datetime(SSET,'ConvertFrom','datenum') - datetime(SRISE,'ConvertFrom','datenum'));

clear SRISE
clear SSET