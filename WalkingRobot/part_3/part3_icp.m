function part3_icp(poseGraph)
    scans = scanxy(poseGraph);
    N = length(scans);
    poses = zeros(N, 3);
    poses(1,:) = [0, 0, 0];

    for i = 2:N
        prev_scan = scans{i-1}';
        curr_scan = scans{i}';

        try
            [T, ~] = icp(prev_scan, curr_scan, 20);

            dx = T(1,3);
            dy = T(2,3);
            dtheta = atan2(T(2,1), T(1,1));

            prev_pose = poses(i-1,:);
            new_x = prev_pose(1) + dx*cos(prev_pose(3)) - dy*sin(prev_pose(3));
            new_y = prev_pose(2) + dx*sin(prev_pose(3)) + dy*cos(prev_pose(3));
            new_theta = prev_pose(3) + dtheta;

            poses(i,:) = [new_x, new_y, new_theta];
        catch
            poses(i,:) = poses(i-1,:);
        end
    end

    % Tegn robotbanen
    figure;
    plot(poses(:,1), poses(:,2), 'b.-');
    title('Estimert robotbane med ICP');
    xlabel('x'); ylabel('y');
    axis equal;
end