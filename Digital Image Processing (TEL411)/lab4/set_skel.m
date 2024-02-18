function image = set_skel( im_png, BW , value)
%
%   For the pixels that binary image is true 
%   set the color of the value in the png image
%
    [row, colomn] = size(BW);

    image1 = im_png;
   
    for r = 1:row
        for c =1:colomn
            
            if (BW(r,c))
                image1(r,c,1) = value(1);
                image1(r,c,2) = value(2);
                image1(r,c,3) = value(3);
            end
            
        end
    end
    
    image = image1; 
end

