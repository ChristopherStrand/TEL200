function part3_icp(pg)@
    %getting the occupancy grid map from the pose graph
    scanmap = pg.scanmap();
    figure;
    imshow(scanmap == 0);  
    hold on;

    % initializing the pose variables
    x = 0; y = 0; theta = 0;
    X = x; Y = y;

    % looping through all the scan data (3873 scans = 3872 pose changes)
    for i = 1:3872
        % i , i+1 (timestep) 
        p1 = pg.scanxy(i);
        p2 = pg.scanxy(i+1);

        try
            % transforms between p1 and p2 using icp and gets the
            % trandslations and rotation for the tranformation. 
            T = icp(p2, p1, 'verbose', false, 'T0', transl2(0.5, 0), 'distthresh', 3);
            dx = T(1,3);
            dy = T(2,3);
            dtheta = atan2(T(2,1), T(1,1));
            
            %updates the pose variables
            x = x + dx * cos(theta) - dy * sin(theta);
            y = y + dx * sin(theta) + dy * cos(theta);
            theta = theta + dtheta;
            
            %saves new pose
            X(end+1) = x;
            Y(end+1) = y;
        catch
            %returns old pose if fail
            X(end+1) = x;
            Y(end+1) = y;
        end
    end
    %plots alle the trajectories over time
    plot(X, Y, 'b.-');
    xlabel('x'); ylabel('y');
    axis equal;
end