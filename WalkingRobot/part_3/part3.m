pg = PoseGraph('killian.g2o', 'laser');  
occgrid = pg.scanmap();   
pg.plot_occgrid(occgrid);           

KillianMap = uint8(occgrid ~= 0);
KillianMap = 1 - KillianMap;

save('KillianMap.mat', 'KillianMap');

part3_prm();
part3_icp(pg);