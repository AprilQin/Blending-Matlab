function gray = color2gray(im)
    [imh, imw, ch] = size(im); 
    im_rgb2gray = rgb2gray(im);
    figure(1), hold off, imshow(im_rgb2gray), title('rgb2gray');
    
    im_reconstructed = toy_reconstruct(im);
    gray = zeros(imh, imw, ch);
    
    for i = 1:3
        gray(:,:,i) = im_reconstructed;
    end
    
    figure(2), hold off, imshow(gray), title('color2gray');
end