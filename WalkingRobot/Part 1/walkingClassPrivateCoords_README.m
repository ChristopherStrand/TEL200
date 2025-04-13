% How to use example
import walkingClassPrivateCoords.*;
% niterations, name of generated video, generate video true/false
W1 = walkingClassPrivateCoords(500, "nah", false);
% W1.robot_animate(function, degrees/centimeters)
W1.robot_animate(@W1.turn, 90); 
W1.robot_animate(@W1.move, 100);