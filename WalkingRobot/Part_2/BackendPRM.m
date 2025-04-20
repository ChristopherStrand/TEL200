function found_paths = BackendPRM(PRM_dots, desired_paths)
    % --------- User Settings -----------
    load house_no_gaps.mat house; % Map to use
    %desired_paths = 1;      % Amount of paths to generate
    %PRM_dots = 300;         % Number of dots to generate
    rng_seed = 42; % Completed seeds: 42, 43, 44
    % --------- User Settings -----------
    
    if exist('rng_seed', 'var')
        rng(rng_seed);  % Set the random number generator seed if rng_seed is defined
    end
    function query_path = generate_path(map, prm) 
        % Generate start and end points
        x_1 = randi(397);
        y_1 = randi(596);
        x_2 = randi(397);
        y_2 = randi(596);
        
        start = map(x_1, y_1);
        goal = map(x_2, y_2);
        
        while (start+goal) > 0
            % Generates new start and end point if they touch an occupied space
            % Free space = 0
            % Occupied space = 1
            if start == 1
                disp("New start coordinate generated")
                x_1 = randi(397);
                y_1 = randi(596);
                start = map(x_1, y_1);
            end
            if goal == 1
                disp("New goal coordinate generated")
                x_2 = randi(397);
                y_2 = randi(596);
                goal = map(x_2, y_2);
            end
        end
        query_path = prm.query([x_1 y_1], [x_2 y_2]);
    end
    
    % --------- Planning phase -----------
    disp("Generating PRM... ")
    if PRM_dots > 250
        disp("Warning large number of PRM dots! This may take some time")
    end
    prm = PRM(house);
    prm.plan('npoints', PRM_dots);
    % --------- Planning phase -----------
    
    % --------- Query phase -----------
    paths = 1;
    found_paths = {desired_paths};
    prm.plot(); % Plots PRM dots and map
    hold on

    while paths <= desired_paths % Runs until the desired amount of paths have been found
        try
            found_paths{paths} = generate_path(house, prm);
            current_found_path = found_paths{paths};
            
            % ----------- Plot paths -----------
            plot(current_found_path(:, 1), current_found_path(:,2), '-', 'Color', [rand rand rand], 'LineWidth', 2);
            plot(current_found_path(1, 1), current_found_path(1, 2), 'go', 'MarkerSize', 10);
            plot(current_found_path(end, 1), current_found_path(end, 2),  'ro', 'MarkerSize', 10);
            % ----------- Plot paths -----------

            paths = paths + 1;
            disp("Successfully found a path!")
        catch
            % Bad practice, but I couldnt get try catch to work in matlab
        end
    end
    hold off
    % --------- Query phase -----------
end
