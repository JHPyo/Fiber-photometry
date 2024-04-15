drop = 8000;
Pre = 0;
Post = 40;
Pre2 = -10;
Post2 = 10;
TTL1 = 'Avoidance+';
TTL2 = 'Escape+';
Timebin = 1;
Sampling_rate = 12158.05471;%243.8429651;

processCSVFiles('D:\KHP2\vid')
processTTLFiles('D:\KHP2\TTL')
processAvoidanceData('I:\AG3\TTL')
processFluorescenceData('D:\KHP2', 8000, -5, 30, -5, 30, 'CS', 'CS', Timebin, Sampling_rate);