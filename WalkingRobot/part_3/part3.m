pg = PoseGraph('killian.g2o', 'laser');
scanMap = pg.scanmap();

KillianMap = ones(size(scanMap), 'uint8');
KillianMap(scanMap >= M & scanMap ~= 0) = 0;


save('KillianMap.mat', 'KillianMap');

part3_prm();
part3_icp(pg);