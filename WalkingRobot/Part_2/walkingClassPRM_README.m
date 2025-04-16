import walkingClassPRM.*;
import WalkingPRM.*;

hold on
my_paths = WalkingPRM(200, 1);
% Reverse z-axis on prm plot
% Needs to be placed after PRM has been generated
set(gca, 'Zdir', 'reverse'); 

% Example for how to make a robot object and then follow a generated path
W1 = walkingClassPRM(250, "movie_test.mp4", false);
W1.follow(my_paths);