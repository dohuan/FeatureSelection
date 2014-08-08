% ---------- processing data collected from the robotic boat --------------
% Data collected from Alex's car run on date: 07-29-14
% ----------------- Author: Huan N. Do - dohuan@msu.edu -------------------
close all
clc
clear
%%                       TRAIN DATA PRE-PROCESSING
% ------------------------ reading data -----------------------------------
fileDir_tr = '.\boat0729145pm\Video Data 7-29-14\BOATAAAL.xls';
sheetName_tr = 'BOATAAAL';
range_tr = 'A4:AQ1081';
[raw,dataName] = readcsv(fileDir_tr,sheetName_tr,range_tr);
% -------------------- declare critical variables here --------------------
timeStamp_tr = raw(:,1);
Lat_tr =  reshape([raw{:,6}],[],1);
Long_tr =  reshape([raw{:,7}],[],1);
% -- info to cut out the ring from dough-nut image (same for test and train)
ringInfo.innerRadius = 90;
ringInfo.outerRadius = 180;
ringInfo.center_X = 295;
ringInfo.center_Y = 239;
% -------------------------------------------------------------------------
nt_tr = size(timeStamp_tr,1);
% --------------------- delete data with no images ------------------------
lostIndex_tr = [];
index = 1;
for i=1:nt_tr
    name_temp = sprintf('./boat0729145pm/AAAL/%d.jpg',timeStamp_tr{i}); 
    if (exist(name_temp,'file')==0)
        lostIndex_tr = [lostIndex_tr,i];
    else
        img = imread(name_temp);
        % ---------------------- Extract features here --------------------
        figure(1);
        %subplot(2,1,1)
        %imshow(unwrap_temp);
        img_crop = ringExtracter(img,ringInfo); 
        points = detectSURFFeatures(img_crop);
        [features,valid_points] = extractFeatures(img_crop,points);
        surfData_tr(i).feature = features;
        surfData_tr(i).point = valid_points;
        f{i} = valid_points.selectStrongest(10);
        hold on
        plot(f{i},'showOrientation',true);
        hold off
        
        %writeVideo(vid,getframe(gcf));
        % -----------------------------------------------------------------
        index = index+1;
    end
end
%close(vid)
Lat_tr(lostIndex_tr) = [];
Long_tr(lostIndex_tr) = [];
timeStamp_tr(lostIndex_tr) = [];
nt_tr = size(timeStamp_tr,1);


%%                       TEST DATA PRE-PROCESSING
% ------------------------ reading data -----------------------------------
fileDir_te = '.\boat0729145pm\Video Data 7-29-14\BOATAAAM.xls';
sheetName_te = 'BOATAAAM';
range_te = 'A5:AQ1081';
[raw,dataName] = readcsv(fileDir_te,sheetName_te,range_te);
% -------------------- declare critical variables here --------------------
timeStamp_te = raw(:,1);
Lat_te =  reshape([raw{:,6}],[],1);
Long_te =  reshape([raw{:,7}],[],1);
% -------------------------------------------------------------------------
nt_te = size(timeStamp_te,1);
% --------------------- delete data with no images ------------------------
lostIndex_te = [];
index = 1;
for i=1:nt_te
    name_temp = sprintf('./boat0729145pm/AAAM/%d.jpg',timeStamp_te{i}); 
    if (exist(name_temp,'file')==0)
        lostIndex_te = [lostIndex_te,i];
    else
        img = imread(name_temp);
        % ---------------------- Extract features here --------------------
        figure(2);
        img_crop = ringExtracter(img,ringInfo); 
        points = detectSURFFeatures(img_crop);
        [features,valid_points] = extractFeatures(img_crop,points);
        surfData_te(i).feature = features;
        surfData_te(i).point = valid_points;
        f{i} = valid_points.selectStrongest(10);
        hold on
        plot(f{i},'showOrientation',true);
        hold off
        
        %writeVideo(vid,getframe(gcf));
        % -----------------------------------------------------------------
        index = index+1;
    end
end
%close(vid)
Lat_te(lostIndex_te) = [];
Long_te(lostIndex_te) = [];
timeStamp_te(lostIndex_te) = [];
nt_te = size(timeStamp_te,1);


%%                        TRAIN-TEST PAIRs FINDING
% finding train-test pairs have close Lat and Long location
pairIndex = []; % [timeStampTrain timeStampTest]
minDist = 6.5565e-6; % minimum distance to be considered a pair
for i=1:nt_te
    Long_delta = Long_te(i)-Long_tr;
    Lat_delta = Lat_te(i)-Lat_tr;
    dist_delta = sqrt(Long_delta.^2+Lat_delta.^2);
    [IC,IX] = sort(dist_delta);
    if IC(1)<=minDist
        pairIndex = [IX(1) i];
    end
end

location_train = [Long_tr(train_split) Lat_tr(train_split)];
location_test = [Long_tr(test_split) Lat_tr(test_split)];
train_data = surfData_tr(train_split);
test_data = surfData_tr(test_split);
trainIndex = 1:size(train_split,2);
testIndex = bagofword(train_data,test_data,trainIndex,5);





