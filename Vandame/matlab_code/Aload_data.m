clc;clear;
close all;
disp('load_data');
global Data

mfiles = dir('/dirs/home/phd/pmv8736/data/06022019 Dusk Dawn');
mfiles = dir('D:\stage\manipulation\data\06022019 Dusk Dawn\');
mdirflag = [mfiles.isdir];
subfolder = mfiles(mdirflag);

files = dir(fullfile(subfolder(1).folder,subfolder(1).name));

NB_folder = length(subfolder)-2; %maximum
NB_file = length(files)-3; %except folder #14

NB_folder = 14;
NB_file = 10;

Data.wavinfo=audioinfo(fullfile(files(3).folder,files(3).name));
s.rawdata = zeros(NB_file,Data.wavinfo.TotalSamples);

obj = struct(...
    'Connectivity', 0, ...
    'ImageSize', [], ...
    'NumObjects', [], ...
    'PixelIdxList', [] ,...
    'Source', [], ...
    'correlation_map_shape',[], ...
     'correlation_map_angle',[]);

s.obj = repmat(obj,NB_file,1);

s.filename = strings(NB_file,1);

Data.directory = repmat(s,NB_folder,1);

for i=1:NB_folder
    files = dir(fullfile(subfolder(i).folder,subfolder(i).name));
    for j=1:NB_file    
        Data.directory(i).name = files(j+2).name;
        Data.directory(i).folder = files(j).folder;
        Data.directory(i).folder = ...
            Data.directory(i).folder(find(Data.directory(i).folder == '#')+1:end);
        Data.directory(i).filename(j) = fullfile(files(j).folder,files(j+2).name);
        Data.directory(i).rawdata(j,:) =(audioread(Data.directory(i).filename(j))); 
    end
end
clear mfiles mdirflag subfolder files obj s finalfiles i j
