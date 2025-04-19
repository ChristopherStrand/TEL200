function part3_prm()
    s = load('KillianMap.mat');
    KillianMap = s.KillianMap;
    prm = PRM(KillianMap);
    prm.plan('npoints', 500, 'distthresh', 30);
    figure;
    imshow(KillianMap == 0);
    colors = rand(10, 3); 
    hold on;
    paths = {};
    path_count = 1;

    for k = 1:10
        try
            x_start = randi([1, size(KillianMap, 2)]);
            y_start = randi([1, size(KillianMap, 1)]);
            x_stop  = randi([1, size(KillianMap, 2)]);
            y_stop  = randi([1, size(KillianMap, 1)]);
            path = planroute(prm, KillianMap, x_start, y_start, x_stop, y_stop, colors(k, :));
            if ~isempty(path)
                paths{path_count} = path;
            end
        catch
            disp('inside wall');
        end
    end

    
end

function path = planroute(prm, KillianMap, x_start, y_start, x_stop, y_stop, color)
    start_point = KillianMap(y_start, x_start);
    stop_point  = KillianMap(y_stop, x_stop);
    path = [];

    if start_point ~= 0 || stop_point ~= 0
        disp('inside a wall');
        return
    end

    start = [x_start, y_start];
    stop  = [x_stop,  y_stop];
    path  = prm.query(start, stop);

    if isempty(path)
        return
    end

    plot(path(:,1), path(:,2), '-', 'Color', color, 'LineWidth', 2);
    plot(start(1), start(2), 'go', 'MarkerSize', 10);
    plot(stop(1),  stop(2),  'ro', 'MarkerSize', 10);
end