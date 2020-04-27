function data = read_EOTN_file(filename)
%read_EOTN_file converts EOTN output to matlab struct
%
%   put the path to the EOTN file in as filename, and this
%   function returns a struct containing all the data from the 
%   run. 
% 
%   For example, if the file is in 
% 
%   Documents/CompCore/EOTN_output.txt
% 
%   Then you'd call
% 
%   data = read_EOTN_file('Documents/CompCore/EOTN_output.txt');



fileID = fopen(filename);

C = fscanf(fileID,'%c');

lines = splitlines(C);

labels = {};
datas = {};
for l = 1:length(lines)
    
    curr_label = '';
    curr_data = [];
    
    words = split(lines{l});
    for w = 1:length(words)
        
        
        if all(isletter(words{w}))
            curr_label = [curr_label,words{w}];
        else
            curr_data = [curr_data; str2double(words{w})];
        end
        
    end
    labels = [labels; curr_label];
    datas{end+1} = curr_data;
end

if isempty(lines{end})
    datas = datas(1:end-1);
end



data = struct();
for i = 1:length(labels)
    
    data.(labels{i}) = datas{i};
    
end


end

