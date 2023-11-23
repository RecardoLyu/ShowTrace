%% adjust trace size
% v3.8, adjust data form:[spot_idx, t, y, x] -> [x, y, t]
function trace_data_adjust = adjust_trace_width(trace_data)
% data form: N*4
trace_data_adjust = zeros(5*size(trace_data,1), size(trace_data, 2));
for idx = 1:size(trace_data, 1)
    % 从上开始逆时针：（中）上右下左
    trace_data_adjust(5*idx-4, :) = trace_data(idx, :);% center
    trace_data_adjust(5*idx-3,3) = trace_data(idx, 3);% up
    trace_data_adjust(5*idx-3, 1:2) = [trace_data(idx, 1)-1, trace_data(idx, 2)];
    trace_data_adjust(5*idx-2,3) = trace_data(idx, 3);% right
    trace_data_adjust(5*idx-2, 1:2) = [trace_data(idx, 1), trace_data(idx, 2)+1];
    trace_data_adjust(5*idx-1,3) = trace_data(idx, 3);% down
    trace_data_adjust(5*idx-1, 1:2) = [trace_data(idx, 1)+1, trace_data(idx, 2)];
    trace_data_adjust(5*idx,3) = trace_data(idx, 3);% left
    trace_data_adjust(5*idx, 1:2) = [trace_data(idx, 1), trace_data(idx, 2)-1];

end

end