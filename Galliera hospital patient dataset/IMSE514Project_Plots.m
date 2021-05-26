% Neha Birla
% IMSE 514 Project: 
 
clear all;
clc;

% folderpath = pwd; % set folder path as current working directory
% filename = 'MedicalDataNew.xlsx';
% path2=fullfile(folderpath,filename);
% T=readtable(path2); % or readmatrix in new version

% T.ICD1 = categorical(T.ICD1);
% T.ICD2 = categorical(T.ICD2);
% T.SURGEON1 = categorical(T.SURGEON1);
% T.SURGEON2 = categorical(T.SURGEON2);
% T.ANESTETHIST = categorical(T.ANESTETHIST);
% T.SCRUBNURSE = categorical(T.SCRUBNURSE);
% summary(T)

load IMSE514_pro_data.mat

y=T.DELTAT34;
figure(1)
histogram(y)

figure(2);
ax=gca;
for lam=0.1:0.05:1 
    yB = (y.^lam-1)./lam; % BoxCox transforamtion
    histogram(ax,yB)
    title(['lam = ', num2str(lam)]);
    pause
end

figure
bar(T.ICD1, y)

grpstats(T.DELTAT34,T.ICD1,0.05) % https://www.mathworks.com/help/stats/grpstats.html

dsa = T(:,'ICD1');
statarray = grpstats(dsa,{'ICD1'},'numel');

figure
bar(categorical(categories(T.ICD1)), countcats(T.ICD1));
