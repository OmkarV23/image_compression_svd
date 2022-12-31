function [r0,c] = image_compression(image)
%     image = load('data.mat');
    if isa(image,'struct')==1
        img = im2double(image.image);
    end
    if isa(image,'uint8')==1
        img = im2double(image);
    end
    nx = size(img,1);
    ny = size(img,2);
    
    % Semilog plot
    [u,s,v] = svd(img);
    semilogy(diag(s)/s(1,1),'k','LineWidth',2);
    title('semilog plot')
    grid on
    xlabel('r');
    ylabel('Singular values');
    figure;
    
    subplot(3,2,1)
    imshow(img)
    title('Original image')
    
    % Finding rank for sigmar0/sigma1 = 0.01
    for i=1:length(diag(s))
        if s(i,i)/s(1,1)<0.01
            r0=i;
            break
        end
    end
%     com_ratio = 100*r0*(nx+ny)/(nx*ny);
    
    % Displaying photos for rank=2, rank=10, rank=50, rank=100, rank_r0
    rank_mat = [2,10,50,100,r0];
    c = [];
    for i=1:length(rank_mat)
        s_new = s;
        s_new(rank_mat(i):end,:)=0; s_new(:,rank_mat(i):end);
        image_approx = u*s_new*v';
        c = [c 100*rank_mat(i)*(nx+ny)/(nx*ny)];
        subplot(3,2,i+1)
        imshow(image_approx)
        title(['Rank=',num2str(rank_mat(i)),' , ','Compression ratio=',num2str(100*rank_mat(i)*(nx+ny)/(nx*ny))])
    end
    fprintf('Rank r0 is:%d\n',r0);
    disp('Compression ratio is as follows:')
    fprintf('%f\t',c);
end