function output = ringExtracter(B,ringInfo)
    
    imshow(B);
    rect_outer = [ringInfo.center_X-ringInfo.outerRadius ...
        ringInfo.center_Y-ringInfo.outerRadius ...
                        2*ringInfo.outerRadius 2*ringInfo.outerRadius];
    rect_inner = [ringInfo.center_X-ringInfo.innerRadius ...
        ringInfo.center_Y-ringInfo.innerRadius ...
                        2*ringInfo.innerRadius 2*ringInfo.innerRadius];
    
    ring_outer = imellipse(gca,rect_outer);
    ring_inner = imellipse(gca,rect_inner);
    mask_outer = createMask(ring_outer);
    mask_inner = createMask(ring_inner);
    mask = mask_outer - mask_inner;
    %mask = createMask(ring_outer) - createMask(ring_inner);
    B_gray = rgb2gray(B);
    [ny,nx] = size(B_gray);
    for i=1:ny
        for j=1:nx
            B_crop(i,j) = double(mask(i,j))*double(B_gray(i,j));
        end
    end
    output = uint8(B_crop);
end