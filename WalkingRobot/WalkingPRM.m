load house;
%load house_modified.mat;
prm = PRM(house);

% --------- Planning phase -----------
prm.plan('npoints', 100)
% --------- Planning phase -----------

% --------- Query phase -----------
x_1 = randi(397);
y_1 = randi(596);
x_2 = randi(397);
y_2 = randi(596);

start = house(x_1, y_1);
goal = house(x_2, y_2);
disp(start)
disp(goal)
disp(x_1)
disp(y_1)
disp(x_2)
disp(y_2)
while (start+goal) > 0
    disp(start+goal)
    if start == 1
        x_1 = randi(397);
        y_1 = randi(596);
    end
    if goal == 1
        x_2 = randi(397);
        y_2 = randi(596);
    end
end
prm.query([x_1 y_1], [x_2 y_2])
% --------- Query phase -----------

prm.plot()