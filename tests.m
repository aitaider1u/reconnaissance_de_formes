function my_tests()
% calcul des descripteurs de Fourier de la base de données
img_db_path = './db/';
img_db_list = glob([img_db_path, '*.gif']);
img_db = cell(1);
label_db = cell(1);
fd_db = cell(1);
for im = 1:numel(img_db_list);
    img_db{im} = logical(imread(img_db_list{im}));
    label_db{im} = get_label(img_db_list{im});
    disp(label_db{im}); 
    [fd_db{im},~,~,~] = compute_fd(img_db{im});
end

% importation des images de requête dans une liste
img_path = './dbq/';
img_list = glob([img_path, '*.gif']);
t=tic()

% pour chaque image de la liste...
for im = 1:numel(img_list)
   
    % calcul du descripteur de Fourier de l'image
    img = logical(imread(img_list{im}));
    [fd,r,m,poly] = compute_fd(img);
       
    % calcul et tri des scores de distance aux descripteurs de la base
    for i = 1:length(fd_db)
        scores(i) = norm(fd-fd_db{i});
    end
    [scores, I] = sort(scores);
       
    % affichage des résultats    
    close all;
    figure(1);
    top = 5; % taille du top-rank affiché
    subplot(2,top,1);
    imshow(img); hold on;
    plot(m(1),m(2),'+b'); % affichage du barycentre
    plot(poly(:,1),poly(:,2),'v-g','MarkerSize',1,'LineWidth',1); % affichage du contour calculé
    subplot(2,top,2:top);
    plot(r); % affichage du profil de forme
    for i = 1:top
        subplot(2,top,top+i);
        imshow(img_db{I(i)}); % affichage des top plus proches images
    end
    drawnow();
    waitforbuttonpress();
end
end

function [fd,r,m,poly] = compute_fd(img)
N = 150; % à modifier !!!
M = 100; % à modifier !!!
h = size(img,1);
w = size(img,2);

%Question 1------------------------------------------------------------------
%https://www.developpez.net/forums/d845299/general-developpement/algorithme-mathematiques/traitement-d-images/centre-gravite/
[rc,cc] = ndgrid(1:size(img,1),1:size(img,2));
Mt = sum(sum(img));
c1 = sum(sum(img.* rc)) / Mt;
c2 = sum(sum(img.* cc)) / Mt;
m = [round(c2) round(c1)];
%R = min(w/2,h/2);
%----------------------------------------------------------------------------

%Question 2------------------------------------------------------------------
poly = ones(N,2);
t = linspace(0,2*pi,N);
for i = 1:length(t)
    [x,y] = calcPoly(m,t(i),img);
    poly(i,1) = x;
    poly(i,2) = y;
end

% à modifier !!!
r = sqrt((m(1) - poly(:,1)).^2+(m(2) - poly(:,2)).^2);
% question3------------------ 
R = fft(r,M); 

fd = abs(R)/abs(R(1)); % à modifier !!!
end
