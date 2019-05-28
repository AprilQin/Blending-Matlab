function im_blend = mixBlend(im_s, mask_s, im_background)
    im_blend = zeros( size(im_background) );
    poisson_mask = zeros( size(mask_s,1), size(mask_s,2) );
    [my, mx] = find(mask_s);
    len = length(mx);
    for i = 1:len
        poisson_mask( my(i), mx(i) ) = i;
    end
    
    for i = 1:3
        background = im_background(:, :, i);
        foreground = im_s(:, :, i);
        e = 1;
        A = sparse([],[],[],len*4+1, len); % each pixel in the target object needs 4 rows in matrix A to
        b = sparse([],[],[],len*4+1, len); % define its left, right, up, down 
        for j = 1:len
            x = mx(j);
            y = my(j);
            
            if (abs(foreground(y, x) - foreground(y-1, x)) >= abs(background(y, x)- background(y-1, x)) );
                mix = foreground(y, x) - foreground(y-1, x);
            else
                mix = background(y, x)- background(y-1, x);
            end
            
            %up    
            if (poisson_mask(y-1, x) == 0) 
                A(e, poisson_mask(y, x)) = 1;
                b(e) = mix + background(y-1,x);
            else
                A(e, poisson_mask(y, x)) = 1;
                A(e, poisson_mask(y-1, x)) = -1;
                b(e) = mix;
            end
            e = e+1;
            
            if (abs(foreground(y, x) - foreground(y+1, x)) >= abs(background(y, x)- background(y+1, x)) );
                mix = foreground(y, x) - foreground(y+1, x);
            else
                mix = background(y, x)- background(y+1, x);
            end
            
            %down
            if (poisson_mask(y+1, x) == 0)
                A(e, poisson_mask(y, x)) = 1;
                b(e) = mix + background(y+1,x);
            else
                A(e, poisson_mask(y, x)) = 1;
                A(e, poisson_mask(y+1, x)) = -1;
                b(e) = mix;
            end
            e = e+1;
            
            if (abs(foreground(y, x) - foreground(y, x-1)) >= abs(background(y, x)- background(y, x-1)) );
                mix = foreground(y, x) - foreground(y, x-1);
            else
                mix = background(y, x)- background(y, x-1);
            end
            
            %left
            if (poisson_mask(y, x-1) == 0)
                A(e, poisson_mask(y, x)) = 1;
                b(e) = mix + background(y,x-1);
            else
                A(e, poisson_mask(y, x)) = 1;
                A(e, poisson_mask(y, x-1)) = -1;
                b(e) = mix;
            end
            e = e+1;
            
            if (abs(foreground(y, x) - foreground(y, x+1)) >= abs(background(y, x)- background(y, x+1)) );
                mix = foreground(y, x) - foreground(y, x+1);
            else
                mix = background(y, x)- background(y, x+1);
            end
            
            %right
            if (poisson_mask(y, x+1) == 0)
                A(e, poisson_mask(y, x)) = 1;
                b(e) = mix + background(y,x+1);
            else
                A(e, poisson_mask(y, x)) = 1;
                A(e, poisson_mask(y, x+1)) = -1;
                b(e) = mix;
            end
            e = e+1;
            
        end
        A(e, poisson_mask(y, x)) = 1;
        A = sparse(A);
        b(e) = foreground(y, x);
        v = A\b;
        for k = 1:len
            background( my(k), mx(k) )= v(k);
        end
        im_blend(:, :, i) = background;  
        
    end

end