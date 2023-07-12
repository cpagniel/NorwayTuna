%% load_archive_NT
% Sub-function of Norway_Tuna.m; loads data from recovered tags.

%% Go to folder.

cd([fdir '/data/archival/DC']);

%% Get list of files.

files = dir('*DC.csv');

%% Loop through files.

for i = 1:length(files)

    if i == 1

        %% Load data.

        PSAT = readtable(files(i).name);
        PSAT = PSAT(:,[3:4 6 8:13]);

        PSAT.Properties.VariableNames = {'Depth' 'LightLevel' 'Temperature',...
            'Year' 'Month' 'Day' 'Hour' 'Min' 'Sec'};

        PSAT.DateTime = datetime(PSAT.Year,PSAT.Month,PSAT.Day,...
            PSAT.Hour,PSAT.Min,PSAT.Sec);
        PSAT(:,4:9) = [];
        PSAT = movevars(PSAT, 'DateTime', 'Before', 'Depth');

        PSAT.Date = datetime(year(PSAT.DateTime),month(PSAT.DateTime),day(PSAT.DateTime));
        PSAT = movevars(PSAT, 'Date', 'Before', 'Depth');

        TOPPID = str2double(files(i).name(1:7))*ones(size(PSAT,1),1);
        PSAT = addvars(PSAT,TOPPID,'Before','DateTime');

        %% Interpolate SSM positions to match PSAT data.

        PSAT.Longitude = interp1(datenum(SSM.Date(SSM.TOPPID == TOPPID(1))),...
            SSM.Longitude(SSM.TOPPID == TOPPID(1)),datenum(PSAT.DateTime));

        PSAT.Latitude = interp1(datenum(SSM.Date(SSM.TOPPID == TOPPID(1))),...
            SSM.Latitude(SSM.TOPPID == TOPPID(1)),datenum(PSAT.DateTime));

        %% Determine season.

        % 1 = Fall which includes September, October and November.
        % 2 = Winter which includes December, January and February.
        % 3 = Spring which includes March, April and May.
        % 4 = Summer which includes June, July and August.

        PSAT.Season = zeros(length(PSAT.Latitude),1);
        PSAT.Season(month(PSAT.DateTime) == 9 | month(PSAT.DateTime) == 10 | month(PSAT.DateTime) == 11) = 1;
        PSAT.Season(month(PSAT.DateTime) == 12 | month(PSAT.DateTime) == 1 | month(PSAT.DateTime) == 2) = 2;
        PSAT.Season(month(PSAT.DateTime) == 3 | month(PSAT.DateTime) == 4 | month(PSAT.DateTime) == 5) = 3;
        PSAT.Season(month(PSAT.DateTime) == 6 | month(PSAT.DateTime) == 7 | month(PSAT.DateTime) == 8) = 4;

        %% Determine hotspot.

%         PSAT.Region = ones(length(PSAT.Latitude),1)*9;
%         PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.NwS.bndry(1,:),regions.NwS.bndry(2,:))) = 1;
%         PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.NoS.bndry(1,:),regions.NoS.bndry(2,:))) = 2;
%         PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.CoI.bndry(1,:),regions.CoI.bndry(2,:))) = 3;
%         PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 4;
%         PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.CaI.bndry(1,:),regions.CaI.bndry(2,:))) = 5;
%         PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 6;
%         PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 7;
%         PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.BB.bndry(1,:),regions.BB.bndry(2,:))) = 8;

        %% Remove data after pop-up date.

        PSAT(PSAT.Date > META.PopUpDate(META.TOPPID == TOPPID(1)),:) = [];

    else

        %% Load data.

        tmp = readtable(files(i).name);
        tmp = tmp(:,[3:4 6 8:13]);

        tmp.Properties.VariableNames = {'Depth' 'LightLevel' 'Temperature',...
            'Year' 'Month' 'Day' 'Hour' 'Min' 'Sec'};

        tmp.DateTime = datetime(tmp.Year,tmp.Month,tmp.Day,...
            tmp.Hour,tmp.Min,tmp.Sec);
        tmp(:,4:9) = [];
        tmp = movevars(tmp, 'DateTime', 'Before', 'Depth');

        tmp.Date = datetime(year(tmp.DateTime),month(tmp.DateTime),day(tmp.DateTime));
        tmp = movevars(tmp, 'Date', 'Before', 'Depth');

        TOPPID = str2double(files(i).name(1:7))*ones(size(tmp,1),1);
        tmp = addvars(tmp,TOPPID,'Before','DateTime');

        %% Interpolate SSM positions to match PSAT data.

        tmp.Longitude = interp1(datenum(SSM.Date(SSM.TOPPID == TOPPID(1))),...
            SSM.Longitude(SSM.TOPPID == TOPPID(1)),datenum(tmp.DateTime));

        tmp.Latitude = interp1(datenum(SSM.Date(SSM.TOPPID == TOPPID(1))),...
            SSM.Latitude(SSM.TOPPID == TOPPID(1)),datenum(tmp.DateTime));

        %% Determine season.

        tmp.Season = zeros(length(tmp.Latitude),1);
        tmp.Season(month(tmp.DateTime) == 9 | month(tmp.DateTime) == 10 | month(tmp.DateTime) == 11) = 1;
        tmp.Season(month(tmp.DateTime) == 12 | month(tmp.DateTime) == 1 | month(tmp.DateTime) == 2) = 2;
        tmp.Season(month(tmp.DateTime) == 3 | month(tmp.DateTime) == 4 | month(tmp.DateTime) == 5) = 3;
        tmp.Season(month(tmp.DateTime) == 6 | month(tmp.DateTime) == 7 | month(tmp.DateTime) == 8) = 4;

        %% Determine hotspot.

%         tmp.Region = ones(length(tmp.Latitude),1)*9;
%         tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.NwS.bndry(1,:),regions.NwS.bndry(2,:))) = 1;
%         tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.NoS.bndry(1,:),regions.NoS.bndry(2,:))) = 2;
%         tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.CoI.bndry(1,:),regions.CoI.bndry(2,:))) = 3;
%         tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 4;
%         tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.CaI.bndry(1,:),regions.CaI.bndry(2,:))) = 5;
%         tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 6;
%         tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 7;
%         tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.BB.bndry(1,:),regions.BB.bndry(2,:))) = 8;

        %% Remove data after pop-up date.

        tmp(tmp.Date > META.PopUpDate(META.TOPPID == TOPPID(1)),:) = [];

        %% Combine tables.

        PSAT = [PSAT; tmp];

        clear tmp
    end

    clear TOPPID

end
clear i

clear files

%% Find sunrise and sunset time to determine if observation is day or night.

[SRISE,SSET] = sunrise(PSAT.Latitude,PSAT.Longitude,0,0,PSAT.DateTime);
PSAT.DayNight = zeros(height(PSAT),1);
PSAT.DayNight(PSAT.DateTime > datetime(SRISE,'ConvertFrom','datenum') & PSAT.DateTime < datetime(SSET,'ConvertFrom','datenum')) = 1;

clear SRISE
clear SSET