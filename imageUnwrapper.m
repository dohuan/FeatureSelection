% --------------- Unwrap dough-nut shape image into panoramic -------------
% Author: Huan N. Do - dohuan@msu.edu
% Input: 
%       - B: dough-nut image
%       - ang: angle compensation
%       - ringInfo: struct contains info about the "ring" in the input
%           image: innerRadius, outerRadius, center_X,center_Y
% Output:
%       - output: panoramic image
% -------------------------------------------------------------------------
function output=imageUnwrapper(B,ringInfo,ang) %ang in radian
if nargin<3
    ang = 0;
end
VD = struct('globe_radious',[ringInfo.innerRadius ringInfo.outerRadius],...
    'currentimage',B,...
    'globe_center',[ringInfo.center_Y ringInfo.center_X]);

output=zeros((ringInfo.outerRadius-ringInfo.innerRadius),...
    round(2*pi*ringInfo.outerRadius),3,class(VD.currentimage)); %panoramic image
output_size=size(output);
nf=16; % histogram with 16 bins

for index1 = 1:output_size(1)
    for index2 = 1:output_size(2)
        tmp_th = 2*pi*index2/output_size(2)-ang;
        tmp_r = VD.globe_radious(1) + index1/output_size(1) * ...
            (VD.globe_radious(2)-VD.globe_radious(1));
        x1 = (tmp_r * sin(tmp_th)+VD.globe_center(1));
        x2 = (tmp_r * cos(tmp_th)+VD.globe_center(2));
        
        output(index1,index2,:) = ...
            VD.currentimage(round(x1),round(x2),:);
    end
end 
% gray_image = imresize(rgb2gray(output),[128,128]);
% F=fft2(gray_image);
% FFT=reshape(reshape(abs(F(1,2:1+nf)),1,[]),[],1);
% HIST=imhist(gray_image,nf);
% NFFT=zeros(sizeFFT(1),sizeFFT(2));
end
% 
% 
% %% Absolute FFT features
% 
% Gray_image = imresize(rgb2gray(RGB_image),[128,128]);
% F = fft2(Gray_image);
% y = reshape(reshape(abs(F(1,2:1+nf)),1,[]),[],1);
% 
% 
% %% Absolute HISTOGRAM features
% 
% Gray_image = rgb2gray(RGB_image);
% [y,~] = imhist(Gray_image,nf);

