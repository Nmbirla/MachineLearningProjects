% Neha Birla
% IMSE 514 Project: Data cleaning 
 
clear all;
clc;

folderpath = pwd; % set folder path as current working directory
filename = 'MedicalData.xlsx';
path1=fullfile(folderpath,filename);
T=readtable(path1,'Sheet','Dataset5'); % or readmatrix in new version

% load IMSE514_pro_data.mat;

varfun(@class, T) % checks data type of columns of table after importing

T=fillmissing(T,'constant','0','DataVariables',@iscell); % fill missing data with '0' for data format of type 'cell' 

s1=strlength(string(T.SURGEON1)); % calculates the total number of characters in each row of column surgeon1. 
ids1= s1>10; % replace 'surgeon not present' with '0' (zero)
T.SURGEON1(ids1)=cellstr('0');

idx = and(s1 > 3, s1 < 10); % find rows where two surgeons codes are entered in column 'surgeon1'
s2 = split(string(T.SURGEON1(idx)),', '); % splitting the surgeon codes using delimiter ', ' 
T.SURGEON1(idx) = cellstr(s2(:,1)); % putting 1st surgeon 
T.SURGEON2(idx) = cellstr(s2(:,2));

sA=strlength(string(T.ANESTETHIST)); % find rows where two anestethists are entered in same column 'ANESTETHIST'
idA = and(sA > 4, sA < 10);
s2A = split(string(T.ANESTETHIST(idA)),', ');
T.ANESTETHIST(idA) = cellstr(s2A(:,1));

% idAT=string(T.ANESTETHIST)=='TEST';
% T.ANESTETHIST(idA)=cellstr('0');

sN=strlength(string(T.SCRUBNURSE)); % find rows where two scrubnurses  are entered same column 'SCRUBNURSE'
idN = and(sN > 4, sN < 11);
s2N = split(string(T.SCRUBNURSE(idN)),', ');
T.SCRUBNURSE(idN) = cellstr(s2N(:,1));

idN2 = sN>20; % replacing 'ATTIVITA SVOLTA DA INFERMIERE' and 'STRUMENTISTA NON PRESENTE' with 0 (zeros) 
T.SCRUBNURSE(idN2) = cellstr('0');

T.ICD1 = categorical(T.ICD1);
T.ICD2 = categorical(T.ICD2);
T.SURGEON1 = categorical(T.SURGEON1);
T.SURGEON2 = categorical(T.SURGEON2);
T.ANESTETHIST = categorical(T.ANESTETHIST);
T.SCRUBNURSE = categorical(T.SCRUBNURSE);

summary(T)

% writetable(T,filename,'Sheet', 'Dataset6');
writetable(T,'MedicalDataNew.xlsx');