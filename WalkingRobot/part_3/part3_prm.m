function part2()
    s = load('KillianMap.mat');
    house = s.KillianMap;

    prm = PRM(house);
    prm.plan('npoints', 5000, 'distthresh', 30);

    figure;
    imshow(house == 0);
    colors = rand(10, 3); 
    hold on;
    paths = {};
    path_count = 1;

    [free_y, free_x] = find(house == 0);

    for k = 1:10
        try
            idx_start = randi(length(free_x));
            idx_stop  = randi(length(free_x));

            x_start = free_x(idx_start);
            y_start = free_y(idx_start);
            x_stop  = free_x(idx_stop);
            y_stop  = free_y(idx_stop);

            path = planroute(prm, house, x_start, y_start, x_stop, y_stop, colors(k, :));
            if ~isempty(path)
                paths{path_count} = path;
                path_count = path_count + 1;
            end
        catch
            disp('inside wall');
        end
    end
end

function path = planroute(prm, house, x_start, y_start, x_stop, y_stop, color)
    path = [];

    if house(y_start, x_start) ~= 0 || house(y_stop, x_stop) ~= 0
        disp('inside a wall');
        return
    end

    start = [x_start, y_start];
    stop  = [x_stop,  y_stop];
    path = prm.query(start, stop);

    if isempty(path)
        return
    end

    plot(path(:,1), path(:,2), '-', 'Color', color, 'LineWidth', 2);
    plot(start(1), start(2), 'go', 'MarkerSize', 10);
    plot(stop(1),  stop(2),  'ro', 'MarkerSize', 10);
end