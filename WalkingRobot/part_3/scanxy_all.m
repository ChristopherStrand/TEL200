function scans = scanxy_all(poseGraph)
    if ismethod(poseGraph, 'numNodes')
        N = poseGraph.numNodes();  
    else
        error('Fant ikke metode for å hente antall noder.');
    end

    scans = cell(N, 1);
    for i = 1:N
        scans{i} = poseGraph.scanxy(i);  
    end
end