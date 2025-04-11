% --------- User Settings -----------
load house_no_gaps.mat; % Map to use
desired_paths = 2;      % Amount of paths to generate
PRM_dots = 500;         % Number of dots to generate
% --------- User Settings -----------

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
hold off
%plot(generate_path(house, prm));
while paths <= desired_paths % Runs until the desired amount of paths have been found
    try
        generate_path(house, prm);
        figure(paths) % Allows multiple images to show up
        prm.plot() % Plots query on the map
        paths = paths + 1;
        disp("Successfully found a path!")
    catch
        % Bad practice, but I couldnt get try catch to work in matlab
    end
end
hold on
% --------- Query phase -----------

