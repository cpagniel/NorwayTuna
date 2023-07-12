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