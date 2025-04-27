% How to use example
import RobotMovementClassPrivateCoords.*;
% niterations, name of generated video, generate video true/false
W1 = RobotMovementClassPrivateCoords(500, "nah", false);
% W1.robot_animate(function, degrees/centimeters)
W1.robot_animate(@W1.turn, 45); 
W1.robot_animate(@W1.move, 100);