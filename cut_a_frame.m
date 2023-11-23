
%% Run these scripts to set parameters
ShowTrace_SetDataPath;
ShowTrace_DefineSection;
ShowTrace_DefineChar;

%% parameters
file_need = [2];

for i = file_need
        fprintf('Reading File #%d/%d\n', i, numel(file_need));
        data{i} = XxReadTiffSmallerThan4GB(filePath{i});
        if i == 2
            data{i} = data{i}(:,:,1:3:337);
        end
        gray_range_statistic = [gray_range_statistic; [reshape(min(min(data{i})),[],1) reshape(max(max(data{i})),[],1)]];
        disp(['Size of data{',num2str(i),'}=',num2str(size(data{i}))])
end