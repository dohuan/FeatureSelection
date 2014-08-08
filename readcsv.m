%% Read .csv file export to name and matrix
% ------------------------- Author: Huan N. Do ----------------------------
% Input:
%       fileDir: directory to file (file name included)
%       sheetName: name of excel sheet
%       dataRange: range of extracted cells
% Output:
%       raw: cells contain data (numerical and nomial)
%       dataName
%%
function [raw,dataName] = readcsv(fileDir,sheetName,dataRange)
    [~,~,raw] = xlsread(fileDir,sheetName,dataRange);
    dataName = raw(1,:);
    raw(1,:) = [];
end