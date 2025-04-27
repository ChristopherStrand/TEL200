import RobotMovementPRMSupport.*;
import BackendPRM.*;

hold on
%{
Warning! Before running this code make sure to
add Part_1 and Part_2 to your path.

WalkingPRM handles all code related to making and plotting paths. Currently
supports only plotting the latest generated path. Inside the WalkingPRM
file you can set a custom seed and load a different map. 
WalkingPRM has two parameters:
    - Amount of dots (Large numbers take a lot of time)
    - Amount of paths to generate
WalkingPRM outputs all paths generated
%}
paths = BackendPRM(200, 1); % Handles PRM plotting

% The robot expects a reverse z-axis se we reverse the z-axis of the PRM
% plot
set(gca, 'Zdir', 'reverse'); 

%{
WalkingClassPRM is an version of walkingClassPrivateCoords adjusted for use
in plotting on top of a different plot. By calling robot_animate you
can manually move the robot forward or turn it.
Example:
W1 = walkingClassPrivateCoords(500, "nah", false);
W1.robot_animate(@W1.turn, 90); 
W1.robot_animate(@W1.move, 100);

The robot can also follow a generated path automatically by calling follow.
Follow takes a single path of any size then moves the
robot to each point in the path. The robot is teleported from the end 
of the previous path to the next path's starting point.
Example:
W1 = walkingClassPRM(250, "movie_test.mp4", false); % Handles robot movement
W1.follow(my_paths);
%}

% Example for how to make a robot object and then follow a generated path
W1 = RobotMovementPRMSupport(10, "movie_test.mp4", false); % Handles robot movement
for path = paths 
    W1.follow(path);
end