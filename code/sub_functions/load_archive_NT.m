%% load_archive_NT
% Sub-function of Norway_Tuna.m; loads data from recovered tags.

%% Go to folder.

cd([fdir '/data/archival/DC']);

%% Get list of files.

files = dir('*DC.csv');

%% Loop through files.

for i = 1:length(files)

    disp(i)

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

        % 0 = Migratory Pathways
        % 1 = Norwegian EEZ (formely Nordic Waters)
        % 2 = Newfoundland Basin
        % 3 = Canary Islands
        % 4 = Mediterranean Sea
        % 5 = West European Basin

        PSAT.Region = zeros(height(PSAT.TOPPID),1);

        test.Nordic = regions.Nordic(:,[12437:17000 12437]);
        ind = find(month(PSAT.Date) >= 6 & month(PSAT.Date) <= 11 & PSAT.Latitude >= min(regions.Nordic(2,:)) & PSAT.Longitude >= min(regions.Nordic(1,:)) & PSAT.Longitude <= max(regions.Nordic(1,:)));
        inp = inpolygon(PSAT.Longitude(ind),PSAT.Latitude(ind),test.Nordic(1,:),test.Nordic(2,:));        
        PSAT.Region(ind(inp)) = 1;
        % PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.Nordic(1,:),regions.Nordic(2,:))) = 1;

        PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.NB(1,:),regions.NB(2,:))) = 2;
        PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.CI(1,:),regions.CI(2,:))) = 3;
        PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.Med(1,:),regions.Med(2,:))) = 4;
        PSAT.Region(inpolygon(PSAT.Longitude,PSAT.Latitude,regions.WEB(1,:),regions.WEB(2,:))) = 5;

        clear ind
        clear inp
        clear test

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

        % 0 = Migratory Pathways
        % 1 = Nordic Waters
        % 2 = Newfoundland Basin
        % 3 = Canary Islands
        % 4 = Mediterranean Sea
        % 5 = West European Basin

        tmp.Region = zeros(height(tmp.TOPPID),1);

        test.Nordic = regions.Nordic(:,[12437:17000 12437]);
        ind = find(month(tmp.Date) >= 6 & month(tmp.Date) <= 11 & tmp.Latitude >= min(regions.Nordic(2,:)) & tmp.Longitude >= min(regions.Nordic(1,:)) & tmp.Longitude <= max(regions.Nordic(1,:)));
        inp = inpolygon(tmp.Longitude(ind),tmp.Latitude(ind),test.Nordic(1,:),test.Nordic(2,:));        
        tmp.Region(ind(inp)) = 1; 
        % tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.Nordic(1,:),regions.Nordic(2,:))) = 1;

        tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.NB(1,:),regions.NB(2,:))) = 2;
        tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.CI(1,:),regions.CI(2,:))) = 3;
        tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.Med(1,:),regions.Med(2,:))) = 4;
        tmp.Region(inpolygon(tmp.Longitude,tmp.Latitude,regions.WEB(1,:),regions.WEB(2,:))) = 5;

        clear ind
        clear inp
        clear test

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