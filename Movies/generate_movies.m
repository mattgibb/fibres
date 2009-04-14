% Placeholder example graph
surf(peaks(50));

% Initialises variables
frames = 50;
campos_start    = [1 1 1];
campos_end      = [1 1 1];
camtarget_start = [1 1 1];
camtarget_end   = [1 1 1];

% time from 0 to pi
t = linspace(0,pi,frames)';

% normalised parameter: 0 at the start and 1 at the end
theta = 0.5 * (1 - cos(t));

% calculate the plot variables
cameras = ones(frames,1)*campos_start    + theta*(campos_end    - campos_start   );
targets = ones(frames,1)*camtarget_start + theta*(camtarget_end - camtarget_start);

% capture the frames