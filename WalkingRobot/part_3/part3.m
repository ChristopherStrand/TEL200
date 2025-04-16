pg = PoseGraph('killian.g2o', 'laser');
scanMap = pg.scanmap();
M = 10;
KillianMap = ones(size(scanMap));
KillianMap(scanMap >= M) = 0;


save('KillianMap.mat', 'KillianMap');

prm();
part3_icp(pg);