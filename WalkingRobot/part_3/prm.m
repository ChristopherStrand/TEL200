function prm()
    load KillianMap
    prm = PRM(KillianMap);              
    prm.plan('npoints', 500);            

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
                path_count = path_count + 1;
            end
        catch
            disp('inside wall');
        end
    end
end

function path = planroute(prm, map, x_start, y_start, x_stop, y_stop, color)
    path = [];

    if map(y_start, x_start) ~= 0 || map(y_stop, x_stop) ~= 0
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