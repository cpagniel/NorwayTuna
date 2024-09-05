%% stats_NT.m
% Sub-function of Norway_Tuna.m; computes statistics on time in high
% density areas.

% Including Norwegian EEZ, Canary Islands, Mediterranean, West European Basin and Newfoundland Basin

%% Tags to Omit As They are Less than 364 Days

toppIDs_omit = META.TOPPID(META.DeploymentDuration < 364);
toppIDs_omit = [toppIDs_omit; 5122081; 5122091; 5122087]; % omit because it was caught in trap in Med

%% Number of Days in Each Hotspot

stats.daysperhotspot.Counts = groupcounts(SSM,{'TOPPID','Region'},'IncludeEmptyGroups',true);

% Norwegian EEZ

% # of days
id = stats.daysperhotspot.Counts.TOPPID(stats.daysperhotspot.Counts.Region == 1);
t = stats.daysperhotspot.Counts.GroupCount(stats.daysperhotspot.Counts.Region == 1);
stats.daysperhotspot.Nordic.nodays.mean = mean(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.Nordic.nodays.std = std(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.Nordic.nodays.min = min(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.Nordic.nodays.max = max(t(~ismember(id,toppIDs_omit)));

% % of total deployment
d = groupcounts(SSM,'TOPPID');
stats.daysperhotspot.Nordic.prctdays.mean = mean((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.Nordic.prctdays.std = std((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.Nordic.prctdays.min = min((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.Nordic.prctdays.max = max((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);

clear t

% Newfoundland Basin

% # of days
id = stats.daysperhotspot.Counts.TOPPID(stats.daysperhotspot.Counts.Region == 2);
t = stats.daysperhotspot.Counts.GroupCount(stats.daysperhotspot.Counts.Region == 2);
stats.daysperhotspot.NB.nodays.mean = mean(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.NB.nodays.std = std(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.NB.nodays.min = min(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.NB.nodays.max = max(t(~ismember(id,toppIDs_omit)));

% % of total deployment
stats.daysperhotspot.NB.prctdays.mean = mean((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.NB.prctdays.std = std((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.NB.prctdays.min = min((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.NB.prctdays.max = max((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);

clear t

% Canary Islands

% # of days
id = stats.daysperhotspot.Counts.TOPPID(stats.daysperhotspot.Counts.Region == 3);
t = stats.daysperhotspot.Counts.GroupCount(stats.daysperhotspot.Counts.Region == 3);
stats.daysperhotspot.CI.nodays.mean = mean(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.CI.nodays.std = std(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.CI.nodays.min = min(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.CI.nodays.max = max(t(~ismember(id,toppIDs_omit)));

% % of total deployment
stats.daysperhotspot.CI.prctdays.mean = mean((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.CI.prctdays.std = std((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.CI.prctdays.min = min((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.CI.prctdays.max = max((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);

clear t

% Med

% # of days
id = stats.daysperhotspot.Counts.TOPPID(stats.daysperhotspot.Counts.Region == 4);
t = stats.daysperhotspot.Counts.GroupCount(stats.daysperhotspot.Counts.Region == 4);
stats.daysperhotspot.Med.nodays.mean = mean(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.Med.nodays.std = std(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.Med.nodays.min = min(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.Med.nodays.max = max(t(~ismember(id,toppIDs_omit)));

% % of total deployment
stats.daysperhotspot.Med.prctdays.mean = mean((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.Med.prctdays.std = std((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.Med.prctdays.min = min((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.Med.prctdays.max = max((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);

clear t

% WEB

% # of days
id = stats.daysperhotspot.Counts.TOPPID(stats.daysperhotspot.Counts.Region == 5);
t = stats.daysperhotspot.Counts.GroupCount(stats.daysperhotspot.Counts.Region == 5);
stats.daysperhotspot.WEB.nodays.mean = mean(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.WEB.nodays.std = std(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.WEB.nodays.min = min(t(~ismember(id,toppIDs_omit)));
stats.daysperhotspot.WEB.nodays.max = max(t(~ismember(id,toppIDs_omit)));

% % of total deployment
stats.daysperhotspot.WEB.prctdays.mean = mean((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.WEB.prctdays.std = std((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.WEB.prctdays.min = min((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);
stats.daysperhotspot.WEB.prctdays.max = max((t(~ismember(id,toppIDs_omit))./d.GroupCount((~ismember(id,toppIDs_omit))))*100);

clear t
clear d
clear id

%% First and Last Date in Hotspots

toppIDs = unique(SSM.TOPPID);

stats.dates.Nordic.out = [];
stats.dates.NB.in = [];
stats.dates.NB.out = [];
stats.dates.WEB.in = [];
stats.dates.WEB.out = [];
stats.dates.CI.in = [];
stats.dates.CI.out = [];
stats.dates.Med.in = [];
stats.dates.Med.out = [];
stats.dates.Nordic.in = [];

cnt = 0;
for i = 1:length(toppIDs)

    % if ~ismember(toppIDs(i),toppIDs_omit)
        cnt = cnt + 1;

        tmp = SSM(SSM.TOPPID == toppIDs(i),:);
        ind = find(ischange(tmp.Region)); % get indices where the region changes

        f = tmp.Region(ind-1); % from Region
        t = tmp.Region(ind); % to Region

        ind2 = ind(f == 1 & t == 0); % Nordic to Migratory
        if length(ind2) > 1 % to account for any back and forth along the border
            d = tmp.Date(ind2);
            d = max(d(year(d) == year(tmp.Date(1)))); % must be within the same year as tag deployment
        else
            d = tmp.Date(ind2);
        end
        stats.dates.Nordic.out = [stats.dates.Nordic.out; d];
        clear ind2
        clear d

        ind2 = ind(f == 0 & t == 2); % Migratory to NB
        if length(ind2) > 1 % to account for any back and forth along the border
            d = min(tmp.Date(ind2)); % take first day as entry date
        else
            d = tmp.Date(ind2);
        end
        if ~isempty(d)
            stats.dates.NB.in = [stats.dates.NB.in; d];
        else
            stats.dates.NB.in = [stats.dates.NB.in; datetime(9999,9,9)];
        end
        clear ind2
        clear d

        if stats.dates.NB.in(cnt) ~= datetime(9999,9,9)
            ind2 = ind(f == 2 & t == 0); % NB to Migratory
            if length(ind2) > 1 % to account for any back and forth along the border
                d = max(tmp.Date(ind2)); % take last day as exit date
            else
                d = tmp.Date(ind2);
            end
            if ~isempty(d)
                stats.dates.NB.out = [stats.dates.NB.out; d];
            else
                stats.dates.NB.out = [stats.dates.NB.out; datetime(9999,9,9)];
            end
        else
            stats.dates.NB.out = [stats.dates.NB.out; datetime(9999,9,9)];
        end
        clear ind2
        clear d

        if stats.dates.NB.out(cnt) ~= datetime(9999,9,9)
            ind2 = ind(f == 0 & t == 5); % NB to Migratory to WEB
            if length(ind2) > 1 % to account for any back and forth along the border
                [~,d] = min(abs(tmp.Date(ind2) - stats.dates.NB.out(cnt))); % take date closest to NB exit
                d = tmp.Date(ind2(d));
            else
                d = tmp.Date(ind2);
            end
            if month(d) >= 7 % if date is in July, this is return from the Med
                stats.dates.WEB.in = [stats.dates.WEB.in; datetime(9999,9,9)];
            elseif ~isempty(d)
                stats.dates.WEB.in = [stats.dates.WEB.in; d];
            else
                stats.dates.WEB.in = [stats.dates.WEB.in; datetime(9999,9,9)];
            end
            clear ind2
            clear d
        else
            stats.dates.WEB.in = [stats.dates.WEB.in; datetime(9999,9,9)];
        end

        if stats.dates.WEB.in(cnt) ~= datetime(9999,9,9)
            ind2 = ind(f == 5 & t == 0); % WEB to Migratory
            if length(ind2) > 1 % to account for any back and forth along the border
                d = month(tmp.Date(ind2)) < 7; % take dates before July
                d = max(tmp.Date(ind2(d)));
            else
                d = tmp.Date(ind2);
            end
            if ~isempty(d)
                stats.dates.WEB.out = [stats.dates.WEB.out; d];
            else
                stats.dates.WEB.out = [stats.dates.WEB.out; datetime(9999,9,9)];
            end
        else
            stats.dates.WEB.out = [stats.dates.WEB.out; datetime(9999,9,9)];
        end
        clear ind2
        clear d

        if stats.dates.WEB.in(cnt) == datetime(9999,9,9)
            ind2 = ind(f == 0 & t == 3); % NB to Migratory to Canaries
            if length(ind2) > 1 % to account for any back and forth along the border
                [~,d] = min(abs(tmp.Date(ind2) - stats.dates.NB.out(cnt))); % take date closest to NB exit
                d = tmp.Date(ind2(d));
            else
                d = tmp.Date(ind2);
            end
            if ~isempty(d)
                stats.dates.CI.in = [stats.dates.CI.in; d];
            else
                stats.dates.CI.in = [stats.dates.CI.in; datetime(9999,9,9)];
            end
            clear ind2
            clear d
        elseif stats.dates.NB.in(cnt) == datetime(9999,9,9)
            ind2 = ind(f == 0 & t == 3); % Norway to Migratory to Canaries
            if length(ind2) > 1 % to account for any back and forth along the border
                d = min(tmp.Date(ind2));
            else
                d = tmp.Date(ind2);
            end
            if ~isempty(d)
                stats.dates.CI.in = [stats.dates.CI.in; d];
            else
                stats.dates.CI.in = [stats.dates.CI.in; datetime(9999,9,9)];
            end
            clear ind2
            clear d
        else
            stats.dates.CI.in = [stats.dates.CI.in; datetime(9999,9,9)];
        end

        if stats.dates.CI.in(cnt) ~= datetime(9999,9,9)
            ind2 = ind(f == 3 & t == 0); % Canaries to Migratory to Med
            if length(ind2) > 1 % to account for any back and forth along the border
                d = max(tmp.Date(ind2)); % take lastest date out of Canaries
            else
                d = tmp.Date(ind2);
            end
            if ~isempty(d)
                stats.dates.CI.out = [stats.dates.CI.out; d];
            else
                stats.dates.CI.out = [stats.dates.CI.out; datetime(9999,9,9)];
            end
            clear ind2
            clear d
        else
            stats.dates.CI.out = [stats.dates.CI.out; datetime(9999,9,9)];
        end

        ind2 = ind(f == 0 & t == 4); % Migratory to Med
        if length(ind2) > 1 % to account for any back and forth along the border
            d = tmp.Date(ind2);
            d = min(d(year(d) == year(tmp.Date(end)))); % must be within the second year of tag deployment
        else
            d = tmp.Date(ind2);
        end
        if ~isempty(d)
                stats.dates.Med.in = [stats.dates.Med.in; d];
            else
                stats.dates.Med.in = [stats.dates.Med.in; datetime(9999,9,9)];
        end
        clear ind2
        clear d

        ind2 = ind(f == 4 & t == 0); % Med to Migratory
        if length(ind2) > 1 % to account for any back and forth along the border
            d = tmp.Date(ind2);
            d = max(d(year(d) == year(tmp.Date(end)))); % must be within the second year of tag deployment
        else
            d = tmp.Date(ind2);
        end
        if ~isempty(d)
                stats.dates.Med.out = [stats.dates.Med.out; d];
            else
                stats.dates.Med.out = [stats.dates.Med.out; datetime(9999,9,9)];
        end
        clear ind2
        clear d

        ind2 = ind(f == 0 & t == 1); % Migratory to Nordic
        if length(ind2) > 1 % to account for any back and forth along the border
            d = tmp.Date(ind2);
            d = min(d(year(d) == year(tmp.Date(end)))); % must be within the second year of tag deployment
        else
            d = tmp.Date(ind2);
        end
        if ~isempty(d)
            stats.dates.Nordic.in = [stats.dates.Nordic.in; d];
        else
            stats.dates.Nordic.in = [stats.dates.Nordic.in; datetime(9999,9,9)];
        end
        clear ind2
        clear d

    % end

    clear tmp
    clear t
    clear f
    clear ind

end
clear i
clear cnt

% toppIDs(ismember(toppIDs,toppIDs_omit)) = [];

%% Clear

clear toppIDs
clear toppIDs_omit