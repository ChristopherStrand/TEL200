poseGraph = PoseGraph('killian.g2o', 'laser');
scanMap = poseGraph.scanmap();
M = 10;
KillianMap = ones(size(scanMap));
KillianMap(scanMap >= M) = 0;


save('KillianMap.mat', 'KillianMap');

prm();
%scans = scanxy(poseGraph);
part3_icp(PoseGraph);