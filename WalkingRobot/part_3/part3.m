pg = PoseGraph('killian.g2o', 'laser');
scanMap = pg.scanmap();

save('KillianMap.mat', 'KillianMap');

part3_prm();
part3_icp(pg);