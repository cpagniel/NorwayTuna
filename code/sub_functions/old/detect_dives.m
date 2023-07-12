%% detect_dives.m

%% Create list of TOPP IDs.

toppID = unique(PSAT.TOPPID);

%% Set constants for dive detection.

PARAMS.d_noise = 5; % meters, set values less than 5 m to 0 m
PARAMS.prm = [15 5]; % prominence of local minimums and maximums

%% Detect dives.

dives = struct([]);

for i = 1:length(toppID)

    tmp = PSAT(PSAT.TOPPID == toppID(i),:);

    %% Find Local Maximums
    % Duplicate depth column to be used for dive detection and remove noise from
    % when the animal is at the surface by setting all values less than 5 m (PARAMS.d_noise
    % to 0 m). This will be repeated before detecting local minimums.

    % Find all local maximums whose prominence is at least 15, but only keep local
    % maximums that are deeper than 25% of the maximum depth during a 4 hour period
    % around when the measurement is made.

    tmp = addvars(tmp,tmp.Depth,'Before','LightLevel','NewVariableNames','DepthDet');
    tmp.DepthDet(tmp.DepthDet <= PARAMS.d_noise) = 0;

    pks.initial = islocalmax(tmp.DepthDet,'MinProminence',PARAMS.prm(2)); % output is a logical

    M = movmax(tmp.DepthDet,4/hours(tmp.DateTime(2)-tmp.DateTime(1))); % maximum depth in a 4 hour window
    tmp.DepthDet(pks.initial ~= 1) = NaN;
    pks.initial = tmp.DepthDet >= 0.25*M;

    pks.initial = find(pks.initial == 1); % get indices where there are peaks

    tmp = removevars(tmp,'DepthDet');

    %% Find Local Minimums
    % Find all local minimums whose prominence at least 15, but only keep local
    % minimums that are shallower than 35% of the maximum depth during a 4 hour period
    % around when the measurement is made.
    
    % Because we set values of 5 m or less to 0, there will be profiles with flat
    % sections near the surface (i.e., periods of time when the animal was at 5 m
    % or less will look like extended times are the surface). We want the location
    % of the points at the start and end of these flat sections. Hence why islocalmin
    % is computed twice below, once to find the first point in the flat section and
    % once to find the last point in the flat section of the profile.

    tmp = addvars(tmp,tmp.Depth,'Before','LightLevel','NewVariableNames','DepthDet');
    tmp.DepthDet(tmp.DepthDet <= PARAMS.d_noise) = 0;

    vls.first = islocalmin(tmp.DepthDet,'MinProminence',PARAMS.prm(1),'FlatSelection','first');
    vls.last = islocalmin(tmp.DepthDet,'MinProminence',PARAMS.prm(1),'FlatSelection','last');
    vls.initial = vls.first + vls.last;
    vls.initial = vls.initial >= 1;

    tmp.DepthDet(vls.initial ~= 1) = NaN;
    vls.initial = tmp.DepthDet <= 0.50*M;

    vls.initial = find(vls.initial == 1);

    tmp = removevars(tmp,'DepthDet');

    clear M

    %% Find Times and Depths Associated with all Local Extremums
    % Also retrieve indices of local maximums and minmums and create binary index
    % equal to 1 when there is a peak and zero when there is a valley. Sort all vectors
    % by time.

    pks.time = [tmp.DateTime(pks.initial); tmp.DateTime(vls.initial)];
    pks.depth = [tmp.Depth(pks.initial); tmp.Depth(vls.initial)];

    pks.index = [pks.initial; vls.initial]; % indices of local maximums and minimums
    pks.binary = [ones(length(pks.initial),1); zeros(length(vls.initial),1)]; % set local maximums to 1 and minimums to 0

    [~,ind] = sort(pks.index);

    pks.time = pks.time(ind);
    pks.depth = pks.depth(ind);
    pks.index = pks.index(ind);
    pks.binary = pks.binary(ind);

    clear ind

    %% Remove Adjacent Local Maximums (i.e., adjacent 1s).

    pks.ind = [];
    j = 1;
    while j < length(pks.binary)
        if pks.binary(j) == 1
            t = find(pks.binary(j+1:end) == 0,1);
            [~,im] = max(pks.depth(j:t+j-1));
            pks.ind = [pks.ind; im+j-1];
            j = t+j;
        else
            j = j+1;
        end
    end
    clear j
    clear im
    clear t

    %% Find Times and Depths Associated with Non-Adjacent Local Maximums and All Local Minimums
    % Also retrieve indices of local maximums and minmums and create binary index
    % equal to 1 when there is a peak and zero when there is a valley. Sort all vectors
    % by time.

    pks.len = length(pks.depth(pks.ind));

    vls.time = [pks.time(pks.ind); tmp.DateTime(vls.initial)];
    vls.depth = [pks.depth(pks.ind); tmp.Depth(vls.initial)];

    vls.index = [pks.index(pks.ind); vls.initial];
    vls.binary = [ones(pks.len,1); zeros(length(vls.initial),1)];

    [~,ind] = sort(vls.index);

    vls.time = vls.time(ind);
    vls.depth = vls.depth(ind);
    vls.index = vls.index(ind);
    vls.binary = vls.binary(ind);

    clear ind

    %% Remove Adjacent Local Minimums (i.e., adjacents 0s).

    vls.ind = [];
    for j = 2:length(vls.binary)-1
        if vls.binary(j) == 0
            if vls.binary(j+1) == 1 || vls.binary(j-1) == 1
                vls.ind = [vls.ind; j];
            end
        end
    end
    clear j

    %% Finalize Start and End Indices of Each Dive

    vls.len = length(vls.depth(vls.ind));

    dives(i).time = [pks.time(pks.ind); vls.time(vls.ind)];
    dives(i).depth = [pks.depth(pks.ind); vls.depth(vls.ind)];

    dives(i).index = [pks.index(pks.ind); vls.index(vls.ind)];
    dives(i).binary = [ones(pks.len,1); zeros(vls.len,1)];

    clear pks vls

    [~,ind] = sort(dives(i).index);

    dives(i).time = dives(i).time(ind);
    dives(i).depth = dives(i).depth(ind);
    dives(i).index = dives(i).index(ind);
    dives(i).binary = dives(i).binary(ind);

    clear ind

    clear tmp

end
clear i