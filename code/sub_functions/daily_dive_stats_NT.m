%% daily_dive_stats_NT.m
% Sub-function of Norway_Tuna; computes daily dive statistics.

%% Get toppIDs.

toppID = unique(B.dives.toppID);

%% Compute number of dives per day.

SSM.DivesPerDay = NaN(height(SSM),1);

for i = 1:height(SSM)
    if ismember(SSM.TOPPID(i),toppID)

        ind_time = find(B.dives.day == SSM.Date(i));
        ind_topp = find(B.dives.toppID == SSM.TOPPID(i));

        ind = intersect(ind_time,ind_topp);

        SSM.DivesPerDay(i) = length(ind);

    end
end
clear i
clear ind*

%% Compute daily max diving depth.

tmp = groupsummary(PSAT,{'TOPPID','Date'},'max','Depth');
tmp = removevars(tmp,'GroupCount');

SSM = outerjoin(SSM,tmp,'keys',[1 2],'MergeKeys',true);

clear tmp

%% Compute daily median diving depth.

tmp = groupsummary(PSAT,{'TOPPID','Date'},'median','Depth');
tmp = removevars(tmp,'GroupCount');

SSM = outerjoin(SSM,tmp,'keys',[1 2],'MergeKeys',true);

clear tmp

%% Compute night median diving depth.

tmp = groupsummary(PSAT,{'TOPPID','Date','DayNight'},'median','Depth');
tmp = removevars(tmp,'GroupCount');
tmp = tmp(tmp.DayNight == 0,:);
tmp.Properties.VariableNames{4} = 'median_Depth_night';
tmp(:,3) = [];

SSM = outerjoin(SSM,tmp,'keys',[1 2],'MergeKeys',true);

clear tmp

%% Compute day median diving depth.

tmp = groupsummary(PSAT,{'TOPPID','Date','DayNight'},'median','Depth');
tmp = removevars(tmp,'GroupCount');
tmp = tmp(tmp.DayNight == 1,:);
tmp.Properties.VariableNames{4} = 'median_Depth_day';
tmp(:,3) = [];

SSM = outerjoin(SSM,tmp,'keys',[1 2],'MergeKeys',true);

clear tmp

%% Compute daily time in mesopelagic.

SSM.TimeinMeso = NaN(height(SSM),1);

for i = 1:height(SSM)
    disp(i)
    if ismember(SSM.TOPPID(i),toppID)
        if sum(PSAT.TOPPID == SSM.TOPPID(i) & PSAT.Date == SSM.Date(i)) == 17280

            ind_time = find(PSAT.Date == SSM.Date(i));
            ind_topp = find(PSAT.TOPPID == SSM.TOPPID(i));

            ind = intersect(ind_time,ind_topp);

            SSM.TimeinMeso(i) = sum((PSAT.Depth(ind) >= 200))/17280*100;

        end
    end
end
clear i
clear ind*