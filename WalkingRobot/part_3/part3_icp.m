function part3_icp()
    % Load pose graph
    pg = PoseGraph('killian.g2o', 'laser');  
    occgrid = pg.scanmap();   
    pg.plot_occgrid(occgrid);   
    figure;  
    hold on;

    % Initialize pose variables
    %for each round
    x = 0; 
    y = 0; 
    theta = 0;

    %lists off all
    X = x;
    Y = y; 
    THETA = theta;
    time = pg.time(1);
    success = 0;
    no = 0;
    
    % Loop through all scan data (3873 scans = 3872 pose changes)
    for i = 1:3872
        % i , i+1 (timestep) 
        p1 = pg.scanxy(i);
        p2 = pg.scanxy(i+1);

        try
            % transforms between p1 and p2 using icp and gets the
            % trandslations and rotation for the tranformation. 
            T = icp(p1, p2, 'verbose', false, 'T0', transl2(0.5, 0), 'distthresh', 3);
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
            THETA(end+1) = theta;
            time(end+1) = pg.time(i+1); 
            success = success + 1; 
        catch
            %returns old pose if fail
            X(end+1) = x;
            Y(end+1) = y;
            THETA(end+1) = theta;
            time(end+1) = pg.time(i+1) - pg.time(i); 
            no = no + 1;
        end
    end
    %plots alle the trajectories over time
    subplot(3,1,1);
    plot(time, X, 'b');
    xlabel('tid [s]');
    ylabel('x-posisjon');

    subplot(3,1,2);
    plot(time, Y, 'r');
    xlabel('tid [s]');
    ylabel('y-posisjon');

    subplot(3,1,3);
    plot(time, THETA, 'g');
    xlabel('tid [s]');
    ylabel('\theta (rad)');

    disp(success)
    disp(no)
end
