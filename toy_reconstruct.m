function out_im = toy_reconstruct(s)
    % Reconstruct this image from its gradient values, plus one pixel intensity
    [h, w, ~] = size(s);
    im2var = zeros(h, w);
    im2var(1:h * w) = 1: h * w;
    
    %(Av-b)^2 solve b
    e = 1;
    A = zeros( (h-1) * (w-1) *2 + 1, h*w);
    b = zeros( (h-1) * (w-1) *2 + 1, 1);
    for y = 1:1:h-1
        for x = 1:1:w-1       
        % objective 1. minimize (v(x+1,y)-v(x,y) - (s(x+1,y)-s(x,y)))^2
        i = im2var(y, x);
        j = im2var(y, x+1);   
        m = s(y, x+1);
        n = s(y, x);
        A(e, i)=-1;
        A(e, j)=1;
        b(e) = m-n;
        e = e + 1;
        % objective 2. minimize (v(x,y+1)-v(x,y) - (s(x,y+1)-s(x,y)))^2
        j = im2var(y+1, x);      
        A(e, i) = -1;
        A(e, j) = 1;
        m = s(y+1, x);
        n = s(y,x);
        b(e) = m - n;
        e = e + 1;
        end
    end
        
    % objective 3. minimize (v(1,1)-s(1,1))^2
    A(e, 1) = 1; 
    b(e) = s(1,1);
    
    % Solve v
    A = sparse(A);
    v = A\b;
    out_im = reshape(v, [h, w]);
end
