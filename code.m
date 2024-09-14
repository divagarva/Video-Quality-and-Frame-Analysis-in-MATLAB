% Specify the video file name
videoFile = 'video.mp4'; % Assumes 'video.mp4' is in the current directory

% Check if the file exists
if exist(videoFile, 'file') ~= 2
    error('The specified video file does not exist. Please check the file path or name.');
end

% Open the video file
video = VideoReader(videoFile);

% Define how many frames to process
numFramesToProcess = 100;  % Set the number of frames you want to process

% Display video properties
frameRate = video.FrameRate;
frameWidth = video.Width;
frameHeight = video.Height;

disp(['Frame Rate: ', num2str(frameRate), ' frames per second']);
disp(['Frame Size: ', num2str(frameWidth), 'x', num2str(frameHeight)]);

% Create a video writer object to save the output video
outputVideoFile = 'output_video_with_analysis.mp4'; % Name of the output video
outputVideo = VideoWriter(outputVideoFile, 'MPEG-4');
outputVideo.FrameRate = frameRate;  % Set the same frame rate as the original video
open(outputVideo);

% Initialize frame counter
frameCount = 1;

% Process only the first x frames (in this case, 10 frames)
while hasFrame(video) && frameCount <= numFramesToProcess
    % Read the current frame
    frame = readFrame(video);
    
    % Convert frame to grayscale for analysis (optional)
    grayFrame = rgb2gray(frame);
    
    % Perform analysis on each frame
    % Example 1: Calculate mean intensity of the frame
    meanIntensity = mean(grayFrame(:));
    
    % Example 2: Detect edges using Canny edge detector
    edges = edge(grayFrame, 'Canny');
    
    % Example 3: Histogram of pixel intensities
    histogram = imhist(grayFrame);
    
    % Create a figure for plotting
    fig = figure('visible', 'off', 'Position', [100, 100, frameWidth, frameHeight + 300]); % Add extra space for plot
    subplot(2, 1, 1);
    
    % Display the frame (original frame)
    imshow(frame);
    title(sprintf('Frame %d', frameCount));
    
    % Plot histogram
    subplot(2, 1, 2);
    bar(histogram);
    title(sprintf('Histogram of Frame %d - Mean Intensity: %.2f', frameCount, meanIntensity));
    
    % Capture the figure with both the frame and the plot
    frameWithPlot = getframe(fig);
    close(fig);  % Close the figure to prevent display issues
    
    % Write the frame with plot to the output video
    writeVideo(outputVideo, frameWithPlot);
    
    % Display or log the mean intensity for analysis
    disp(['Frame ', num2str(frameCount), ' Mean Intensity: ', num2str(meanIntensity)]);
    
    % Increment frame counter
    frameCount = frameCount + 1;
end

% Close the video writer object
close(outputVideo);

disp(['Processed and saved ', num2str(numFramesToProcess), ' frames in output video.']);
