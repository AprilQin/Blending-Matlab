% starter script for project 3
DO_TOY = false;
DO_BLEND = true; %Poisson Blending
DO_MIXED  = false; % Mixed Gradients
DO_COLOR2GRAY = false; % try to do better than rgb2gray
 
if DO_TOY 
    toyim = im2double(imread('./samples/toy_problem.png')); 
    % im_out should be approximately the same as toyim
    im_out = toy_reconstruct(toyim);
    figure(1), hold off, imshow(im_out), title('toy reconstruct');
%     subplot(121), imshow(toyim), title('original');
%     subplot(122), imshow(im_out), title('toy reconstruct');
    disp(['Error: ' num2str(sqrt(sum((toyim(:)-im_out(:)).^2)))])
end

if DO_BLEND 
    % do a small one first, while debugging
    im_background = imresize(im2double(imread('./samples/mona.jpg')), 0.5, 'bilinear');
    im_object = imresize(im2double(imread('./samples/me.jpg')), 1.1, 'bilinear');
    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);

    % blend
    im_blend = poissonBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend), title('Poisson Blend');
end

if DO_MIXED
    % read images
    im_background = imresize(im2double(imread('./samples/monkey.jpg')), 0.25, 'bilinear');
    im_object = imresize(im2double(imread('./samples/flower.jpg')), 0.25, 'bilinear');
    
    %get mask
    objmask = getMask(im_object);
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);
    
    % blend
    im_blend = mixedBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend), title('Mixed Gradient');
end

if DO_COLOR2GRAY
    % also feel welcome to try this on some natural images and compare to rgb2gray
    im_rgb = imresize(im2double(imread('./samples/head.jpg')), 0.20);
    im_gr = color2gray(im_rgb);
end

%%% plot the results
% figure(1), hold off, 
% subplot(121), imshow(toyim), title('original');
% subplot(122), imshow()
