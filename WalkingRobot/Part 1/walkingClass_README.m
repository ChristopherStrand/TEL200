% How to use example
import walkingClass.*;
% niterations, name of generated video, generate video true/false
W1 = walkingClass(500, "nah", false);
% W1.robot_animate(function, degrees/centimeters)
W1.robot_animate(@W1.turn, 10); 
W1.robot_animate(@W1.move, 100);