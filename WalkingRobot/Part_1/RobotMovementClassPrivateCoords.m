% set the dimensions of the two leg links


% Copyright (C) 1993-2017, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

classdef RobotMovementClassPrivateCoords < handle
    properties
        heading_angle;
        niterations;
        movie;
        setup;
        k;
        A;
        legs;
        body;
        qcycle;
    end
    methods
        %Initialize 
        function obj = RobotMovementClassPrivateCoords(niterations, movie_name, movie_true)
            obj.heading_angle = 0;
            obj.niterations = niterations;
            if movie_true == true
                obj.movie = movie_name;
            else
                obj.movie = [];
            end
            obj.setup = obj.robot_setup();
            obj.k = obj.setup{1};
            obj.A = obj.setup{2};
            obj.legs = obj.setup{3};
            obj.body = obj.setup{4};
            obj.qcycle = obj.setup{5};

            % The body.Vertices needs to rotate once to be a 4x3 matrix.
            % Otherwise it is a 4x2 matrix which causes errors.
            obj.turn([0 0 0], 1)
            obj.turn([0 0 0], -1)
        end

        % Runs everything setup related and returns
        % setup = {k, A, legs, body};
        function setup = robot_setup(obj)
            % Offset starting positions 
            % NB! for testing purposes. Offset = 0 otherwise

            scale = 1; % Scale orginal size
            L1 = 0.1; L2 = 0.1;
            fprintf('create leg model\n');
            
            % create the leg links based on DH parameters
            %                    theta   d     a  alpha  
            links(1) = Link([    0       0    0   pi/2 ], 'standard');
            links(2) = Link([    0       0    (L1)   0   ], 'standard');
            links(3) = Link([    0       0   (-L2)   0   ], 'standard');
            
            % now create a robot to represent a single leg
            leg = SerialLink(links, 'name', 'leg', 'offset', [pi/2   0  -pi/2]);
            
            % define the key parameters of the gait trajectory, walking in the
            % x-direction
            xf = 5; xb = -xf;   % forward and backward limits for foot on ground
            y = 5;              % distance of foot from body along y-axis
            zu = 2; zd = 5;     % height of foot when up and down
            % define the rectangular path taken by the foot
            segments = [xf y zd; xb y zd; xb y zu; xf y zu] * 0.01;
            
            % build the gait. the points are:
            %   1 start of walking stroke
            %   2 end of walking stroke
            %   3 end of foot raise
            %   4 foot raised and forward
            %
            % The segments times are :
            %   1->2  3s
            %   2->3  0.5s
            %   3->4  1s
            %   4->1  0.5ss
            %
            % A total of 4s, of which 3s is walking and 1s is reset.  At 0.01s sample
            % time this is exactly 400 steps long.
            %
            % We use a finite acceleration time to get a nice smooth path, which means
            % that the foot never actually goes through any of these points.  This
            % makes setting the initial robot pose and velocity difficult.
            %
            % Intead we create a longer cyclic path: 1, 2, 3, 4, 1, 2, 3, 4. The
            % first 1->2 segment includes the initial ramp up, and the final 3->4
            % has the slow down.  However the middle 2->3->4->1 is smooth cyclic
            % motion so we "cut it out" and use it.
            fprintf('create trajectory\n');
            
            segments = [segments; segments];
            tseg = [3 0.25 0.5 0.25]';
            tseg = [tseg; tseg];
            x = mstraj(segments, [], tseg, segments(1,:), 0.01, 0.1);
            
            % pull out the cycle
            fprintf('inverse kinematics (this will take a while)...');
            xcycle = x(100:500,:);
            qcycle_set = leg.ikine( transl(xcycle), 'mask', [1 1 1 0 0 0] );
            
            % dimensions of the robot's rectangular body, width and height, the legs
            % are at each corner.
            W = 0.1; L = 0.2;
            
            % a bit of optimization.  We use a lot of plotting options to 
            % make the animation fast: turn off annotations like wrist axes, ground
            % shadow, joint axes, no smooth shading.  Rather than parse the switches 
            % each cycle we pre-digest them here into a plotopt struct.
            % plotopt = leg.plot({'noraise', 'nobase', 'noshadow', ...
            %     'nowrist', 'nojaxes'});
            % plotopt = leg.plot({'noraise', 'norender', 'nobase', 'noshadow', ...
            %     'nowrist', 'nojaxes', 'ortho'});
            
            fprintf('\nanimate\n');
            
            plotopt = {'noraise', 'nobase', 'noshadow', 'nowrist', 'nojaxes', 'delay', 0};
            
            % create 4 leg robots.  Each is a clone of the leg robot we built above,
            % has a unique name, and a base transform to represent it's position
            % on the body of the walking robot.
            legs_set(1) = SerialLink(leg, 'name', 'leg1');
            legs_set(2) = SerialLink(leg, 'name', 'leg2', 'base', transl(-L, 0, 0));
            legs_set(3) = SerialLink(leg, 'name', 'leg3', 'base', transl(-L, -W, 0)*trotz(pi));
            legs_set(4) = SerialLink(leg, 'name', 'leg4', 'base', transl(0, -W, 0)*trotz(pi));
            
            % create a fixed size axis for the robot, and set z positive downward
            clf; axis([-0.3 0.1 -0.2 0.2 -0.15 0.05]); set(gca,'Zdir', 'reverse');
            hold on
            % draw the robot's body
            body_set = patch([0 -L -L 0]*scale, [0 0 -W -W]*scale, [0 0 0 0], ...
                    'FaceColor', 'm', 'FaceAlpha', 0.5);
            % instantiate each robot in the axes
            for i=1:4
                legs_set(i).plot(qcycle_set(1,:), plotopt{:});
            end
            hold off
            % walk!
            k_set = 1;
            A_set = Animate(obj.movie);
            hold on
            setup = {k_set, A_set, legs_set, body_set, qcycle_set};
        end

        function center = find_center(obj)
            center = mean(obj.body.Vertices);
        end

        function normal_vector = normal_direction(obj, normal_vector)
            C = obj.find_center();
            P = (obj.body.Vertices(3, :)-obj.body.Vertices(2, :))/2;
            vCenter = C - P;
            product = dot(normal_vector, vCenter(1:2));
            if product > 0
                disp("Swapping normal direction...")
                normal_vector = normal_vector*-1;
            else 
                disp("Keeping normal direction...")
            end

        end

        % Motion primitives turn and move
        % Turns the robot x degree, input negative to turn anticlockwise
        function turn(obj, center, degrees)
            rotate(obj.body, [0 0 1], degrees/obj.niterations, center)
            obj.heading_angle = obj.heading_angle + degrees/obj.niterations;
            obj.legs(1).base = transl(obj.body.Vertices(1, :))*trotz(obj.heading_angle, 'deg');
            obj.legs(2).base = transl(obj.body.Vertices(2, :))*trotz(obj.heading_angle, 'deg');
            obj.legs(3).base = transl(obj.body.Vertices(3, :))*trotz(obj.heading_angle + 180, 'deg');
            obj.legs(4).base = transl(obj.body.Vertices(4, :))*trotz(obj.heading_angle + 180, 'deg');
        end

        % Moves the robot 1cm forwards or 0.01 in the coordinate system
        function move(obj, center, centimeters) 
            centimeters = (centimeters)/((obj.niterations*10));
            direction = (obj.body.Vertices(3, :)-obj.body.Vertices(2, :));
            direction = [direction(2), -direction(1)];
            direction = direction/norm(direction);
            
            x_axis_lower = -0.2+center(1);
            x_axis_upper = 0.2+center(1);
            y_axis_lower = -0.2+center(2);
            y_axis_upper = 0.2+center(2);
            axis([x_axis_lower x_axis_upper y_axis_lower y_axis_upper -0.15 0.05]);
        
            obj.body.XData = obj.body.XData + (centimeters)*(direction(1));
            obj.body.YData = obj.body.YData + (centimeters)*(direction(2));
        
            obj.legs(1).base = transl(obj.body.Vertices(1, :))*trotz(obj.heading_angle, 'deg');
            obj.legs(2).base = transl(obj.body.Vertices(2, :))*trotz(obj.heading_angle, 'deg');
            obj.legs(3).base = transl(obj.body.Vertices(3, :))*trotz(obj.heading_angle + 180, 'deg');
            obj.legs(4).base = transl(obj.body.Vertices(4, :))*trotz(obj.heading_angle + 180, 'deg');
        end

        % To use the robot_animate function
        function robot_animate(obj, f, move_amount)
            for i=1:obj.niterations
                obj.legs(1).animate(gait(obj.qcycle, obj.k, 0,   0));
                obj.legs(2).animate(gait(obj.qcycle, obj.k, 100, 0));
                obj.legs(3).animate(gait(obj.qcycle, obj.k, 200, 1));
                obj.legs(4).animate(gait(obj.qcycle, obj.k, 300, 1));
                drawnow
            
                % ----------------- Movement ---------------
                f(obj.find_center(), move_amount)
                % ----------------- Movement ---------------
            
                obj.k = obj.k+1;
                obj.A.add();
            end
        end
    end
end

    