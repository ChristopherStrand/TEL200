%load house;
load house_modified.mat;
prm = PRM(house);

% --------- Planning phase -----------
prm.plan('npoints', 200)
% --------- Planning phase -----------

% --------- Query phase -----------
x_1 = randi(397);
y_1 = randi(596);
x_2 = randi(397);
y_2 = randi(596);

start = house(x_1, y_1);
goal = house(x_2, y_2);

while (start+goal) > 0
    disp(start+goal)
    if start == 1
        disp("New start coordinate generated")
        x_1 = randi(397);
        y_1 = randi(596);
        start = house(x_1, y_1);
    end
    if goal == 1
        disp("New goal coordinate generated")
        x_2 = randi(397);
        y_2 = randi(596);
        goal = house(x_2, y_2);
    end
end
prm.query([x_1 y_1], [x_2 y_2])
% --------- Query phase -----------

prm.plot()