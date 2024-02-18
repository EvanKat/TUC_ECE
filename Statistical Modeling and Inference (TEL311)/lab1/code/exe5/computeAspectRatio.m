function aRatio = computeAspectRatio(image,to_print)
    [num_rows, num_cols] = size(image);
    
    image = squeeze(image(1,:,:));
    
    % Find width
    first_col = find(sum(image,1), 1);
    last_col = find(sum(image,1), 1, 'last');
    width = last_col - first_col + 1;
    
    % Find height
    top_row = find(sum(image,2), 1);
    bottom_row = find(sum(image,2), 1, 'last');
    height = bottom_row - top_row + 1;
    
    aRatio = width / height;
    
    if to_print ~= 0
        figure
        imshow(image,[]);
        rectangle('Position',[first_col,top_row,width-1,height-1],'LineWidth',2,'EdgeColor','r');
        axis on
%         axis([0 28 0 28])
    end
   
end

