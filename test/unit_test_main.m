%% Run complete unit test
% create test suite
import matlab.unittest.TestSuite;
% run complete test suit
UTall = TestSuite.fromClass(?MrUnitTest);
resultsAll = run(UTall);
disp(table(resultsAll));

%% Run test for MrDimInfo
UTDimInfo = TestSuite.fromClass(?MrUnitTest,'Tag','MrDimInfo');
resultsDimInfo = run(UTDimInfo);
disp(table(resultsDimInfo));

% run individuell test for MrDimInfo
% create test object
testCase = MrUnitTest;
% call individual test cases
res = run(testCase, 'MrDimInfo_constructor');
res = run(testCase, 'MrDimInfo_get_add_remove');
res = run(testCase, 'MrDimInfo_split');
res = run(testCase, 'MrDimInfo_select');
res = run(testCase, 'MrDimInfo_load_from_file');

%% Run test for MrAffineGeometry
UTAffineGeometry = TestSuite.fromClass(?MrUnitTest,'Tag','MrAffineGeometry');
resultsAffineGeometry = run(UTAffineGeometry);
disp(table(resultsAffineGeometry));

%% Run test for MrImageGeometry
UTImageGeometry = TestSuite.fromClass(?MrUnitTest,'Tag','MrImageGeometry');
resultsImageGeometry = run(UTImageGeometry);
disp(table(resultsImageGeometry));

% call individual test cases
res = run(testCase, 'MrImageGeometry_constructor');
res = run(testCase, 'MrImageGeometry_load_from_file');

%% Run test for MrDataNd
UTDataNd = TestSuite.fromClass(?MrUnitTest,'Tag','MrDataNd');
resultsDataNd = run(UTDataNd);
disp(table(resultsDataNd));

res = run(testCase, 'MrDataNd_arithmetic_operation');
