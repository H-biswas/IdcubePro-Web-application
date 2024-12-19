function threeD_plot8(varargin)
%Author: Hridoy Biswas
set(gcf,'WindowButtonMotionFcn','');
Report=string(getappdata(0,'report'))+'3D Viewer>>';
setappdata(0,'report',Report);
versionName = getappdata(0,'versionName');
versionNumber = getappdata(0,'versionNumber');
main_bgc=getappdata(0,'main_bgc');
layer1_bgc=getappdata(0,'layer1_bgc');
layer2_bgc=getappdata(0,'layer2_bgc');
layer3_bgc=getappdata(0,'layer3_bgc');
btn_color=getappdata(0,'btn_color');
fgc=getappdata(0,'fgc');
bgc = getappdata(0,'bgc');
idcubeml = getappdata(0,'idcubeoneHandle');

% MAIN FIGURE
% Main Figure (uifigure)
    tmp = get(0, 'screensize');
    if tmp(4) >= 1080
        xpos = 550;
        ypos = 250;
        dimX = 900;
        dimY = 750;
    elseif tmp(4) >= 720 && tmp(4) < 1080
        xpos = 200;
        ypos = 100;
        dimX = 900;
        dimY = 600;
        
    else
        xpos = 100;
        ypos = 50;
        dimX = 600;
        dimY = 450;
        
    end

setappdata(0,'color_back',main_bgc)
 % Create the main uifigure window
    idcubeml3D.figure = uifigure('Position', [xpos ypos dimX dimY], ...
        'Color', main_bgc, 'Name', 'IDCubePro: 3D Viewer');
movegui(idcubeml3D.figure, 'onscreen'); % Prevent figure from popping outside of the screen


% FILE
%% Export
idcubeml3D.menuFile = uimenu(idcubeml3D.figure,'Label','&Export', 'Enable','on');
idcubeml3D.menuFileExportSetup = uimenu(idcubeml3D.menuFile,'Label','Export Setup...','callback',@exportsetupdlg_main,'Enable','On');
idcubeml3D.menuFileExportScreenShot = uimenu(idcubeml3D.menuFile,'Label','Copy Interface View','callback',@copyfigure,'Enable','On', 'Accelerator','R');
idcubeml3D.menuFileExportScreenShot = uimenu(idcubeml3D.menuFile,'Label','Save Interface View As...','callback',@saveasfigure,'Enable','On');

%% view
idcubeml3D.menuView = uimenu(idcubeml3D.figure,'Label','&View','Enable','on'); 
idcubeml3D.menuViewUnits = uimenu(idcubeml3D.menuView,'Label','Units','Enable','on');
idcubeml3D.menuViewRotate = uimenu(idcubeml3D.menuView,'Label','Rotate');
idcubeml3D.menuViewRotateFH = uimenu(idcubeml3D.menuViewRotate,'Label','Flip Horizontal','Enable','off','callback',@rotate_h);
idcubeml3D.menuViewRotateFV = uimenu(idcubeml3D.menuViewRotate,'Label','Flip vertical','Enable','off','callback',@rotate_v);
idcubeml3D.menuViewRotateRR90 = uimenu(idcubeml3D.menuViewRotate,'Label','Rotate Clockwise','Enable','off','callback',@rotate_clock);
idcubeml3D.menuViewRotateRL90 = uimenu(idcubeml3D.menuViewRotate,'Label','Rotate Anticlockwise','Enable','off','callback',@rotate_anticlock);
idcubeml3D.menuViewLUTBar = uimenu(idcubeml3D.menuView, 'Label', 'LUT Bar','callback',@lutbar,'Visible', 'off');
idcubeml3D.menuViewLUTBarClose = uimenu(idcubeml3D.menuView, 'Label', 'Close LUT Bar', 'callback', @disablelb,'Enable','Off');

idcubeml3D.menuViewTheme = uimenu(idcubeml3D.menuView,'Label','Colortheme');
idcubeml3D.menuViewTheme0 = uimenu(idcubeml3D.menuViewTheme,'Label','Default','callback',{@mh_theme,0},'Checked','on');
idcubeml3D.menuViewTheme1 = uimenu(idcubeml3D.menuViewTheme,'Label','Blue','callback',{@mh_theme,1},'enable','off');
idcubeml3D.menuViewTheme2 = uimenu(idcubeml3D.menuViewTheme,'Label','Light Grey','callback',{@mh_theme,2},'enable','off');
idcubeml3D.menuViewTheme3 = uimenu(idcubeml3D.menuViewTheme,'Label','Violet','callback',{@mh_theme,3},'enable','off');
idcubeml3D.menuViewTheme4 = uimenu(idcubeml3D.menuViewTheme,'Label','Green','callback',{@mh_theme,4},'enable','off');
idcubeml3D.menuViewTheme5 = uimenu(idcubeml3D.menuViewTheme,'Label','Red','callback',{@mh_theme,5},'enable','off');
idcubeml3D.menuViewTheme6 = uimenu(idcubeml3D.menuViewTheme,'Label','Dark Grey','callback',{@mh_theme,6},'enable','off');

%% HELP
idcubeml3D.menuHelp = uimenu(idcubeml3D.figure,'Label','&Help');
idcubeml3D.menuHelpAbout = uimenu(idcubeml3D.menuHelp,'Label',['About ' versionName],'callback',@mh_about_new);
idcubeml3D.menuHelpManuals = uimenu(idcubeml3D.menuHelp,'Label','3D Viewer Manual','callback',@threeD_viewer_info);
idcubeml3D.menuHelpTutorials = uimenu(idcubeml3D.menuHelp,'Label','3D Viewer Video Tutorial (pending)','callback',{@mh_websiteLink2,'tutorials'});
%% Exit
idcubeml3D.menuFile = uimenu(idcubeml3D.figure,'Label','&Exit');

idcubeml3D.menuFileExit = uimenu(idcubeml3D.menuFile,'Label','Exit','callback',@idcubeml3D_CloseRequestFcn,...
    'Accelerator','X');



% parentFigure.ToolBar = 'figure';
ToolBar = uitoolbar(idcubeml3D.figure);
% ToolBar = findall(parentFigure,'Type','uitoolbar');
if ispc
    ImageBaseFolder = 'icons\';
else
    ImageBaseFolder = 'icons/';
end
% First, create the search-box component on the EDT, complete with invokable Matlab callbacks:
%%

%% TOOLBAR STANDARD

idcubeml3D.toolbarFH = uitoggletool(ToolBar,'TooltipString','Flip Horizontal',...
    'CData',imread(strcat(ImageBaseFolder,'IDCube-icon-Flip Horizontal.jpg')),'Separator','On','Enable','off','ClickedCallback',{@rotate_h});

idcubeml3D.toolbarFV = uitoggletool(ToolBar,'TooltipString','Flip Vertical',...
    'CData',imread(strcat(ImageBaseFolder,'IDCube-icon-Flip Vertical.jpg')),'Separator','Off','Enable','off','ClickedCallback',{@rotate_v});

idcubeml3D.toolbarRR90 = uipushtool(ToolBar,'TooltipString','Rotate Clockwise°',...
    'CData',imread(strcat(ImageBaseFolder,'_IDCube-icon-Rotate CW.jpg')),'Separator','Off','Enable','off','ClickedCallback',{@rotate_clock});

idcubeml3D.toolbarRL90 = uipushtool(ToolBar,'TooltipString','Rotate Anticlockwise°',...
    'CData',imread(strcat(ImageBaseFolder,'_IDCube-icon-Rotate CCW.jpg')),'Separator','Off','Enable','off','ClickedCallback',{@rotate_anticlock});


idcubeoneHandle.toolbarHelp = uitoggletool(ToolBar,'TooltipString','Keyboard Shortcut and Mouse Control for Zoom and Pan',...
     'CData',imread(strcat(ImageBaseFolder,'IDCube-icon-Help.jpg')),'Enable','On','Separator','On','ClickedCallback',@zoompanhelp);


%% Add custom colormap


idcubeoneHandle.toolbarColorEditor = uipushtool(ToolBar, 'CData', imread(strcat(ImageBaseFolder,'_IDCube-icon-Brush.jpg')), ...
        'Tooltip', 'LUT generator', 'ClickedCallback', @lutGeneratorGUI_3D);

% Define the custom icon dimensions
iconWidth = 16;
iconHeight = 16;

% Create a blank custom icon
customIcon = zeros(iconHeight, iconWidth, 3);

% Set the red color for the left half of the icon
customIcon(:, 1:iconWidth/2, 1) = 1;

% Set the blue color for the right half of the icon
customIcon(:, iconWidth/2+1:end, 3) = 1;

% Draw horizontal line
customIcon(iconHeight/2-1:iconHeight/2, :, :) = 1;

% Draw vertical line
customIcon(:, iconWidth/2-1:iconWidth/2, :) = 1;

% Set the custom icon as the CData property of the uipushtool
idcubeoneHandle.toolbarcustomColorbarButton = uipushtool(ToolBar, 'CData', customIcon, ...
    'Tooltip', 'User defined custom colormap', 'ClickedCallback', @applyCustomLUTToAxes);


%% Function to create a custom colorbar icon

function icon = createColorbarIcon(lut)
    % Create a custom colorbar icon with the reversed LUT gradient
    numColors = size(lut, 1);
    icon = zeros(numColors, 10, 3);
    for i = 1:numColors
        icon(i, :, 1) = lut(numColors - i + 1, 1); % Red channel
        icon(i, :, 2) = lut(numColors - i + 1, 2); % Green channel
        icon(i, :, 3) = lut(numColors - i + 1, 3); % Blue channel
    end
end

   function applyCustomLUTToAxes(varargin)
%    idcubeml = getappdata(0,'idcubeoneHandle');  
   idcubeml3D= getappdata(0,'handle');
%     idcubeoneHandle = getappdata(0, 'idcubeoneHandle');
    % ax: The handle to the axes

    % Prompt the user to select the LUT file
    [filename, pathname] = uigetfile({'*.mat'}, 'Select LUT File');

    % Check if the user canceled the file selection
    if isequal(filename, 0) || isequal(pathname, 0)
        error('LUT file selection canceled.');
    end

    % Load the LUT from the selected file
    loadedData = load(fullfile(pathname, filename));

    % Get the variable name containing the LUT data
    lutVariableName = fieldnames(loadedData);
    setappdata(0,'make_colorbar',2);
    % Extract the LUT data
    lut = loadedData.(lutVariableName{1});
    setappdata(0,'color_custom',lut); 
    % Apply the custom LUT to the axes colormap
%     ax = gca;
    colormap(lut);
%     cmap = cmap

    % Update the colorbar icon with the selected LUT gradient
    set(idcubeoneHandle.toolbarcustomColorbarButton, 'CData', createColorbarIcon(lut));
end


%% Add INFO ICON

idcubeoneHandle.toolbarInfo = uitoggletool(ToolBar,'TooltipString','Information about this screen',...
         'CData',imread(strcat(ImageBaseFolder,'_IDCube-icon-Information-Question-6.jpg')),'Enable','On','Separator','On', 'ClickedCallback',@threeD_viewer_info);
     
function threeD_viewer_info(varargin)
if ismac
    url = 'https://www.idcubes.com/s/3d_viewer_2.pdf';
    web(url);
else
    winopen('3d_viewer_2.pdf');
end 
end


% Panels with GREEN BUTTONS (horizontal layout)
    idcubeml3D.dataManagementPanel = uipanel('parent', idcubeml3D.figure, ...
        'Position', [40, 600, dimX-50, 100], ... % Panel takes the width of the window
        'BackgroundColor', main_bgc, ...
        'ForegroundColor', fgc, ...       
        'FontSize', 11, ...
        'Visible', 'On', 'BorderType', 'none');

    % Horizontal arrangement of buttons

    % 'Generate 3D' Button
    idcubeml3D.original_3D = uibutton(idcubeml3D.dataManagementPanel, 'push', ...
        'Text', 'Generate 3D', ...
        'Position', [20, 30, 150, 40], ... % Adjusted position for horizontal layout
        'BackgroundColor', [77/255 194/255 115/255], ...
        'FontColor', 'w', ...
        'Tooltip', 'Show the datacube in 3D', ...
        'FontSize', 12, ...
        'ButtonPushedFcn', @original_callback);

    % 'Get Orthogonal Slice' Button
    idcubeml3D.orthogonal_slice = uibutton(idcubeml3D.dataManagementPanel, 'push', ...
        'Text', 'Get Orthogonal Slice', ...
        'Position', [180, 30, 150, 40], ... % Next to 'Generate 3D' button
        'BackgroundColor', [77/255 194/255 115/255], ...
        'FontColor', 'w', ...
        'Tooltip', 'Slice the data in a 2D space', ...
        'FontSize', 12, ...
        'ButtonPushedFcn', {@orthogonal_slice_callback, idcubeml3D});

    % 'Get 3D Slice' Button
    idcubeml3D.slice2 = uibutton(idcubeml3D.dataManagementPanel, 'push', ...
        'Text', 'Get 3D Slice', ...
        'Position', [340, 30, 150, 40], ... % Next to 'Get Orthogonal Slice' button
        'BackgroundColor', [77/255 194/255 115/255], ...
        'FontColor', 'w', ...
        'Tooltip', 'Visualize the datacube in 3D view with slicers', ...
        'FontSize', 12, ...
        'ButtonPushedFcn', @slice_callback);

    % 'Segmentation' Button (K-Means 3D)
    idcubeml3D.new_btn = uibutton(idcubeml3D.dataManagementPanel, 'push', ...
        'Text', 'Segmentation', ...
        'Position', [500, 30, 150, 40], ... % Next to 'Get 3D Slice' button
        'BackgroundColor', [77/255 194/255 115/255], ...
        'FontColor', 'w', ...
        'Tooltip', 'Load the new MAT file for segmentation', ...
        'FontSize', 12, ...
        'ButtonPushedFcn', {@Kmeans_callback, idcubeml3D});

    % 'Back to Original' Button
    idcubeml3D.loadoriginal_btn = uibutton(idcubeml3D.dataManagementPanel, 'push', ...
        'Text', 'Back to Original', ...
        'Position', [660, 30, 150, 40], ... % Next to 'Segmentation' button
        'BackgroundColor', [77/255 194/255 115/255], ...
        'FontColor', 'w', ...
        'Tooltip', 'Return to the original view', ...
        'FontSize', 12, ...
        'ButtonPushedFcn', @original);
    
    % Store the handles in the application data
    setappdata(0, 'idcubeml3D', idcubeml3D);


% Image Display Original
idcubeml3D.imageDisplayPanel = uipanel('parent', idcubeml3D.figure, ...
    'position', [20, 40, 500, 500], ...
    'bordertype', 'none', 'title', '', ...
    'fontsize', 11, ...
    'backgroundcolor', 'g', ... %main_bgc
    'foregroundcolor', fgc, ...
    'Visible', 'On', ...
    'Interruptible', 'on');
left = 1;                  % Left margin in pixels
bottom = 1;                % Bottom margin in pixels
width = floor(idcubeml3D.imageDisplayPanel.Position(3)) - left;  % Width of the axes
height = floor(idcubeml3D.imageDisplayPanel.Position(4)) - bottom; 
idcubeml3D.axes_input = axes('parent', idcubeml3D.imageDisplayPanel, 'units', 'Normalized', ...
    'Position', [1 1 width height], 'DataAspectRatioMode', 'auto', ...
    'XTick', [], 'YTick', []);
colorbar('HitTest', 'Off', 'Color', fgc);

axdrag;

 % Add 3D Interactive Panel with sliders
    idcubeml3D.interactive_panel = uipanel('parent', idcubeml3D.figure, ...
        'Position', [600, 400, dimX-300, 150], ...
        'BackgroundColor', layer1_bgc, ... %layer1_bgc,
        'ForegroundColor', fgc, ... %'BorderType', 'none', ...        
        'FontSize', 11, ...
        'Title', '3D Interactive Panel');

    % Custom sliders for colormap and transparency

% Ensure values are within slider limits and convert to double if needed
% lower_1_val = str2double(getappdata(0, 'lower_1'));
% lower_1_val = max(min(lower_1_val, 0), -5000); % Keep value within limits [-5000, 0]
% 
% lower_2_val = str2double(getappdata(0, 'lower_2'));
% lower_2_val = max(min(lower_2_val, 3000), 0); % Keep value within limits [0, 3000]
% 
% upper_1_val = str2double(getappdata(0, 'upper_1'));
% upper_1_val = max(min(upper_1_val, 3000), -1); % Keep value within limits [-1, 3000]
% 
% alpha_val = str2double(getappdata(0, 'lower_alpha'));
% alpha_val = max(min(alpha_val, 1), 0); % Keep value within limits [0, 1]
% 
% % 'Lower Intensity 1' slider
% uilabel(idcubeml3D.interactive_panel, 'Position', [20, 100, 100, 15], 'Text', 'Lower Intensity 1');
% 
% idcubeml3D.lower_slider1 = uislider(idcubeml3D.interactive_panel, ...
%     'Position', [130, 105, 100, 3], ...
%     'Limits', [-5000, 0], ...
%     'Value', lower_1_val, ...
%     'MajorTicks', [], ...           % Removes major tick marks and values
%     'MinorTicks', [], ...           % Removes minor tick marks
%     'ValueChangedFcn', @(src, event) updateLower1Value(src, event));
% 
% % 'Lower Intensity 2' slider
% uilabel(idcubeml3D.interactive_panel, 'Position', [20, 75, 100, 15], 'Text', 'Lower Intensity 2');
% 
% idcubeml3D.lower_slider2 = uislider(idcubeml3D.interactive_panel, ...
%     'Position', [130, 80, 100, 3], ...
%     'Limits', [0, 3000], ...
%     'Value', lower_2_val, ...
%     'MajorTicks', [], ...           % Removes major tick marks and values
%     'MinorTicks', [], ...           % Removes minor tick marks
%     'ValueChangedFcn', @(src, event) updateLower2Value(src, event));
% 
% % 'Upper Intensity 1' slider
% uilabel(idcubeml3D.interactive_panel, 'Position', [20, 50, 100, 15], 'Text', 'Upper Intensity 1');
% 
% idcubeml3D.upper_slider1 = uislider(idcubeml3D.interactive_panel, ...
%     'Position', [130, 55, 100, 3], ...
%     'Limits', [-1, 3000], ...
%     'Value', upper_1_val, ...
%     'MajorTicks', [], ...           % Removes major tick marks and values
%     'MinorTicks', [], ...           % Removes minor tick marks
%     'ValueChangedFcn', @(src, event) updateUpper1Value(src, event));
% 
% % 'Alpha Transparency' slider
% uilabel(idcubeml3D.interactive_panel, 'Position', [20, 25, 100, 15], 'Text', 'Alpha Transparency');
% 
% idcubeml3D.alpha_slider = uislider(idcubeml3D.interactive_panel, ...
%     'Position', [130, 30, 100, 3], ...
%     'Limits', [0, 1], ...
%     'Value', alpha_val, ...
%     'MajorTicks', [], ...           % Removes major tick marks and values
%     'MinorTicks', [], ...           % Removes minor tick marks
%     'ValueChangedFcn', @(src, event) updateAlphaValue(src, event));
% 
% 
%     % Store the handles in the application data
%     setappdata(0, 'idcubeml3D', idcubeml3D);


% Rendering Panel
% idcubeml3D.volume = uipanel('Parent', idcubeml3D.interactive_panel, ...
%     'Position', [600, 150, dimX-620, 170], ...
%     'BackgroundColor', 'white', ...
%         'title', '', 'Enable', 'Off', 'fontsize', 9);
% 
% idcubeml3D.volume_render = uicontrol('parent', idcubeml3D.volume, 'Style', 'popupmenu', ...
%     'position', [0.018316831683168, 0.332031249999999, 0.30170297029703, 0.40625], 'FontUnits', 'Normalized', 'backgroundcolor', 'white');
% 
% idcubeml3D.volume_methid_label = uicontrol('parent', idcubeml3D.volume, 'style', 'text', ...
%     'Position', [0.072, 0.74, 0.2, 0.2], 'foregroundcolor', fgc, 'backgroundcolor', layer1_bgc, 'String', '3D Method', 'Visible', 'On');
% 
% idcubeml3D.volume_render.String = {'Volume render', 'Isosurface'};
% idcubeml3D.volume_render.Callback = @volume_ren;
% 
% idcubeml3D.iso_label = uicontrol('parent', idcubeml3D.volume, 'style', 'text', ...
%     'Position', [0.67, 0.74, 0.38, 0.2], 'foregroundcolor', fgc, 'backgroundcolor', layer1_bgc, 'String', 'Surface Color', 'Visible', 'Off');
% 
% idcubeml3D.iso_color = uicontrol('parent', idcubeml3D.volume, 'Style', 'popupmenu', ...
%     'position', [0.702772277227724, 0.332031249999999, 0.30170297029703, 0.40625], 'FontUnits', 'Normalized', 'backgroundcolor', 'white', 'Visible', 'Off');
% 
% idcubeml3D.iso_color.String = {'Red', 'Yellow', 'Magenta', 'Cyan', 'Green', 'Blue', 'White', 'Black','Custom'};
% idcubeml3D.iso_color.Callback = @iso_color;
% 
% idcubeml3D.iso_slider1 = uicontrol('parent', idcubeml3D.volume, 'style', 'slider', 'min', 0, 'max', 1, ...
%     'value', 0.3, 'sliderstep', [step_min step_max], 'position', [0.361603960396039, 0.437848958333334, 0.3017, 0.30625], 'FontUnits', 'Normalized', 'Visible', 'Off', ...
%     'tooltipstring', 'Select the isovalue (range 0 to 1)', 'fontsize', 9, 'backgroundcolor', layer1_bgc);
% 
% idcubeml3D.iso_label_slider = uicontrol('parent', idcubeml3D.volume, 'style', 'text', ...
%         'Position', [0.30, 0.74, 0.4, 0.2], ...
%         'foregroundcolor', fgc, 'backgroundcolor', layer1_bgc, ...
%         'String', 'Iso Value', 'Visible', 'off');
% 
%  addlistener(idcubeml3D.iso_slider1, 'Value', 'PostSet', @iso_slider1);
%     % Add callback to slider to update label
%     addlistener(idcubeml3D.iso_slider1, 'Value', 'PostSet', @updateIsoLabel);
%      function updateIsoLabel(~, ~)
%         if idcubeml3D.volume_render.Value == 2
%             val = get(idcubeml3D.iso_slider1, 'Value');
%             labelStr = sprintf('Iso Value: %.3f', val);
%             set(idcubeml3D.iso_label_slider, 'String', labelStr, 'Visible', 'on');
%         else
%             set(idcubeml3D.iso_label_slider, 'Visible', 'off');
%         end
%     end

%%


% idcubeml3D.volume = uipanel('Parent', idcubeml3D.figure, ...
%     'Position', [50 400 700 150], 'BackgroundColor', 'white', ...
%     'Title', 'Volume Rendering Options');

% Volume render dropdown
idcubeml3D.volume_render = uidropdown('Parent', idcubeml3D.interactive_panel, ...
    'Position', [20 90 150 22], 'Items', {'Volume render', 'Isosurface'}, ...
    'ValueChangedFcn', @(src, event) volume_ren(src));

% Volume method label
idcubeml3D.volume_methid_label = uilabel('Parent', idcubeml3D.interactive_panel, ...
    'Position', [20 110 100 22], 'Text', '3D Method');

% Isosurface color label
idcubeml3D.iso_label = uilabel('Parent', idcubeml3D.interactive_panel, ...
    'Position', [330 110 100 22], 'Text', 'Surface Color', 'Visible', 'off');

% Isosurface color dropdown
idcubeml3D.iso_color = uidropdown('Parent', idcubeml3D.interactive_panel, ...
    'Position', [340 90 150 22], 'Items', {'Red', 'Yellow', 'Magenta', 'Cyan', 'Green', 'Blue', 'White', 'Black', 'Custom'}, ...
    'Visible', 'on', 'ValueChangedFcn', @(src, event) iso_color(src));

% Isosurface slider
idcubeml3D.iso_slider1 = uislider('Parent', idcubeml3D.interactive_panel, ...
    'Position', [220 90 80 3], 'Limits', [0 1], 'Value', 0.3, 'Visible', 'off', ...
    'Tooltip', 'Select the isovalue (range 0 to 1)', 'ValueChangedFcn', @(src, event) iso_slider1(src));

% Isovalue label for slider
idcubeml3D.iso_label_slider = uilabel('Parent', idcubeml3D.interactive_panel, ...
    'Position', [200 110 100 22], 'Text', 'Iso Value: 0.300', 'Visible', 'off');

% Add listener for slider value change
% addlistener(idcubeml3D.iso_slider1, 'Value', 'PostSet', @(src, event) updateIsoLabel(src, idcubeml3D.iso_slider1, idcubeml3D.iso_label_slider));

% Callback functions
% function volume_ren(src)
%     if src.Value == "Isosurface"
%         idcubeml3D.iso_color.Visible = 'on';
%         idcubeml3D.iso_slider1.Visible = 'on';
%         idcubeml3D.iso_label_slider.Visible = 'on';
%     else
%         idcubeml3D.iso_color.Visible = 'off';
%         idcubeml3D.iso_slider1.Visible = 'off';
%         idcubeml3D.iso_label_slider.Visible = 'off';
%     end
% end

%%

idcubeml3D.color_channel = uipanel('parent', idcubeml3D.figure, ...
    'Position', [600, 350, dimX-500 50], 'FontSize', 9, ...
    'BackgroundColor', layer1_bgc, 'foregroundColor', fgc, ...
    'Title', '3D Colormap');

% Adding dropdown for 3D Colormap options
idcubeml3D.color2 = uidropdown('Parent', idcubeml3D.color_channel, ...
    'Position', [10 8 150 20], 'BackgroundColor', 'white', ...
    'Items', {'lightgray', 'autumn', 'bone', 'cool', 'copper', 'gray', 'hot', 'pink', 'spring', 'summer', 'winter', 'jet', 'hsv', 'colorcube', 'flag', ...
              'lines', 'prism', 'ct-bone', 'white', 'contrast'}, ...
    'ValueChangedFcn', @pop_callback);


function updateIsoLabel(~, slider, label)
    label.Text = sprintf('Iso Value: %.3f', slider.Value);
end




%%

step_min = 8.333333e-4; step_max = step_min * 10;


% Store the handles in the application data
setappdata(0, 'axes_handle', idcubeml3D.axes_input);
setappdata(0, 'slider_handle', idcubeml3D.iso_slider1);

% Initial image display
initial_slice = round(get(idcubeml3D.iso_slider1, 'Value'));
% display_image_3D(idcubeml3D.axes_input, initial_slice);


%% Intensity Panel
% idcubeml3D.colormap =  uipanel('parent',idcubeml3D.interactive_panel,...
%     'position',[600, 100, dimX-100, 300], 'FontSize', 9, 'backgroundcolor','white',...
%        'bordertype','none','foregroundcolor',fgc,'backgroundcolor',layer1_bgc,...
%      'title','','Enable','On');
 

%% alpha panel
idcubeml3D.colormap = uipanel('Parent', idcubeml3D.figure, ...
    'Position', [600, 150, dimX-300, 200], 'FontSize', 9, 'BackgroundColor', 'white', ...
    'Title', 'Alpha Map','backgroundcolor',layer1_bgc,'foregroundcolor',fgc);

% Create the dropdown menu (popup) inside the Alpha Map panel
idcubeml3D.alpha_built = uidropdown('Parent', idcubeml3D.colormap, ...
    'Position', [20, 150, 150, 25], 'BackgroundColor', 'white', ...
    'Items', {'linear', 'profile 1', 'profile 2', 'profile 3', 'profile 4', ...
              'profile 5', 'profile 6', 'profile 7', 'custom'}, ...
    'ValueChangedFcn', @pop_alpha_callback);

% Create a label for transparency (currently hidden)
% idcubeml3D.label1 = uilabel('Parent', idcubeml3D.colormap, ...
%     'Position', [10 150 100 25], ...
%     'Text', 'Transparency1', 'Visible', 'on');

% Create an axes for intensity (currently hidden)
idcubeml3D.axes_inten = uiaxes('Parent', idcubeml3D.colormap, ...
    'Position', [35 16 200 120], 'Visible', 'on');
set(idcubeml3D.axes_inten, 'Color', 'white', 'XColor', 'black', 'YColor', 'black');



%% Dimension Control Scale factor Panel
setappdata(0,'X',1)
setappdata(0,'Y',1)
setappdata(0,'Z',1)
idcubeml3D.scale =  uipanel('parent',idcubeml3D.interactive_panel,...
    'position',[0.56,0.58,0.395,0.20],'Fontsize', 9, 'backgroundcolor','white',...
           'title','Axes scale');
idcubeml3D.labelscale1 = uicontrol('parent',idcubeml3D.scale,'style','text',...
    'Position',[0.01 0.6 0.4 0.2],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','X','Visible','On');
idcubeml3D.scaleX = uicontrol('parent',idcubeml3D.scale,'style','edit',...
    'Position',[0.5 0.62 0.4 0.2],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','1','Visible','On','Callback',@scale);
idcubeml3D.labelscale2 = uicontrol('parent',idcubeml3D.scale,'style','text',...
    'Position',[0.01 0.35 0.4 0.2],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',layer1_bgc,'String','Y','Visible','On');
idcubeml3D.scaleY = uicontrol('parent',idcubeml3D.scale,'style','edit',...
    'Position',[0.5 0.369 0.4 0.2],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','1','Visible','On','Callback',@scale);
idcubeml3D.labelscale3 = uicontrol('parent',idcubeml3D.scale,'style','text',...
    'Position',[0.01 0.10 0.4 0.2],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',layer1_bgc,'String','Z','Visible','On');
idcubeml3D.scaleZ = uicontrol('parent',idcubeml3D.scale,'style','edit',...
    'Position',[0.5 0.09 0.4 0.2],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','1','Visible','On','Callback',@scale);


%%Color-1
% idcubeml3D.color_channel =  uipanel('parent',idcubeml3D.interactive_panel,...
%      'position',[0.054320987654316,0.578097229219141,0.521604938271604,0.199999999999998],'Fontsize', 9, 'backgroundcolor','white',...
%               'title','3D Colormap');
% idcubeml3D.color2 = uicontrol('parent',idcubeml3D.color_channel,'Style','popupmenu',...
%                       'position',[0.035633482732757,0.386006787776381,0.831033183933911,0.343733506858752],'FontUnits','Normalized','backgroundcolor','white');
% idcubeml3D.color2.String ={'lightgray','autumn', 'bone', 'cool', 'copper', 'gray','hot','pink','spring','summer','winter','jet','hsv','colorcube','flag'...
%     'lines','prism','ct-bone', 'white','contrast'};	
% idcubeml3D.color2.Callback=@pop_callback;


%% Orthogonal slice panel

idcubeml3D.ortho_panel =  uipanel('parent',idcubeml3D.figure,'Position',[0.690740740740741,0.239851024208565,0.271238425925926,0.1],'Fontsize', 10, 'backgroundcolor','white',...
         'title','Orthogonal slice scale control panel');
 
%%Scale control panel orthognal Slice
setappdata(0,'X_ort',1)
setappdata(0,'Y_ort',1)
setappdata(0,'Z_ort',1)

idcubeml3D.labelscale1_ortho = uicontrol('parent',idcubeml3D.ortho_panel,'style','text',...
    'Position',[0.075190367978311,0.55,0.1,0.27],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','X','Visible','On');
idcubeml3D.scaleX_ortho = uicontrol('parent',idcubeml3D.ortho_panel,'style','edit',...
    'Position',[0.15 0.5 0.2 0.3],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','1','Visible','On','Callback',@scale_ortho);
idcubeml3D.labelscale2_ortho = uicontrol('parent',idcubeml3D.ortho_panel,'style','text',...
    'Position',[0.367847147470398,0.55,0.1,0.27],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','Y','Visible','On');
idcubeml3D.scaleY_ortho = uicontrol('parent',idcubeml3D.ortho_panel,'style','edit',...
    'Position',[0.45 0.5 0.2 0.3],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','1','Visible','On','Callback',@scale_ortho);
idcubeml3D.labelscale3_ortho = uicontrol('parent',idcubeml3D.ortho_panel,'style','text',...
    'Position',[0.663079584775087,0.55,0.1,0.27],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','Z','Visible','On');
idcubeml3D.scaleZ_ortho = uicontrol('parent',idcubeml3D.ortho_panel,'style','edit',...
    'Position',[0.75 0.5 0.2 0.3],'FontUnits','Normalized','foregroundcolor',fgc,'backgroundcolor',main_bgc,'String','1','Visible','On','Callback',@scale_ortho); 
%Slice panel
idcubeml3D.slice_panel =  uipanel('parent',idcubeml3D.figure,'Position',[600, 30, dimX-300, 100],'FontSize', 10,...
          'title','Slicer of axes');

idcubeml3D.slicer=  uipanel('parent',idcubeml3D.slice_panel,...
'position',[0.048148148148148,0.2,0.904320987654321,0.7],'fontsize',10,'backgroundcolor','white',...
'title','Slicer of axes');

%%new slider

idcubeml3D.slice_x = uislider('Parent', idcubeml3D.slice_panel, ...
    'Position', [100 50 100 3], 'Limits', [0 100], 'Value', 50, 'Visible', 'off', ...
    'Tooltip', 'Select the isovalue (range 0 to 1)', 'ValueChangedFcn', @(src, event) slice_x_CallBack(src));
% 
% idcubeml3D.slice_x = uicontrol('parent',idcubeml3D.slicer,'style','slider','min',0,'max',100,...
% 'value',50,'sliderstep',[step_min step_max],'position',[0.113829787234043,0.652534562211981,0.8,0.15],'Visible','Off',...
%  'fontsize',10,'BackgroundColor',layer1_bgc);
% addlistener( idcubeml3D.slice_x, 'Value', 'PostSet',@slice_x_CallBack);
idcubeml3D.slice_y = uislider('Parent', idcubeml3D.slice_panel, ...
    'Position', [220 50 100 3], 'Limits', [0 100], 'Value', 50, 'Visible', 'off', ...
    'Tooltip', 'Select the isovalue (range 0 to 1)', 'ValueChangedFcn', @(src, event) slice_y_CallBack(src));
% addlistener( idcubeml3D.slice_y, 'Value', 'PostSet',@slice_y_CallBack);
idcubeml3D.slice_z = uislider('Parent', idcubeml3D.slice_panel, ...
    'Position', [340 50 100 3], 'Limits', [0 100], 'Value', 50, 'Visible', 'off', ...
    'Tooltip', 'Select the isovalue (range 0 to 1)', 'ValueChangedFcn', @(src, event) slice_z_CallBack(src));
% addlistener( idcubeml3D.slice_y, 'Value', 'PostSet',@slice_y_CallBack;
% addlistener( idcubeml3D.slice_z, 'Value', 'PostSet',@slice_z_CallBack);

%% back top the original Image
setappdata(0, 'val', 1)

setappdata(0,'handle',idcubeml3D)
sliderFlag2=0;
setappdata(0,'sliderFlag2',sliderFlag2)


new_setup(idcubeml3D)
setappdata(0,'handle',idcubeml3D)
% if out~=2 && out~=3
%  setappdata(0,'handle',idcubeml3D)
% end

set(idcubeml3D.figure,'CloseRequestFcn',@idcubeml3D_CloseRequestFcn)

i = getappdata(0,'im');

filenames=getappdata(0,'windows');
filenames{i}='3D viewer';
uimenu(idcubeml.menuWindows,'Label',filenames{i},'callback',@show_3d);
idcubeml.menuWindows.Children(end:-1:1) = idcubeml.menuWindows.Children(:);
setappdata(0,'k',i)
i=i+1;
setappdata(0,'im',i)
setappdata(0,'windows',filenames)
out = varargin{3};
setappdata(0,'icon',out)
setappdata(0,'slice2',0)
end
function show_3d(varargin)
idcubeml3D = getappdata(0,'handle');
figure(idcubeml3D.figure)
end
function original(hObject, eventdata,idcubeml3D)
main_bgc=getappdata(0,'main_bgc');
layer1_bgc=getappdata(0,'layer1_bgc');
layer2_bgc=getappdata(0,'layer2_bgc');
layer3_bgc=getappdata(0,'layer3_bgc');
btn_color=getappdata(0,'btn_color');
fgc=getappdata(0,'fgc');
bgc = getappdata(0,'bgc');

idcubeml3D= getappdata(0,'handle');
delete(idcubeml3D.imageDisplayPanel)
idcubeml3D.imageDisplayPanel = uipanel('parent',idcubeml3D.figure,'position',[20, 20, 400, 400],...
'bordertype','none','title','',...
'FontSize', 11,'backgroundcolor',main_bgc,'Visible','On');

idcubeml3D.axes_input = axes('parent',idcubeml3D.imageDisplayPanel ,'units','Normalized',...
'Position', [0.01 0.01 0.98 0.98],'DataAspectRatioMode','auto',...
'XTick',[], 'YTick',[]);
setappdata(0,'handle',idcubeml3D)

new_setup()
end

function idcubeml3D_CloseRequestFcn(hObject, eventdata,idcubeml3D)
main_bgc=getappdata(0,'main_bgc');
fgc=getappdata(0,'fgc');
idcubemlexit.figure = figure('position', [800 500 300 100],...
    'color',main_bgc,'numbertitle','off','name','3D: Exit');
set(idcubemlexit.figure, 'MenuBar', 'none');
set(idcubemlexit.figure, 'ToolBar', 'none');
set(idcubemlexit.figure, 'KeyPressFcn', {@pressed})

folder = fileparts(mfilename('fullpath'));
iconFilePath = fullfile(folder, 'Images', 'idcube-icon-transparent.png');
setIcon(idcubemlexit.figure, iconFilePath);

    
    uicontrol('parent',idcubemlexit.figure,'style','text','string','Are you sure you want to exit?','foregroundcolor', fgc,'backgroundcolor', main_bgc*0.9,'unit','normalized','position',[0.2 0.5 0.6 0.3],'background', main_bgc);
    vegInd.slice2 =  uicontrol('parent',idcubemlexit.figure,'style','pushbutton','string','YES',...
        'position',[0.07 0.15 0.4 0.4],'FontUnits','Normalized', 'backgroundcolor',[77/255 194/255 115/255],'foreground','w',...
        'Callback',@ButtonPushed_Yes);
    set(vegInd.slice2, 'KeyPressFcn', {@pressed}) 
    vegInd.slice2 =  uicontrol('parent',idcubemlexit.figure,'style','pushbutton','string','NO',...
        'position',[0.55 0.15 0.4 0.4],'FontUnits','Normalized','backgroundcolor',[173/255 103/255 111/255],'foreground','w',...
        'Callback',@ButtonPushed_No);
  

    idcubemlexit.figure.WindowStyle = 'modal';
    idcubemlexit.figure.AutoResizeChildren='off';
    idcubemlexit.figure.Resize='off';
    function pressed(varargin)
        key = get(gcf,'CurrentKey');
       if(strcmp (key , 'return'))
           ButtonPushed_Yes()

       end
    end
 
    function value=ButtonPushed_Yes(src,event)
         k = getappdata(0,'k');
         i= getappdata(0,'im');
         filenames=getappdata(0,'windows');
         %filenames{k}=[];
          idcubeml = getappdata(0,'idcubeoneHandle');
         %if ~isempty(get(idcubeml.menuWindows.Children(k)))
        
%          h  =idcubeml.menuWindows.Children(k);
         delete(findall(idcubeml.menuWindows,'Label','3D viewer'))
         setappdata(0,'windows',filenames)
         %setappdata(0,'i',i-1)
         %end
%          uimenu(idcubeml.menuWindows,'Label',filenames{k});
         delete(gcf)
         
         closereq

    end
    function value=ButtonPushed_No(src,event)
        
          closereq

    end  

end

%%Resize
%% 
function three_int(hObject, eventdata)

idcubeml3D= getappdata(0,'handle');
set(idcubeml3D.menuEdit3D,'Checked','on')
plotedit(idcubeml3D.axes_input,'on')

end
function axes_color(hObject, eventdata)
bgc = uisetcolor('Select a color');
idcubeml3D= getappdata(0,'handle');
if bgc==0
    bgc = getappdata(0,'bgc');
    setappdata(0,'color_back',bgc)
else
    
   setappdata(0,'color_back',bgc)
end
set(idcubeml3D.axes_input,'color',bgc)
end
function axes_colorbar(src,event)
idcubeml3D= getappdata(0,'handle');
colormap(idcubeml3D.axes_input,getappdata(0,'color'));
    %title('Original');
    
colorbar('HitTest','On','Selected','on');
end
function axes_colorbar2(src,event)
idcubeml3D = getappdata(0,'handle');
colormap(idcubeml3D.axes_input,getappdata(0,'color'));
    %title('Original');
    
colorbar('HitTest','On','Selected','off');
plotedit(idcubeml3D.axes_input,'off')
end
function manage_int(hObject, eventdata)
idcubeml3D= getappdata(0,'handle');
% set(idcubeml3D.menuEditmanage,'Checked','on')
plotedit(idcubeml3D.axes_input,'off')

end

%%Get the original Image
function new_setup(varargin)

main_bgc=getappdata(0,'main_bgc');
layer1_bgc=getappdata(0,'layer1_bgc');
layer2_bgc=getappdata(0,'layer2_bgc');
layer3_bgc=getappdata(0,'layer3_bgc');
btn_color=getappdata(0,'btn_color');
fgc=getappdata(0,'fgc');
bgc = getappdata(0,'bgc');

idcubeml3D= getappdata(0,'handle');
idcubeoneHandle=getappdata(0,'idcubeoneHandle');
axes(idcubeml3D.axes_input);
dis=0;
set(findall(idcubeml3D.interactive_panel , '-property', 'enable'), 'enable', 'off')
set(findall(idcubeml3D.color_channel, '-property', 'enable'), 'enable', 'off')
set(findall(idcubeml3D.slice_panel, '-property', 'enable'), 'enable', 'off')
set(findall(idcubeml3D.ortho_panel, '-property', 'enable'), 'enable', 'off')
bgc=getappdata(0,'bgc');
setappdata(0,'Display_axes',dis)
if get(idcubeoneHandle.radioButtonRGBMode,'Value')==1
    Im=getappdata(0,'Irgb');
    matrices=getappdata(0,'myData');
    Images= matrices.Images;
    maximum=max(Images(:));
    [x,y,z]=size(Images);

    value.x=x/2;
    value.y=y/2;
    value.z=z/2;
    setappdata(0,'value2',value)
    out=getappdata(0,'icon');
    if out ==1
        imshow(Im,[]);
        title('Original Image', 'Color', fgc, 'fontweight', 'normal');
    elseif out==2
        slice_callback()
    elseif out==3
        orthogonal_slice_callback()
    else
        imshow(Im,[]);
        title('Original Image', 'Color', fgc, 'fontweight', 'normal');
    end
   
   
    Im = size(Images);
   
    binnumber1 = Im(1)/3; %number of row bins
    binnumber2 = Im(2)/3;
    binnumber3 = Im(3)/3;%number of column bins
    L1 = Im(1)/binnumber1; %length of row bin
    L2 = Im(2)/binnumber2; %length of column bin
    L3=Im(3)/binnumber3;
    tot= binnumber1+binnumber2+binnumber3; 
    sliderflag2 = getappdata(0,'sliderFlag2');
    if sliderflag2 ==0
        waitbarHandle = waitbar(0,'Please wait...','name','Spatial-Spectral Binning...');
    try
        jframe=get(waitbarHandle,'javaframe');
        if ispc
            iconFilePath = 'Images\idcube-icon-transparent.png'; % For Windows
        else
            iconFilePath = 'Images/idcube-icon-transparent.png'; % For Mac
        end
        jIcon=javax.swing.ImageIcon(iconFilePath); % <- replace with correct filename
        jframe.setFigureIcon(jIcon);
    catch
    end
         for j = 1:floor(binnumber1)
            newImage(j,:,:) = sum(Images(ceil(L1*(j-1))+1:floor(L1*j),:,:),1)/(L1*(j)-(L1*(j-1)+1));
            display_waitbar(1,1,j,floor(tot), waitbarHandle);
         end
    
        for j = 1:floor(binnumber2)
            newImage2(:,j,:) = sum(newImage(:,ceil(L2*(j-1))+1:floor(L2*j),:),2)/(L2*(j)-(L2*(j-1)+1));
            display_waitbar(1,1,floor(binnumber1)+j,floor(tot), waitbarHandle);
        end
          for j = 1:floor(binnumber3)
            newImage3(:,:,j) = sum(newImage2(:,:,ceil(L3*(j-1))+1:floor(L3*j)),3)/(L3*(j)-(L3*(j-1)+1));
            display_waitbar(1,1,floor(binnumber2)+j,floor(tot), waitbarHandle);
         end
        if isvalid(waitbarHandle)
            display_waitbar(1,1,100,100, waitbarHandle);
        end
         Image = newImage3;
         current_matrices.Images = Image;
    %current_matrices.Wavelengths = wavelengths;
         setappdata(0,'myData3', current_matrices);%%Only for slicing 
    end
    [hrgb, wrgb, ~] = size(Im);
    if out~=2&&out~=3
      imgzoompan(gcf, 'ImgWidth', wrgb, 'ImgHeight', hrgb);
      set(idcubeml3D.axes_input,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[],'Visible','On','color',bgc);
    end
    setappdata(0,'OImage',Im);
    maximum=max(Images(:));
    minimum=min(Images(:));
    avg=(maximum+minimum)/2;
    setappdata(0,'upper_2',maximum);
    setappdata(0,'lower_1',minimum);
    setappdata(0,'avg',avg);
    set(idcubeml3D.scaleX,'String','1')
    set(idcubeml3D.scaleY,'String','1')
    set(idcubeml3D.scaleZ,'String','1')
    setappdata(0,'sliderFlag2',1);
    %setappdata(0,'myData3', matrices)
else
    I = getappdata(0,'I');
    matrices=getappdata(0,'myData');
    Images= matrices.Images;
    Image=matrices.Images;
    
    %bin = str2num(get(idcubeoneHandle.binEditSB,'String'));
    Im = size(Image);
   
    binnumber1 = Im(1)/3; %number of row bins
    binnumber2 = Im(2)/3;
    binnumber3 = Im(3)/3;%number of column bins
    L1 = Im(1)/binnumber1; %length of row bin
    L2 = Im(2)/binnumber2; %length of column bin
    L3=Im(3)/binnumber3;
    tot= binnumber1+binnumber2+binnumber3; 
    sliderflag2 = getappdata(0,'sliderFlag2');
    if sliderflag2 ==0
        waitbarHandle = waitbar(0,'Please wait...','name','Spatial-Spectral Binning...');
    try
        jframe=get(waitbarHandle,'javaframe');
        if ispc
            iconFilePath = 'Images\idcube-icon-transparent.png'; % For Windows
        else
            iconFilePath = 'Images/idcube-icon-transparent.png'; % For Mac
        end
        jIcon=javax.swing.ImageIcon(iconFilePath); % <- replace with correct filename
        jframe.setFigureIcon(jIcon);
    catch
    end
         for j = 1:floor(binnumber1)
            newImage(j,:,:) = sum(Image(ceil(L1*(j-1))+1:floor(L1*j),:,:),1)/(L1*(j)-(L1*(j-1)+1));
            display_waitbar(1,1,j,floor(tot), waitbarHandle);
         end
    
        for j = 1:floor(binnumber2)
            newImage2(:,j,:) = sum(newImage(:,ceil(L2*(j-1))+1:floor(L2*j),:),2)/(L2*(j)-(L2*(j-1)+1));
            display_waitbar(1,1,floor(binnumber1)+j,floor(tot), waitbarHandle);
        end
          for j = 1:floor(binnumber3)
            newImage3(:,:,j) = sum(newImage2(:,:,ceil(L3*(j-1))+1:floor(L3*j)),3)/(L3*(j)-(L3*(j-1)+1));
            display_waitbar(1,1,floor(binnumber2)+j,floor(tot), waitbarHandle);
         end
        if isvalid(waitbarHandle)
            display_waitbar(1,1,100,100, waitbarHandle);
        end
         Image = newImage3;
         current_matrices.Images = Image;
    %current_matrices.Wavelengths = wavelengths;
         setappdata(0,'myData3', current_matrices);%%Only for slicing 
    end
       out=getappdata(0,'icon');
    if out ==1
         imshow(I,[]);
         title('Original Image', 'FontWeight','normal', 'Color',fgc);
    elseif out==2
        slice_callback()
    elseif out==3
        orthogonal_slice_callback()
    else
        imshow(I,[]);
         title('Original Image', 'FontWeight','normal', 'Color',fgc);
    end
   
     
    maximum=max(Images(:));
    minimum=min(Images(:));
    avg=(maximum+minimum)/2;
    setappdata(0,'upper_2',maximum);
    setappdata(0,'lower_1',minimum);
    setappdata(0,'avg',avg);
    [x,y,z]=size(Images);
 
    value.x=x/2;
    value.y=y/2;
    value.z=z/2;
    setappdata(0,'value2',value)
    
    [hrgb, wrgb, ~] = size(I);
       if out~=2 && out~=3
           imgzoompan(gcf, 'ImgWidth', wrgb, 'ImgHeight', hrgb);
           set(idcubeml3D.axes_input,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[],'Visible','On','color',bgc);
           colormap(idcubeml3D.axes_input,getappdata(0,'color'));
    %title('Original');
    
           colorbar('HitTest','On');
      end
  
 
    setappdata(0,'OImage',I);
    setappdata(0,'myData_original',matrices)
    setappdata(0,'sliderFlag2',1);
end

end
%%

%% Original callback Function
function original_callback(hObject, eventdata,idcubemlH)
Im = getappdata(0,'Current');
idcubemlH = getappdata(0,'handle');
dis = getappdata(0,'Display_axes');
original_3d_callback(1,1,idcubemlH,dis)

end
%% k-means
% function Kmeans_callback(varargin)
% original_callback;
%     kmeans.fig = figure('Name', '3D K-Means parameters', 'NumberTitle', 'off', 'units', 'normalized', 'Position', [0.4 0.5 0.35 0.13]);
%     green_btn = [77, 194, 115] / 255;
%     kmeans.fig.MenuBar = 'none';
%     kmeans.WindowStyle = 'modal';
%     kmeans.AutoResizeChildren = 'off';
%     kmeans.Resize = 'off';
% 
%     folder = fileparts(mfilename('fullpath'));
%     iconFilePath = fullfile(folder, 'Images', 'idcube-icon-transparent.png');
%     setIcon(kmeans.fig, iconFilePath);
% 
%     kmeans_text = uicontrol(kmeans.fig, 'Style', 'text', 'backgroundcolor', get(kmeans.fig, 'color'), 'Position', [0.35 0.5 0.4 0.3], 'string', 'Max iterations ', 'Fontsize', 10, 'foregroundcolor', 'w');
%     kmeans.iter = uicontrol(kmeans.fig, 'Style', 'edit', 'Position', [0.45 0.35 0.25 0.2], 'backgroundcolor', [1 1 1], 'string', 20);
%     
%     cluster_text = uicontrol(kmeans.fig, 'Style', 'text', 'backgroundcolor', get(kmeans.fig, 'color'), 'Position', [0.05 0.5 0.4 0.3], 'string', 'Cluster number ', 'Fontsize', 10, 'foregroundcolor', 'w');
%     kmeans.cluster = uicontrol(kmeans.fig, 'Style', 'edit', 'Position', [0.12 0.35 0.25 0.2], 'backgroundcolor', [1 1 1], 'string', 2);
% 
%     kmeans_apply = uicontrol(kmeans.fig, 'Style', 'pushbutton', 'Position', [0.75 .15 0.22 0.22], 'string', 'Apply', 'backgroundcolor', green_btn, 'foregroundcolor', 'w', 'FontUnits', 'Normalized', 'callback', @kmeans_Apply);
%     setappdata(0, 'idcubekmeans', kmeans);
% end

function Kmeans_callback(varargin)
    original_callback;
    kmeans.fig = uifigure('Name', '3D Segmentation Parameters', ...
        'NumberTitle', 'off', ...
        'units', 'pixels', ...
        'Position', [100, 100, 400, 150], ...
        'MenuBar', 'none', ...
        'WindowStyle', 'modal', ...
        'AutoResizeChildren', 'off', ...
        'Resize', 'off', ...
        'Icon', 'idcube-icon-transparent.png');
    
    green_btn = [77, 194, 115] / 255;
    
     
    kmeans_text = uilabel(kmeans.fig, ...
        'Position', [180, 75, 120, 30], ...
        'Text', 'Max iterations', ...
        'FontSize', 10, ...
        'FontColor', 'w', ...
        'BackgroundColor', kmeans.fig.Color);
    
    kmeans.iter = uieditfield(kmeans.fig, 'numeric', ...
        'Position', [180, 50, 100, 25], ...
        'BackgroundColor', [1 1 1], ...
        'Value', 20);
    
    cluster_text = uilabel(kmeans.fig, ...
        'Position', [60, 75, 120, 30], ...
        'Text', 'Cluster number', ...
        'FontSize', 10, ...
        'FontColor', 'w', ...
        'BackgroundColor', kmeans.fig.Color);
    
    kmeans.cluster = uieditfield(kmeans.fig, 'numeric', ...
        'Position', [50, 50, 100, 25], ...
        'BackgroundColor', [1 1 1], ...
        'Value', 2);
    
    kmeans_apply = uibutton(kmeans.fig, ...
        'Position', [300, 20, 80, 40], ...
        'Text', 'Apply', ...
        'BackgroundColor', green_btn, ...
        'FontColor', 'w', ...
        'FontSize', 10, ...
        'ButtonPushedFcn', @kmeans_Apply);
    
    setappdata(0, 'idcubekmeans', kmeans);
end


function kmeans_Apply(varargin)
    % Retrieve image data to perform K-means on
    matrices = getappdata(0, 'myData'); % Make sure this retrieves the correct image data
    Images = matrices.Images;

    kmeans = getappdata(0, 'idcubekmeans');
    idcubeml3D = getappdata(0, 'handle');

    % Disable interactive controls
    set(findall(idcubeml3D.interactive_panel, '-property', 'enable'), 'enable', 'off');
    set(findall(idcubeml3D.color_channel, '-property', 'enable'), 'enable', 'off');
    set(findall(idcubeml3D.slice_panel, '-property', 'enable'), 'enable', 'off');
    set(findall(idcubeml3D.ortho_panel, '-property', 'enable'), 'enable', 'off');
    
    waitbarHandle = waitbar(0, 'Please wait...', 'name', 'Applying K-Means segmentation...');
    display_waitbar(1, 1, 20, 100, waitbarHandle);

    iter = get(kmeans.iter, 'Value');
    k = get(kmeans.cluster, 'Value');
    display_waitbar(1, 1, 80, 100, waitbarHandle);

    % Apply K-means segmentation
    L = imsegkmeans3(uint16(Images), k, 'MaxIterations', iter);

    % Check unique labels
    unique_labels = unique(L);
    disp(unique_labels);

    % Create custom colormap with enough distinct colors
    num_unique_labels = length(unique_labels);
    colormap2 = jet(256); % Ensure colormap has 256 colors

    % Define initial alphamap
    alphamap = linspace(0, 1, 256)'; % Simple linear alphamap from 0 to 1, as a column vector

    % Display segmented volume
    if idcubeml3D.volume_render.Value == 2
        val = get(idcubeml3D.iso_slider1, 'Value');
        V = volshow(L, 'Parent', idcubeml3D.imageDisplayPanel, 'Colormap', colormap2, 'Alphamap', alphamap, 'IsosurfaceValue', val, 'RenderingStyle', 'Isosurface');
            % Update the label with the current value of val
             labelStr = sprintf('Iso Value: %.3f', val);  % Format the label string
             set(idcubeml3D.iso_label_slider, 'String', labelStr, 'Visible', 'on');
    else
        V = volshow(L, 'Parent', idcubeml3D.imageDisplayPanel, 'Colormap', colormap2, 'Alphamap', alphamap);
    end

    display_waitbar(1, 1, 100, 100, waitbarHandle);

    % Finalize
    setappdata(0, 'V', V);
    setappdata(0, 'handle', idcubeml3D);
    setappdata(0, 'sliderFlag', 1);

    set(idcubeml3D.scaleX, 'String', '1');
    set(idcubeml3D.scaleY, 'String', '1');
    set(idcubeml3D.scaleZ, 'String', '1');
    
    kmeans = getappdata(0, 'idcubekmeans');
    delete(kmeans.fig);

    % Create a uifigure to display the segmented slice and UI controls
    slicefig = uifigure('Name', 'Segmented Slice Viewer', ...
        'NumberTitle', 'off', ...
        'Position', [300 300 600 500], ...
        'Icon', 'idcube-icon-transparent.png', ...
        'Color', [0.9 0.9 0.9]);
    
    % Default to middle slice if user cancels input
    default_slice_num = round(size(L, 3) / 2);
    
    % Create an axes for the image display
    ax = uiaxes('Parent', slicefig, 'Position', [20 100 560 380]);
    
    % Initial display
    imagesc(ax, L(:, :, default_slice_num));
    colormap(ax, colormap2);
    colorbar(ax);
    axis(ax, 'image'); % Ensures the aspect ratio is maintained
    ax.XLim = [0.5 size(L, 2) + 0.5];
    ax.YLim = [0.5 size(L, 1) + 0.5];

    % Create UI controls for slice number input
%     uilabel(slicefig, 'Text', 'Enter slice number:', 'Position', [20 60 120 30]);
    uilabel(slicefig, 'Text', sprintf('Enter slice number in range: 1-%d', size(L, 3)), 'Position', [20 60 200 30]);
    slice_edit = uieditfield(slicefig, 'numeric', 'Value', default_slice_num, 'Limits', [1 size(L, 3)], 'Position', [260 60 100 30]);
    uibutton(slicefig, 'Text', 'Update Slice', 'Position', [370 60 150 30], ...
             'ButtonPushedFcn', @(src, event) update_slice_display(L, colormap2, slice_edit, ax));
    
    % Create UI controls for cluster selection
    uilabel(slicefig, 'Text', 'Enter cluster number:', 'Position', [20 20 120 30]);
    cluster_edit = uieditfield(slicefig, 'numeric', 'Value', 1, 'Limits', [1 num_unique_labels], 'Position', [150 20 100 30]);
    uibutton(slicefig, 'Text', 'Show Cluster', 'Position', [260 20 100 30], ...
             'ButtonPushedFcn', @(src, event) show_cluster(L, cluster_edit.Value, colormap2, slice_edit.Value, ax));
    uibutton(slicefig, 'Text', 'Show Cluster in 3D', 'Position', [370 20 150 30], ...
             'ButtonPushedFcn', @(src, event) show_cluster_3D(L, cluster_edit.Value, colormap2));

    

    function update_slice_display(L, colormap2, slice_edit, ax)
        slice_num = slice_edit.Value;
        if slice_num < 1 || slice_num > size(L, 3)
            uialert(slicefig, sprintf('Please enter a valid slice number between 1 and %d', size(L, 3)), 'Invalid Slice Number');
            slice_num = default_slice_num;
        end
        
        % Display the specified slice
        imagesc(ax, L(:, :, slice_num));
        colormap(ax, colormap2);
%         colorbar(ax);
        axis(ax, 'image'); % Ensures the aspect ratio is maintained
        ax.XLim = [0.5 size(L, 2) + 0.5];
        ax.YLim = [0.5 size(L, 1) + 0.5];
    end

    function show_cluster(L, cluster_num, colormap2, slice_num, ax)
        % Create a binary mask for the selected cluster
        cluster_mask = L == cluster_num;
        
        % Display the specified cluster
        imagesc(ax, cluster_mask(:, :, slice_num));
        colormap(ax, [1 1 1; colormap2(cluster_num, :)]);
%         colorbar(ax);
        axis(ax, 'image'); % Ensures the aspect ratio is maintained
        ax.XLim = [0.5 size(L, 2) + 0.5];
        ax.YLim = [0.5 size(L, 1) + 0.5];
    end

function show_cluster_3D(L, cluster_num, colormap2)
    % Create a new uifigure for the 3D display
    cluster_fig = uifigure('Name', sprintf('3D Cluster %d', cluster_num), ...
        'NumberTitle', 'off', ...
        'Position', [100 100 800 600], ...
        'Color', [0.9 0.9 0.9], ...
        'Icon', 'idcube-icon-transparent.png');

    % Create a uipanel for the volshow
    cluster_panel = uipanel(cluster_fig, 'Position', [20 60 760 510]);

    % Display the initial volume in grey
    V_init = volshow(L, 'Parent', cluster_panel, 'Colormap', gray(256), 'IsoSurfacevalue', 0.5);
    
    % Pause to let the grey image render
    pause(2); % Adjust the pause duration as needed

    % Create a binary mask for the selected cluster
    cluster_mask = L == cluster_num;

    % Define colormap and alphamap for 3D display
    cluster_colormap = [0.0 0 0; colormap2(cluster_num, :)]; % Black for background, color for cluster
    % Expand colormap to 256 colors
    extended_colormap = [repmat(cluster_colormap(1, :), 255, 1); cluster_colormap(2, :)];
    cluster_alphamap = [zeros(255, 1); 1]; % Transparent background, opaque cluster

    % Display the selected cluster in 3D
    V_cluster = volshow(cluster_mask, 'Parent', cluster_panel, ...
        'Colormap', autumn(256), ...
        'Alphamap', cluster_alphamap, ...
        'IsoSurfacevalue', 0.8, ...
        'RenderingStyle', 'MaximumIntensityProjection');

    camlight;
    lighting flat;
    lighting gouraud;

    % Add dropdown list for colormaps
    colormap_dropdown = uidropdown(cluster_fig, ...
        'Position', [20 20 120 25], ...
        'Items', {'autumn', 'jet', 'hsv', 'cool', 'spring', 'summer', 'winter', 'gray', 'hot', 'parula'}, ...
        'Value', 'autumn');

        % Add button to change the color of V_init
    change_button_init = uibutton(cluster_fig, ...
        'Position', [170 20 150 25], ...
        'Text', 'Change Backround Color', ...
        'ButtonPushedFcn', @(btn, event) changeColormap(V_init, colormap_dropdown.Value));

    % Add button to change the color of V_cluster
    change_button_cluster = uibutton(cluster_fig, ...
        'Position', [340 20 150 25], ...
        'Text', 'Change Cluster Color', ...
        'ButtonPushedFcn', @(btn, event) changeColormap(V_cluster, colormap_dropdown.Value));



    % Add slider to adjust the brightness of V_cluster
    brightness_slider = uislider(cluster_fig, ...
        'Position', [530 25 150 3], ...
        'Limits', [0, 1], ...
        'Value', 0.8, ...
        'FontSize', 7,...
        'ValueChangedFcn', @(sld, event) changeBrightness(V_cluster, sld.Value));
    
    % Label for the brightness slider
    uilabel(cluster_fig, 'Position', [530 30 150 22], 'Text', 'Brightness');


%      % Add button to start rotation
%     rotate_button = uibutton(cluster_fig, ...
%         'Position', [700 20 80 25], ...
%         'Text', 'Rotate', ...
%         'ButtonPushedFcn', @(btn, event) startRotation(cluster_panel));

     % Add button to copy the image to clipboard
    copy_button = uibutton(cluster_fig, ...
        'Position', [700 20 80 25], ...
        'Text', 'Copy', ...
        'ButtonPushedFcn', @(btn, event) copyToClipboard(cluster_fig));


   % Calculate and display the number of voxels
    total_voxels = nnz(L);
    cluster_voxels = nnz(cluster_mask);
%     uilabel(cluster_fig, 'Position', [20 650 300 22], ...
%         'Text', sprintf('Total Voxels: %d', total_voxels));
%     uilabel(cluster_fig, 'Position', [20 620 300 22], ...
%         'Text', sprintf('Cluster %d Voxels: %d', cluster_num, cluster_voxels));

     % Display the number of voxels in a uitable
    data = {'Total Voxels', total_voxels; sprintf('Cluster %d Voxels', cluster_num), cluster_voxels};
    t = uitable(cluster_fig, 'Data', data, ...
        'ColumnName', {'Type', 'Count'}, ...
        'Position', [550 70 220 65]);
% Set font size for the entire table
set(t, 'FontSize', 9, 'backgroundcolor', [0.9 0.9 0.9]);

end

function changeColormap(vol, colormap_name)
    % Update the colormap based on the selected value
    colormap_func = str2func(colormap_name);
    vol.Colormap = colormap_func(256);
end

function changeBrightness(vol, brightness)
    % Update the alphamap based on the brightness
    alphamap = [zeros(255, 1); brightness];
    vol.Alphamap = alphamap;
end

    function startRotation(panel)
    % Create and start a timer to rotate the image around the z-axis
    t = timer('ExecutionMode', 'fixedRate', 'Period', 0.05, 'TimerFcn', @(~,~) rotateImage(panel));
    start(t);
end

function rotateImage(panel)
    % Rotate the view around the z-axis
    ax = panel.Children;
    current_view = get(ax, 'View');
    new_az = current_view(1) + 2; % Increment azimuth angle faster
    set(ax, 'View', [new_az, current_view(2)]);
end
    function copyToClipboard(fig)
    % Capture the current figure as an image
    frame = getframe(fig);
    img = frame.cdata;
    
    % Create a temporary file
    temp_file = [tempname, '.png'];
    
    % Save the image to the temporary file
    imwrite(img, temp_file);
    
    % Copy the image file to the clipboard (only works on Windows)
    if ispc
        system(['powershell -command "Add-Type -AssemblyName System.Windows.Forms; ' ...
                '$img = [System.Drawing.Image]::FromFile(''', temp_file, '''); ' ...
                '[System.Windows.Forms.Clipboard]::SetImage($img);"']);
    else
        errordlg('Copy to clipboard is only supported on Windows.');
    end
    
    % Delete the temporary file
    delete(temp_file);
end

end


 

%%Original 3-D callback

function original_3d_callback(varargin)
    main_bgc = getappdata(0, 'main_bgc');
    layer1_bgc = getappdata(0, 'layer1_bgc');
    layer2_bgc = getappdata(0, 'layer2_bgc');
    layer3_bgc = getappdata(0, 'layer3_bgc');
    btn_color = getappdata(0, 'btn_color');
    fgc = getappdata(0, 'fgc');
    bgc = getappdata(0, 'bgc');

    idcubeml3D = getappdata(0, 'handle');

    % Enable the 'K-Means 3D' button
    set(idcubeml3D.new_btn, 'Enable', 'on');
    display = varargin{4};
    display=0;
    setappdata(0, 'Display_axes', display);
    new = getappdata(0, 'color_back');
    set(findall(idcubeml3D.interactive_panel, '-property', 'enable'), 'enable', 'on');
    set(findall(idcubeml3D.color_channel, '-property', 'enable'), 'enable', 'on');
    set(findall(idcubeml3D.slice_panel, '-property', 'enable'), 'enable', 'off');
    set(findall(idcubeml3D.ortho_panel, '-property', 'enable'), 'enable', 'off');
    if new ~= 0
        bgc = getappdata(0, 'color_back');
    else
        bgc = getappdata(0, 'bgc');
    end
    set(idcubeml3D.slice_x, 'Enable', 'off');
    set(idcubeml3D.slice_y, 'Enable', 'off');
    set(idcubeml3D.slice_z, 'Enable', 'off');
    set(idcubeml3D.figure, 'WindowButtonDownFcn', '', ...
        'WindowButtonMotionFcn', '', ...
        'WindowScrollWheelFcn', '', ...
        'KeyPressFcn', '', ...
        'WindowButtonUpFcn', '');
    tool = findall(idcubeml3D.figure, 'tag', 'lb');
    set(tool, 'Visible', 'Off');
    set(tool, 'Visible', 'Off');
    set(idcubeml3D.alpha_built, 'Value', 'linear');
    set(idcubeml3D.color2, 'Value', 'lightgray');
    if display == 0
        matrices = getappdata(0, 'myData');
        Images = matrices.Images;
        delete(idcubeml3D.imageDisplayPanel);
        idcubeml3D.imageDisplayPanel = uipanel('parent', idcubeml3D.figure, 'position', [20, 20, 400, 400], ...
            'FontUnits', 'Normalized', 'bordertype', 'none', 'title', '', ...
            'backgroundcolor', bgc, 'Visible', 'On');

        idcubeml3D.axes_input = axes('parent', idcubeml3D.imageDisplayPanel, 'units', 'Normalized', ...
            'Position', [0.01 0.01 0.98 0.98], 'FontUnits', 'Normalized', 'DataAspectRatioMode', 'auto', ...
            'XTick', [], 'YTick', []);

        set(gca, 'color', bgc);
        set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none');
        s_min_in1 = str2double(getappdata(0, 'lower_1'));
        s_min_in2 = str2double(getappdata(0, 'lower_2'));
        s_max_in1 = str2double(getappdata(0, 'upper_1'));
        s_max_in2 = getappdata(0, 'upper_2');
        avg = getappdata(0, 'avg');
        intensity = [-3224, -16.45, avg, s_max_in2];
        alpha = [0, 0.2, 0.2, 1];
        h = load('trans0.mat');
        y = struct2cell(h);

        hsidata = y{1};
        y = struct2cell(hsidata);
        alphamap = y{8};
        color = ([0 0 1; 0 1 0; 1 0 0; 1 1 0]);  % Blue, Green, Red, Yellow
        queryPoints = linspace(min(intensity), max(intensity), 256);
        axdrag;

        colormap2 = gray;

        opengl hardware;
        if idcubeml3D.volume_render.Value == 2
            val = get(idcubeml3D.iso_slider1, 'Value');
%             V = volshow(Images, 'Parent', idcubeml3D.imageDisplayPanel, 'Colormap', colormap2, 'Alphamap', alphamap, 'Isovalue', val, 'Renderer', 'Isosurface');
            V= volshow(Images,'Parent',idcubeml3D.imageDisplayPanel,'IsosurfaceValue',val,'RenderingStyle', 'Isosurface','Colormap','r');

            % Update the label with the current value of val
    labelStr = sprintf('Iso Value: %.3f', val);  % Format the label string
    set(idcubeml3D.iso_label_slider, 'String', labelStr, 'Visible', 'on');
        else
            V = volshow(Images, 'Parent', idcubeml3D.imageDisplayPanel, 'Colormap', colormap2, 'Alphamap', alphamap);
        end

        VAxis = [0.2, 1.5];
        setappdata(0, 'V', V);
        camtarget;
        newscale = linspace(min(Images(:)) - min(VAxis(:)), ...
            max(Images(:)) - min(VAxis(:)), size(colormap2, 1)) / diff(VAxis);
        newscale(newscale < 0) = 0;
        newscale(newscale > 1) = 1;
        V.Colormap = interp1(linspace(0, 1, size(colormap2, 1)), colormap2, newscale);
        setappdata(0, 'handle', idcubeml3D);
        setappdata(0, 'sliderFlag', 1);
        set(idcubeml3D.scaleX, 'String', '1');
        set(idcubeml3D.scaleY, 'String', '1');
        set(idcubeml3D.scaleZ, 'String', '1');
        set(idcubeml3D.axes_inten, 'Visible', 'On');

        point = 1:256;
        alphamap2 = alphamap.'; % Here the point that will have the reference lines

plot(idcubeml3D.axes_inten, point, alphamap2, '-o', 'MarkerSize', 0.5, 'LineWidth', 0.5, 'Color', 'blue');
ax = gca;
ax.FontSize = 7;
ax.Color = layer2_bgc;

% Strictly limit the x-axis dimension from 1 to 256
xlim([1 256]);
ylim([0 1]);

% Set axis limits to ensure they are strictly adhered to
axis([1 256 0 1]);

xlabel('Intensity', 'FontSize', 7, 'Color', fgc);
ylabel('Opacity', 'FontSize', 7, 'Color', fgc);
ax.XColor = fgc;
ax.YColor = fgc;
    else
        [fileName, pathName] = uigetfile({'*.*', 'All Files (*.*)'; ...
            '*.mat', 'MAT (*.mat)'}, ...
            'Select an input image file'); % prompts user to select input files

        path_filename = fullfile(pathName, fileName);
        new = load(path_filename);

        y = struct2cell(new);
        hsidata = y{1};
        if length(hsidata) == 2
            Image = hsidata{1};
            wavelength = hsidata{2};
        else
            if ndims(hsidata) == 3
                Image = hsidata;
                wavelength = 1:size(Image, 3);
            end
        end
        Image(isnan(Image)) = 0;

        % Store data into matrices handle
        matrices2.Images = im2double(Image);

        D = matrices2.Images;
        sliderflag2 = getappdata(0, 'sliderFlag2');

        waitbarHandle = waitbar(0, 'Please wait...', 'name', 'Spatial-Spectral Binning...');
        try
            jframe = get(waitbarHandle, 'javaframe');
            if ispc
                iconFilePath = 'Images\idcube-icon-transparent.png'; % For Windows
            else
                iconFilePath = 'Images/idcube-icon-transparent.png'; % For Mac
            end
            jIcon = javax.swing.ImageIcon(iconFilePath); % <- replace with correct filename
            jframe.setFigureIcon(jIcon);
        catch
        end
        Im = size(D);
        binnumber1 = Im(1) / 3; % number of row bins
        binnumber2 = Im(2) / 3;
        binnumber3 = Im(3) / 3;
        % number of column bins
        L1 = Im(1) / binnumber1; % length of row bin
        L2 = Im(2) / binnumber2;
        L3 = Im(3) / binnumber3; % length of column bin
        tot = binnumber1 + binnumber2 + binnumber3;
        for j = 1:floor(binnumber1)
            newImage(j, :, :) = sum(D(ceil(L1 * (j - 1)) + 1:floor(L1 * j), :, :), 1) / (L1 * (j) - (L1 * (j - 1) + 1));
            display_waitbar(1, 1, j, floor(tot), waitbarHandle);
        end

        for j = 1:floor(binnumber2)
            newImage2(:, j, :) = sum(newImage(:, ceil(L2 * (j - 1)) + 1:floor(L2 * j), :), 2) / (L2 * (j) - (L2 * (j - 1) + 1));
            display_waitbar(1, 1, floor(binnumber1) + j, floor(tot), waitbarHandle);
        end
        for j = 1:floor(binnumber3)
            newImage3(:, :, j) = sum(newImage2(:, :, ceil(L3 * (j - 1)) + 1:floor(L3 * j)), 3) / (L3 * (j) - (L3 * (j - 1) + 1));
            display_waitbar(1, 1, floor(binnumber2) + j, floor(tot), waitbarHandle);
        end
        if isvalid(waitbarHandle)
            display_waitbar(1, 1, 100, 100, waitbarHandle);
        end
        Image = newImage3;
        current_matrices.Images = Image;
        setappdata(0, 'myData4', current_matrices);

        setappdata(0, 'myData2', matrices2);
        s_max_in2 = max(D(:));
        minimum = min(D(:));
        avg = (s_max_in2 + minimum) / 2;
        setappdata(0, 'upper_2', s_max_in2);

        setappdata(0, 'lower_1', minimum);
        setappdata(0, 'avg', avg);
        [x, y, z] = size(D);

        value.x = x / 2;
        value.y = y / 2;
        value.z = z / 2;
        setappdata(0, 'value2', value);
        intensity = [-3224, -16.45, avg, s_max_in2];
        alpha = [0, 0, 0.2, 1];
        color = ([0 0 0; 186 65 77; 231 208 141; 255 255 255]) ./ 255;
        queryPoints = linspace(min(intensity), max(intensity), 256);
        alphamap = interp1(intensity, alpha, queryPoints)';
        colormap2 = interp1(intensity, color, queryPoints);

        opengl hardware;
        if idcubeml3D.volume_render.Value == 2
            val = get(idcubeml3D.iso_slider1, 'Value');

%             V = volshow(Image, 'Parent', idcubeml3D.imageDisplayPanel, 'Colormap', colormap2, 'Alphamap', alphamap, 'Isovalue', val, 'Renderer', 'Isosurface', 'ScaleFactors', [(0.1 * resolution) (0.1 * resolution)]);
            V= volshow(Image,'Parent',idcubeml3D.imageDisplayPanel,'Isovalue',val,'renderer', 'Isosurface','ScaleFactors',[x y z],'IsosurfaceColor',color,'CameraUpVector',[x2(1,1) x2(1,2) x2(1,3)],'CameraPosition',[x1(1,1) x1(1,2) x1(1,3)]);
% Update the label with the current value of val
    labelStr = sprintf('Iso Value: %.3f', val);  % Format the label string
    set(idcubeml3D.iso_label_slider, 'String', labelStr, 'Visible', 'on');
        else
            V = volshow(Image, 'Parent', idcubeml3D.imageDisplayPanel, 'Colormap', colormap2, 'Alphamap', alphamap);
        end

        VAxis = [0.2, 1.5];
        setappdata(0, 'V', V);
        camtarget;
        newscale = linspace(min(Image(:)) - min(VAxis(:)), ...
            max(Image(:)) - min(VAxis(:)), size(colormap2, 1)) / diff(VAxis);
        newscale(newscale < 0) = 0;
        newscale(newscale > 1) = 1;
        V.Colormap = interp1(linspace(0, 1, size(colormap2, 1)), colormap2, newscale);
        setappdata(0, 'handle', idcubeml3D);
        setappdata(0, 'sliderFlag', 1);
        set(idcubeml3D.scaleX, 'String', '1');
        set(idcubeml3D.scaleY, 'String', '1');
        set(idcubeml3D.scaleZ, 'String', '1');
        setappdata(0,'slice',0)
    end
end



%% Orthogonal slice callback
% Define the orthogonal_slice_callback function
function orthogonal_slice_callback(hObject, eventdata, idcubeml3D)

    
    % Continue with the existing functionality
    idcubeml3D = getappdata(0, 'handle');

       % Disable the 'K-Means 3D' button
    set(idcubeml3D.new_btn, 'Enable', 'off');
    main_bgc = getappdata(0, 'main_bgc');
    dis = getappdata(0, 'Display_axes');
    new = getappdata(0, 'color_back');
    if new ~= 0
        bgc = getappdata(0, 'color_back');
    else
        bgc = getappdata(0, 'bgc');
    end
    set(findall(idcubeml3D.colormap, '-property', 'enable'), 'enable', 'off')
    set(findall(idcubeml3D.interactive_panel, '-property', 'enable'), 'enable', 'off')
    set(findall(idcubeml3D.color_channel, '-property', 'enable'), 'enable', 'off')
    set(findall(idcubeml3D.ortho_panel, '-property', 'enable'), 'enable', 'on')
    set(idcubeml3D.slice_x, 'Enable', 'off')
    set(idcubeml3D.slice_y, 'Enable', 'off')
    set(idcubeml3D.slice_z, 'Enable', 'off')
    set(idcubeml3D.figure, 'WindowButtonDownFcn', '', ...
        'WindowButtonMotionFcn', '', ...
        'WindowScrollWheelFcn', '', ...
        'KeyPressFcn', '', ...
        'WindowButtonUpFcn', '')
    if dis == 0
        matrices = getappdata(0, 'myData');
        D = matrices.Images;
        % D = getappdata(0, 'Image');
    else
        D = getappdata(0, 'myData2');
        D = D.Images;
    end
 delete(idcubeml3D.imageDisplayPanel)
%  delete(gca)
%  reset(idcubeml3D.axes_input)
 % idcubeml3D.imageDisplayPanel = uipanel('parent',idcubeml3D.figure,'position',[0.04 0.05 0.6 0.8],...
 %     'FontUnits','Normalized','bordertype','none','title','',...
 %     'backgroundcolor',bgc,'Visible','On');
 % 
 % idcubeml3D.axes_input = axes('parent',idcubeml3D.imageDisplayPanel ,'units','Normalized',...
 %     'Position', [1 1 480 400],'DataAspectRatioMode','auto',...
 %     'XTick',[], 'YTick',[]);
      idcubeml3D.imageDisplayPanel = uipanel('parent', idcubeml3D.figure, 'position', [20, 20, 400, 400], ...
            'FontUnits', 'Normalized', 'bordertype', 'none', 'title', '', ...
            'backgroundcolor', bgc, 'Visible', 'On');

        idcubeml3D.axes_input = axes('parent', idcubeml3D.imageDisplayPanel, 'units', 'Normalized', ...
            'Position', [0.01 0.01 0.98 0.98], 'FontUnits', 'Normalized', 'DataAspectRatioMode', 'auto', ...
            'XTick', [], 'YTick', []);
 set(gca,'color',main_bgc)
 set(gca,'XColor','none','YColor','none','ZColor','none')
 %setappdata(0,'X_ort',X)
 x=getappdata(0,'X_ort');
 y=getappdata(0,'Y_ort');
 z=getappdata(0,'Z_ort');

 
 
orthosliceViewer(D,'Colormap',colormap(getappdata(0,'color')),'Parent',idcubeml3D.imageDisplayPanel) 
pause(1)
           
tool=findall(idcubeml3D.figure,'tag','lb');
set(tool,'Visible','Off')
set(tool,'Visible','Off')
colormap(getappdata(0,'color'))
setappdata(0,'handle',idcubeml3D)
setappdata(0,'slice2',0)
lutbar;
end
%%New file callbcak
function new_callback(hObject, eventdata,idcubemlH)
idcubemlH = getappdata(0,'handle');
%cla(idcubemlH.imageDisplayPanel2)
original_3d_callback(hObject, eventdata,idcubemlH,1)

end
%3-D image callback
function display_image_3D(varargin)

main_bgc=getappdata(0,'main_bgc');
layer1_bgc=getappdata(0,'layer1_bgc');
layer2_bgc=getappdata(0,'layer2_bgc');
layer3_bgc=getappdata(0,'layer3_bgc');
btn_color=getappdata(0,'btn_color');
fgc=getappdata(0,'fgc');
bgc = getappdata(0,'bgc');

new=getappdata(0,'color_back');
if new~=0
    bgc=getappdata(0,'color_back');
else
    bgc = getappdata(0,'bgc');
end
        %displayAxes = varargin{4};
idcubeml3D = getappdata(0,'handle');
displayAxes=getappdata(0,'Display_axes');
map2= getappdata(0,'map2');
set(idcubeml3D.figure , 'WindowButtonDownFcn', '', ...
  'WindowButtonMotionFcn',  '', ...
  'WindowScrollWheelFcn',   '', ...
  'KeyPressFcn',            '', ...
  'WindowButtonUpFcn',      '')
color_b=getappdata(0,'color_b');
set(idcubeml3D.slice_x ,'Enable','off')
set(idcubeml3D.slice_y ,'Enable','off')
set(idcubeml3D.slice_z ,'Enable','off')
if displayAxes==0

        matrices=getappdata(0,'myData');
        Images= matrices.Images;
        %%
        
        %%
        %matrices=getappdata(0,'Image')
        %im=uint8(matrices)
        setappdata(0,'slice',Images)
        idcubeml3D = varargin{3};
        idcubeml3D.figure;
        %% get the camera
        %camtarget
        V=getappdata(0,'V');
        x1=V.Parent.CameraPosition;
        %x1=camtarget ;
       
        % angle=camva;
        x2 =V.Parent.CameraUpVector;
        %%
        % delete(idcubeml3D.imageDisplayPanel)
        idcubeml3D.imageDisplayPanel = uipanel('parent',idcubeml3D.figure,'position',[20, 20, 400, 400],...
            'bordertype','none','title','',...
            'backgroundcolor',bgc,'Visible','On');

        idcubeml3D.axes_input = axes('parent',idcubeml3D.imageDisplayPanel ,'units','Normalized',...
            'Position', [0.01 0.01 0.98 0.98],'DataAspectRatioMode','auto',...
            'XTick',[], 'YTick',[],'ZTick',[],'color',bgc);
         
        set(gca,'color',bgc)
        set(gca,'XColor','none','YColor','none','ZColor','none')
        s_max_in2=getappdata(0,'upper_2');
        avg=getappdata(0,'avg');
        % intensity = [-3024,map2.x1,s_max_in2,map2.x2];
        %alpha = [0,map2.y1, 0.05, map2.y1];
       color = ([0 0 1; 0 1 0; 1 0 0; 1 1 0]);  % Blue, Green, Red, Yellow
        %color=[color_b.x1 color_b.y1 color_b.z1;color_b.x2 color_b.y2 color_b.z2;color_b.x3 color_b.y3 color_b.z3;color_b.x4 color_b.y4 color_b.z4]
        % queryPoints = linspace(min(intensity),max(intensity),256);

       
    
    % Find the index of the selected value
        selectedIndex = find(strcmp(idcubeml3D.alpha_built.Items, idcubeml3D.alpha_built.Value));
        switch selectedIndex
            
             case 1
                 delete(idcubeml3D.axes_inten )
                 h = load('liniear.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};
                 

                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 2
                 delete(idcubeml3D.axes_inten )
                 h = load('mri.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};

                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 3
                 delete(idcubeml3D.axes_inten )
                 h = load('ct-bone.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};

                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 4
                 delete(idcubeml3D.axes_inten )
                 h = load('ct-lung.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};

                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 5
                 delete(idcubeml3D.axes_inten )
                 h = load('mri-mrp.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};

                  idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 6
                 delete(idcubeml3D.axes_inten )
                 h = load('ct-mip.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};	

                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 7
                 delete(idcubeml3D.axes_inten )
                 h = load('ct-softtissue.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};
                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
           case 8
                 delete(idcubeml3D.axes_inten )
                 h = load('ct-coronary.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};
  
                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 9 
                 set(idcubeml3D.alpha_built,'position',[0.065806642905918,0.277456647398845,0.896139323066797,0.700181985457207],'backgroundcolor','white');
                  y= getappdata(0,'custom_alpha');
                 alphamap=y;
                 
                delete(idcubeml3D.axes_inten )

                idcubeml3D.axes_inten = axes('parent',idcubeml3D.colormap,'units','Normalized',...
                    'position',[0.066,0.14,0.91,0.84],'DataAspectRatioMode','auto','Visible','On',...
                    'XTick',[], 'YTick',[]);
                point = 1:256; 
                alphamap2=alphamap';% Here the point that will have the reference lines
                axLims = 1:256;  %[x-min, x-max, y-min, y-max] axis limits
          
                xlim([1 256]);
                ylim([0 1]);
                axis([1 256 0 1])   
                 
                plot(idcubeml3D.axes_inten,point,alphamap2, '-o','MarkerSize',0.5,'LineWidth',0.5,'color', 'b');
                ax=gca;
                ax.Color = layer2_bgc;
                ax.FontSize = 7;
                xlim([1 256]);
                ylim([0 1]);
                axis([1 256 0 1])
                
                %plt = getappdata(idcubeoneHandle.axes_inten, namefield);
                %plot(-1, 1, '-o','MarkerSize','LineWidth',1.5,'color', 'b');
                xlabel('Intensity','FontSize',7, 'Color', fgc);
                ylabel('Opacity', 'FontSize',7, 'Color', fgc);
                     
                 % ax.Color = layer1_bgc; 
            ax.XColor = fgc;
            ax.YColor = fgc;
                
                
                hold off;
                
                
        end 
%         axes(idcubeml3D.axes_inten)
        delete(idcubeml3D.axes_inten )
        idcubeml3D.axes_inten = axes('parent',idcubeml3D.colormap,'units','Normalized',...
                    'position',[0.16,0.21,0.78,0.57],'DataAspectRatioMode','auto','Visible','On',...
                    'XTick',[], 'YTick',[]);
        point = 1:256;
        alphamap2=alphamap.';
       plot(idcubeml3D.axes_inten, point, alphamap2, '-o', 'MarkerSize', 0.5, 'LineWidth', 0.5, 'Color', 'blue');
ax = gca;
ax.FontSize = 7;
ax.Color = layer2_bgc;

% Strictly limit the x-axis dimension from 1 to 256
xlim([1 256]);
ylim([0 1]);

% Set axis limits to ensure they are strictly adhered to
axis([1 256 0 1]);

xlabel('Intensity', 'FontSize', 7, 'Color', fgc);
ylabel('Opacity', 'FontSize', 7, 'Color', fgc);
ax.XColor = fgc;
ax.YColor = fgc;
        hold off;
        %colormap2 = interp1(intensity,color,queryPoints);

                    % Define  custom lighter gray colormap
grayColormap = gray(256);
lightGray = (grayColormap + 1) / 2;  % Mix 50% gray and 50% white

boneColormap = bone(256);
lightBone = (boneColormap + 1) / 2;  % Mix 50% bone and 50% white

hotColormap = hot(256);
lightHot = (hotColormap + 1) / 2;  % Mix 50% bone and 50% white
        
value= getappdata(0, 'val');
        
        switch value
            

% Switch case for colormap selection
            case 1
       %                  colormap2 = interp1(intensity,color,queryPoints);
                  colormap2 = lightGray;
                   set(idcubeml3D.iso_label_slider, 'Visible', 'off');

            case 2
                  colormap2=autumn;
                   set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 3
                colormap2=lightBone	;
                 set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 4
                 colormap2=cool;
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 5
                 colormap2=copper	;
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 6
                 colormap2=gray;	
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 7
                 colormap2=lightHot;	
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 8
                 colormap2=pink;
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 9
                 colormap2=spring;	
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 10
                 colormap2=summer;	
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 11
                 colormap2=winter;
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 12
              
                h = load('jet_color3.mat');
                y = struct2cell(h);
                
                hsidata = y{1};
                y = struct2cell(hsidata);
                colormap2=y{7};
                   set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 13
               
                h = load('hsv_color.mat');
                y = struct2cell(h);
                
                
                hsidata = y{1};
                y = struct2cell(hsidata);
                colormap2=y{7};
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
   
            case 14
                
                 colormap2=colorcube;
                 set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 15
                 set(idcubeml3D.iso_label_slider, 'Visible', 'off');
                 colormap2=flag	;
            case 16
           
                 colormap2=lines;
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 17
                 
                 colormap2=prism;
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 18
                 h = load('ct-bone_color.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 colormap2=y{7};
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 19
                 colormap2=white;
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
            case 20
                
                 h = load('ct-soft_color.mat');
                 y = struct2cell(h);
                  set(idcubeml3D.iso_label_slider, 'Visible', 'off');
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 colormap2=y{7};               
             

        end
        VAxis = [0.2, 1.5];
        low  = getappdata(0,'low_con');
        high = getappdata(0,'high_con');
        x = getappdata(0,'X');
        y = getappdata(0,'Y');
        z = getappdata(0,'Z');
        
            newscale = linspace(min(Images(:)) - min(VAxis(:)),...
            max(Images(:)) - min(VAxis(:)), size(colormap2, 1))/diff(VAxis);
        newscale(newscale < 0) = 0;
        newscale(newscale > 1) = 1;
      
        % Update colormap in volshow
         if strcmp(idcubeml3D.volume_render.Value,'Volume render')==1
             val = get(idcubeml3D.iso_slider1,'Value');
% Update the label with the current value of val
            %   labelStr = sprintf('Iso Value: %.3f', val);  % Format the label string
            % set(idcubeml3D.iso_label_slider, 'String', labelStr, 'Visible', 'on');

             if idcubeml3D.alpha_built.Value==9
                  V= volshow(Images,'Colormap',colormap2,'Alphamap',alphamap','Parent',idcubeml3D.imageDisplayPanel);
             
                  
             else
               % color=getappdata(0,'iso_color');
%              V= volshow(Images,'Parent',idcubeml3D.imageDisplayPanel,'Colormap',colormap2,'Alphamap',alphamap,'Isovalue',val,'renderer', 'maximumintensityprojection','ScaleFactors',[x y z],'IsosurfaceColor',color,'CameraUpVector',[x2(1,1) x2(1,2) x2(1,3)],'CameraPosition',[x1(1,1) x1(1,2) x1(1,3)]);
               V= volshow(Images,'Parent',idcubeml3D.imageDisplayPanel,'Colormap',colormap2,'Alphamap',alphamap');  %% In volume render no isosurface value
               
               camlight;
               lighting gouraud;
             end
         else
             val = get(idcubeml3D.iso_slider1,'Value');
             color=getappdata(0,'iso_color');
             if idcubeml3D.alpha_built.Value==9
                  V= volshow(Images,'Colormap',colormap2,'Alphamap',alphamap','Transformation',[x y z],'CameraUpVector',[x2(1,1) x2(1,2) x2(1,3)],'CameraPosition',[x1(1,1) x1(1,2) x1(1,3)],'Parent',idcubeml3D.imageDisplayPanel);

             else
              V= volshow(Images,'Colormap',colormap2,'Renderingstyle','Isosurface','IsoSurfacevalue', val,'Colormap',color,'Parent',idcubeml3D.imageDisplayPanel);
             end
             
         end
        V.Parent.CameraPosition=x1;
        V.Parent.CameraUpVector=x2;
        setappdata(0,'V',V)
        setappdata(0,'current_img',Images)
        setappdata(0,'sliderFlag',1)
      
        setappdata(0,'handle',idcubeml3D)
        setappdata(0,'slice2',0)

elseif displayAxes==1

        D =getappdata(0,'myData2');
        D=D.Images;

        s_max_in2=getappdata(0,'upper_2');
        avg=getappdata(0,'avg');
        intensity = [-3024,map2.x1,s_max_in2,map2.x2];
         %% get the camera
        %camtarget
        V=getappdata(0,'V');
        x1=V.CameraPosition;
        %x1=camtarget ;
       
        angle=camva;
        x2 =V.CameraUpVector;
      
        alpha = [0,map2.y1, 0.05, map2.y1];
        color = ([0 0 0; 186 65 77; 231 208 141; 255 255 255]) ./ 255;
        queryPoints = linspace(min(intensity),max(intensity),256);
       switch idcubeml3D.alpha_built.Value
             case 1
                 h = load('liniear.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};
  
                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 2
                 h = load('mri.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};

                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 3
                 h = load('ct-bone.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};
 
                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 4
                 h = load('ct-lung.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};

                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 5
                 h = load('mri-mrp.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};

                  idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 6
                 h = load('ct-mip.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};	

                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 7
                 h = load('ct-softtissue.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};
  
                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
           case 8
                 h = load('ct-coronary.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 alphamap=y{8};

                 idcubeml3D.label2.Visible='Off';
                 idcubeml3D.label1.Visible='Off';
            case 9 
                 set(idcubeml3D.alpha_built,'position',[0.488663785763061,0.676329368421543,0.449999999999998,0.343733506858752],'backgroundcolor','white');
                 y= getappdata(0,'custom_alpha');
                 alphamap=y;
                 
        end  
     
%                  colormap2 = interp1(intensity,color,queryPoints);
                  colormap2 = gray;
    
       
        delete(idcubeml3D.imageDisplayPanel)
        idcubeml3D.imageDisplayPanel = uipanel('parent',idcubeml3D.figure,'position',[0.04 0.05 0.6 0.8],...
            'bordertype','none','title','',...
            'backgroundcolor',bgc,'Visible','On');
        
        idcubeml3D.axes_input = axes('parent',idcubeml3D.imageDisplayPanel ,'units','Normalized',...
            'Position', [0.01 0.01 0.98 0.98],'DataAspectRatioMode','auto',...
            'XTick',[], 'YTick',[],'ZTick',[],'color',bgc);
        set(gca,'color',bgc)
        set(gca,'XColor','none','YColor','none','ZColor','none')
        delete(idcubeml3D.axes_inten )
        idcubeml3D.axes_inten = axes('parent',idcubeml3D.colormap,'units','Normalized',...
                    'position',[0.16,0.21,0.78,0.57],'DataAspectRatioMode','auto','Visible','On',...
                    'XTick',[], 'YTick',[]);
        point = 1:256;
        alphamap2=alphamap.';
       plot(idcubeml3D.axes_inten, point, alphamap2, '-o', 'MarkerSize', 0.5, 'LineWidth', 0.5, 'Color', 'blue');
ax = gca;
ax.FontSize = 7;
ax.Color = layer2_bgc;

% Strictly limit the x-axis dimension from 1 to 256
xlim([1 256]);
ylim([0 1]);

% Set axis limits to ensure they are strictly adhered to
axis([1 256 0 1]);

xlabel('Intensity', 'FontSize', 7, 'Color', fgc);
ylabel('Opacity', 'FontSize', 7, 'Color', fgc);
ax.XColor = fgc;
ax.YColor = fgc;
        hold off;
        switch idcubeml3D.color2.Value
            case 1
%                  colormap2 = interp1(intensity,color,queryPoints);
                  colormap2 = gray;
            case 2
                  colormap2=autumn;
            case 3
                colormap2=bone	;
            case 4
                 colormap2=cool;
            case 5
                 colormap2=copper	;
            case 6
                 colormap2=gray;	
            case 7
                 colormap2=hot;	
            case 8
                 colormap2=pink;
            case 9
                 colormap2=spring;	
            case 10
                 colormap2=summer;	
            case 11
                 colormap2=winter;
            case 12
                h = load('jet_color.mat');
                y = struct2cell(h);
                
                hsidata = y{1};
                y = struct2cell(hsidata);
                colormap2=y{7};
            case 13
                h = load('hsv_color.mat');
                y = struct2cell(h);
                
                hsidata = y{1};
                y = struct2cell(hsidata);
                colormap2=y{7};
                 %idcubeml3D.alpha_slider1.Visible='Off'
                 %colormap2=hsv;
            case 14
               
                 colormap2=colorcube;
            case 15
                 colormap2=flag	;
            case 16
                 colormap2=lines;
            case 17
                 colormap2=prism;
            case 18
                 h = load('ct-bone_color.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 colormap2=y{7};
            case 19
                 colormap2=white;
            case 20
                 h = load('ct-soft_color.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 colormap2=y{7};
                             
          
       end

        x = getappdata(0,'X');
        y = getappdata(0,'Y');
        z = getappdata(0,'Z');
        
         if idcubeml3D.volume_render.Value==2
             val = get(idcubeml3D.iso_slider1,'Value');
             color=getappdata(0,'iso_color');
             V= volshow(D,'Parent',idcubeml3D.imageDisplayPanel,'Colormap',colormap2,'Alphamap',alphamap,'Isovalue',val,'Renderer','Isosurface','ScaleFactors',[x y z],'IsosurfaceColor',color,'CameraUpVector',[x2(1,1) x2(1,2) x2(1,3)],'CameraPosition',[x1(1,1) x1(1,2) x1(1,3)]);
         % Update the label with the current value of val
    labelStr = sprintf('Iso Value: %.3f', val);  % Format the label string
    set(idcubeml3D.iso_label_slider, 'String', labelStr, 'Visible', 'on');
         
         else
             V= volshow(D,'Colormap',colormap2,'Alphamap',alphamap,'ScaleFactors',[x y z],'CameraUpVector',[x2(1,1) x2(1,2) x2(1,3)],'CameraPosition',[x1(1,1) x1(1,2) x1(1,3)],'Parent',idcubeml3D.imageDisplayPanel);
         end
     

        setappdata(0,'V',V)
        setappdata(0,'current_img',D)
        setappdata(0,'sliderFlag',1)
         setappdata(0,'slice2',0)
     
end      
        
        
end

% 
function display_image_3D_custom(varargin) 

main_bgc=getappdata(0,'main_bgc');
layer1_bgc=getappdata(0,'layer1_bgc');
layer2_bgc=getappdata(0,'layer2_bgc');
fgc=getappdata(0,'fgc');

new=getappdata(0,'color_back');
if new~=0
    bgc=getappdata(0,'color_back');
else
    bgc = getappdata(0,'bgc');
end
        %displayAxes = varargin{4};
idcubeml3D = getappdata(0,'handle');

map2= getappdata(0,'map2');

color_b=getappdata(0,'color_b');
set(idcubeml3D.slice_x ,'Enable','off')
set(idcubeml3D.slice_y ,'Enable','off')
set(idcubeml3D.slice_z ,'Enable','off')


        matrices=getappdata(0,'myData');
        Images= matrices.Images;
        %%
        

        setappdata(0,'slice',Images)
        idcubeml3D = varargin{3};
        idcubeml3D.figure;
        %% get the camera
        %camtarget
        V=getappdata(0,'V');
        x1=V.Parent.CameraPosition;
        %x1=camtarget ;
       
        angle=camva;
        x2 =V.Parent.CameraUpVector;
        %%
        delete(idcubeml3D.imageDisplayPanel)
        idcubeml3D.imageDisplayPanel = uipanel('parent',idcubeml3D.figure,'position',[20, 20, 400, 400],...
            'bordertype','none','title','',...
            'backgroundcolor',bgc,'Visible','On');

        idcubeml3D.axes_input = axes('parent',idcubeml3D.imageDisplayPanel ,'units','Normalized',...
            'Position', [0.01 0.01 0.98 0.98],'DataAspectRatioMode','auto',...
            'XTick',[], 'YTick',[],'ZTick',[],'color',bgc);
         
        set(gca,'color',bgc)
        set(gca,'XColor','none','YColor','none','ZColor','none')
        s_max_in2=getappdata(0,'upper_2');
        avg=getappdata(0,'avg');
        % intensity = [-3024,map2.x1,s_max_in2,map2.x2];
        %alpha = [0,map2.y1, 0.05, map2.y1];
        color = ([0 0 1; 0 1 0; 1 0 0; 1 1 0]);  % Blue, Green, Red, Yellow
        %color=[color_b.x1 color_b.y1 color_b.z1;color_b.x2 color_b.y2 color_b.z2;color_b.x3 color_b.y3 color_b.z3;color_b.x4 color_b.y4 color_b.z4]
        % queryPoints = linspace(min(intensity),max(intensity),256);

                 y= getappdata(0,'custom_alpha');
                 alphamap=y;

        delete(idcubeml3D.axes_inten )
        idcubeml3D.axes_inten = axes('parent',idcubeml3D.colormap,'units','Normalized',...
                    'position',[0.16,0.21,0.78,0.57],'DataAspectRatioMode','auto','Visible','On',...
                    'XTick',[], 'YTick',[]);
        point = 1:256;
        alphamap2=alphamap;
       plot(idcubeml3D.axes_inten, point, alphamap2, '-o', 'MarkerSize', 0.5, 'LineWidth', 0.5, 'Color', 'blue');
ax = gca;
ax.FontSize = 7;
ax.Color = layer2_bgc;

% Strictly limit the x-axis dimension from 1 to 256
xlim([1 256]);
ylim([0 1]);

% Set axis limits to ensure they are strictly adhered to
axis([1 256 0 1]);

xlabel('Intensity', 'FontSize', 7, 'Color', fgc);
ylabel('Opacity', 'FontSize', 7, 'Color', fgc);
ax.XColor = fgc;
ax.YColor = fgc;
        hold off;
        %colormap2 = interp1(intensity,color,queryPoints);
     value= getappdata(0, 'val');   
        switch value
            case 1
%                  colormap2 = interp1(intensity,color,queryPoints);
                  colormap2 = gray;
            case 2
                  colormap2=autumn;
            case 3
                colormap2=bone	;
            case 4
                 colormap2=cool;
            case 5
                 colormap2=copper	;
            case 6
                 colormap2=gray;	
            case 7
                 colormap2=hot;	
            case 8
                 colormap2=pink;
            case 9
                 colormap2=spring;	
            case 10
                 colormap2=summer;	
            case 11
                 colormap2=winter;
            case 12
                h = load('jet_color3.mat');
                y = struct2cell(h);
                
                hsidata = y{1};
                y = struct2cell(hsidata);
                colormap2=y{7};
            case 13
                h = load('hsv_color.mat');
                y = struct2cell(h);
                
                hsidata = y{1};
                y = struct2cell(hsidata);
                colormap2=y{7};
      
            case 14
               
                 colormap2=colorcube;
            case 15
                 colormap2=flag	;
            case 16
                 colormap2=lines;
            case 17
                 colormap2=prism;
            case 18
                 h = load('ct-bone_color.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 colormap2=y{7};
            case 19
                 colormap2=white;
            case 20
                 h = load('ct-soft_color.mat');
                 y = struct2cell(h);
                 
                 hsidata = y{1};
                 y = struct2cell(hsidata);
                 colormap2=y{7};               
             

        end
        VAxis = [0.2, 1.5];
        low  = getappdata(0,'low_con');
        high = getappdata(0,'high_con');
        x = getappdata(0,'X');
        y = getappdata(0,'Y');
        z = getappdata(0,'Z');   
           val = get(idcubeml3D.iso_slider1,'Value');
         V= volshow(Images,'Colormap',colormap2,'Alphamap',alphamap','Parent',idcubeml3D.imageDisplayPanel);
         %'ScaleFactors',[x y z],'CameraUpVector',[x2(1,1) x2(1,2) x2(1,3)],'CameraPosition',[x1(1,1) x1(1,2) x1(1,3)]
                
        V.Parent.CameraPosition=x1;
        V.Parent.CameraUpVector=x2;     
        setappdata(0,'V',V)
        %setappdata(0,'vol',vol)
        setappdata(0,'current_img',Images)
        setappdata(0,'sliderFlag',1)
        %setappdata(0,'map2',map2)
        setappdata(0,'handle',idcubeml3D)
        setappdata(0,'slice2',0)
        end
        
function slice_callback(~, ~)
idcubeml3D = getappdata(0,'handle');
    % Disable the 'K-Means 3D' button
    set(idcubeml3D.new_btn, 'Enable', 'off');
tmp = get(0,'screensize');
set(findall(idcubeml3D.colormap, '-property', 'enable'), 'enable', 'off')
set(findall(idcubeml3D.interactive_panel , '-property', 'enable'), 'enable', 'off')
set(findall(idcubeml3D.color_channel, '-property', 'enable'), 'enable', 'off')
set(findall(idcubeml3D.ortho_panel, '-property', 'enable'), 'enable', 'off')
set(findall(idcubeml3D.slice_panel, '-property', 'enable'), 'enable', 'on')
slice=getappdata(0,'slice2');
%% get the camerapostion
if  slice==1
 x1= idcubeml3D.axes_input.CameraPosition;
 x2=idcubeml3D.axes_input.CameraUpVector;
end
if tmp(4) >= 1080
    xpos = 550;
    ypos = 250;
    dimX = 1080;
    dimY = 750;
elseif tmp(4) >=720 && tmp(4)<1080
    xpos = 200;
    ypos = 100;
    dimY = 700;
    dimX = 1280;
elseif tmp(4)<720
    xpos = 100;
    ypos = 50;
    dimY = 550;
    dimX = 700;
%     defaultFontsize = 6.5;
end

main_bgc=getappdata(0,'main_bgc');
dis = getappdata(0,'Display_axes');
new=getappdata(0,'color_back');
if new~=0
    bgc=getappdata(0,'color_back');
else
    bgc = getappdata(0,'bgc');
end
fgc=getappdata(0,'fgc');
layer1_bgc=getappdata(0,'layer1_bgc');
 % if dis==0
 %     matrices=getappdata(0,'myData3');
 %     D= matrices.Images;
 %     %D=getappdata(0,'Image');
 % else
     matrices=getappdata(0,'myData3');
     D= matrices.Images;
     
 % end

%D=getappdata(0,'slice')
DIM = size(D);
[r,c,z]=size(D);
[X,Y,Z]=meshgrid(1:DIM(2),1:DIM(1),1:DIM(3));
step_min=8.333333e-4; step_max=step_min*10;
% setappdata(0,'upper_2','3071');
% s_min_in1=str2double(getappdata(0,'lower_1'));
min=0;
%bar3(Z,0.5)
max_x=X(1);
max_y=X(2);
max_z=X(3);
%%Silce Callback
[x,y,z]=size(D);

value.x=x/2;
value.y=y/2;
value.z=z/2;
setappdata(0,'value2',value)

max_x1=r;
max_y1=c;
max_z=z;
sliderflag2 = getappdata(0,'sliderFlag2');
value=getappdata(0,'value2');

    
delete(idcubeml3D.imageDisplayPanel)
idcubeml3D.imageDisplayPanel = uipanel('parent',idcubeml3D.figure,'position',[20, 20, 400, 400],...
            'bordertype','none','title','',...
            'backgroundcolor',bgc,'Visible','On');

idcubeml3D.axes_input = axes('parent',idcubeml3D.imageDisplayPanel ,'units','Normalized',...
'Position', [0.01 0.01 0.98 0.98],'DataAspectRatioMode','auto',...
'XTick',[], 'YTick',[]);
%%
set(gca,'color',bgc)
set(gca,'XColor','none','YColor','none','ZColor','none')
idcubeml3D.reset= uicontrol('parent',idcubeml3D.slice_panel,'style','pushbutton','string','Reset',...
    'position',[0.6 0.01 0.35 0.13],'FontUnits','Normalized','backgroundcolor',[173/255 103/255 111/255],'foreground',fgc,...
    'tooltipstring',sprintf('Click to load the original image'),...
    'callback',{@reset_callback});

setappdata(0,'slice',1)
%%
if max_x1>max_y1
    max_x=max_y1;
    max_y=max_x1;
else
    max_y=max_x1;
    max_x=max_y1;
end
% idcubeml3D.slice_x = uislider('Parent', idcubeml3D.slice_panel, ...
%     'Position', [100 50 100 3], 'Limits', [0 100], 'Value', 50, 'Enable', 'on', ...
%     'Tooltip', 'Select the isovalue (range 0 to 1)', 'ValueChangedFcn', @(src, event) slice_x_CallBack(src));
% 
% idcubeml3D.slice_y = uislider('Parent', idcubeml3D.slice_panel, ...
%     'Position', [220 50 100 3], 'Limits', [0 100], 'Value', 50, 'Enable', 'on', ...
%     'Tooltip', 'Select the isovalue (range 0 to 1)', 'ValueChangedFcn', @(src, event) slice_y_CallBack(src));
% % addlistener( idcubeml3D.slice_y, 'Value', 'PostSet',@slice_y_CallBack);
% idcubeml3D.slice_z = uislider('Parent', idcubeml3D.slice_panel, ...
%     'Position', [340 50 100 3], 'Limits', [0 100], 'Value', 50, 'Enable', 'on', ...
%     'Tooltip', 'Select the isovalue (range 0 to 1)', 'ValueChangedFcn', @(src, event) slice_z_CallBack(src));
% idcubeml3D.slice_x = uicontrol('parent',idcubeml3D.slicer,'style','slider','min',1,'max',max_x,...
% 'value',value.x,'sliderstep',[step_min step_max],'position',[0.113829787234043,0.652534562211981,0.8,0.15],'Enable','On',...
%  'tooltipstring',sprintf(num2str(value.x)),'fontsize', 9, 'BackgroundColor',layer1_bgc);
% addlistener( idcubeml3D.slice_x, 'Value', 'PostSet',@slice_x_CallBack);
% idcubeml3D.slice_y = uicontrol('parent',idcubeml3D.slicer,'style','slider','min',1,'max',max_y,...
% 'value',value.y,'sliderstep',[step_min step_max],'position',[0.113829787234043,0.380019749835418,0.8,0.15],'Enable','On',...
%  'tooltipstring',sprintf(num2str(value.y)),'fontsize',9, 'BackgroundColor',layer1_bgc);
% addlistener( idcubeml3D.slice_y, 'Value', 'PostSet',@slice_y_CallBack);
% idcubeml3D.slice_z = uicontrol('parent',idcubeml3D.slicer,'style','slider','min',1,'max',max_z,...
% 'value',value.z,'sliderstep',[step_min step_max],'position',[0.111895551257253,0.1,0.8,0.15],'Enable','On',...
%  'tooltipstring',sprintf(num2str(value.z)),'fontsize',9, 'BackgroundColor',layer1_bgc);
% addlistener( idcubeml3D.slice_z, 'Value', 'PostSet',@slice_z_CallBack);

tool=findall(idcubeml3D.figure,'tag','lb');
set(tool,'Visible','Off')
set(tool,'Visible','Off')
set(idcubeml3D.slice_x,'Visible','On')
set(idcubeml3D.slice_y,'Visible','On')
set(idcubeml3D.slice_z,'Visible','On')
colormap(getappdata(0,'color'))


set(idcubeml3D.axes_input, 'XTick',[], 'YTick',[])

slice2(X,Y,Z,D,round(value.x),round(value.y),round(value.z),'Parent',idcubeml3D.axes_input );
if slice==1
idcubeml3D.axes_input.CameraPosition=x1;
idcubeml3D.axes_input.CameraUpVector=x2;
end
set(idcubeml3D.axes_input, 'XTick',[], 'YTick',[],'ZTick',[],'color',bgc)
% set(idcubeml3D.axes_input("Color","none"))
shading flat;
title('3D Slices', 'Color', fgc, 'fontweight', 'normal');
%xlabel('x');ylabel('y');zlabel('z');
three_d_interection(gcf)

sliderFlag = 1;
setappdata(0,'sliderFlag2',sliderFlag);

sliderflag2=1;
setappdata(0,'sliderFlag2',sliderflag2)
setappdata(0,'handle',idcubeml3D)
setappdata(0,'slice2',1);

% defaultplotedittoolbar;

lutbar;

end

%% Volume rendering panel
function volume_ren(src, event)
    idcubeml3D = getappdata(0, 'handle');
    vol = get(idcubeml3D.volume_render, 'Value');
    if isequal(vol,'Isosurface')
        vol=2;
    end
    setappdata(0, 'vol', vol);
    sliderFlag = getappdata(0, 'sliderFlag');

    if vol == 2
        setappdata(0, 'iso_color', 'r');
        set(idcubeml3D.iso_slider1, 'Visible', 'on');
        set(idcubeml3D.iso_color, 'Visible', 'on');
        set(idcubeml3D.iso_label, 'Visible', 'on');
        set(idcubeml3D.iso_label_slider, 'Visible', 'on');
        set(findall(idcubeml3D.colormap, '-property', 'enable'), 'enable', 'off');
        set(findall(idcubeml3D.color_channel, '-property', 'enable'), 'enable', 'off');
        
        % set(idcubeml3D.alpha, 'Visible', 'off');
        set(idcubeml3D.color2, 'Visible', 'off');
        set(idcubeml3D.slicer,  'Visible', 'off');
        set(idcubeml3D.color_channel,  'Visible', 'off');
        set( idcubeml3D.ortho_panel,  'Visible', 'off');
      
     
    else
        set(idcubeml3D.iso_slider1, 'Visible', 'off');
        set(idcubeml3D.iso_color, 'Visible', 'off');
        set(idcubeml3D.iso_label, 'Visible', 'off');
        set(idcubeml3D.iso_label_slider, 'Visible', 'off');
        set(findall(idcubeml3D.colormap, '-property', 'enable'), 'enable', 'on');
        set(findall(idcubeml3D.color_channel, '-property', 'enable'), 'enable', 'on');
          set(idcubeml3D.color2, 'Visible', 'on');
        set(idcubeml3D.slicer,  'Visible', 'on');
        % set(idcubeml3D.alpha, 'Visible', 'on');
        set(idcubeml3D.color_channel,  'Visible', 'on');
        set( idcubeml3D.ortho_panel,  'Visible', 'on');
    end

    if sliderFlag ~= 0
        dis = getappdata(0, 'Display_axes');
        display_image_3D(1, 1, idcubeml3D, dis);
    end
end

% function iso_color(src, event)
%     idcubeml3D = getappdata(0, 'handle');
%     vol = get(idcubeml3D.iso_color, 'Value');
%     setappdata(0, 'vol', vol);
%     sliderFlag = getappdata(0, 'sliderFlag');
% 
% 
%     switch vol
%         case 1, setappdata(0, 'iso_color', 'r');
%         case 2, setappdata(0, 'iso_color', 'y');
%         case 3, setappdata(0, 'iso_color', 'm');
%         case 4, setappdata(0, 'iso_color', 'c');
%         case 5, setappdata(0, 'iso_color', 'g');
%         case 6, setappdata(0, 'iso_color', 'b');
%         case 7, setappdata(0, 'iso_color', 'w');
%         case 8, setappdata(0, 'iso_color', 'k');
%     end
% 
%     if sliderFlag ~= 0
%         dis = getappdata(0, 'Display_axes');
%         display_image_3D(1, 1, idcubeml3D, dis);
%     end
% end
function iso_color(src, event)
    idcubeml3D = getappdata(0, 'handle');
    vol = get(idcubeml3D.iso_color, 'Value');
    vol = find(strcmp(idcubeml3D.iso_color.Items, idcubeml3D.iso_color.Value));
    sliderFlag = getappdata(0, 'sliderFlag');
    
    switch vol
        case 1, color = 'r';
        case 2, color = 'y';
        case 3, color = 'm';
        case 4, color = 'c';
        case 5, color = 'g';
        case 6, color = 'b';
        case 7, color = 'w';
        case 8, color = 'k';
        case 9
            % Custom color picker
            color = uisetcolor;
            if length(color) == 3 % Ensure a color was selected
                setappdata(0, 'iso_color', color);
            else
                % Revert to a default color if no color was selected
                color = 'r';
                setappdata(0, 'iso_color', color);
            end
    end
    
    if vol ~= 9  % Set color directly for predefined options
        setappdata(0, 'iso_color', color);
    end
    
    if sliderFlag ~= 0
        dis = getappdata(0, 'Display_axes');
        display_image_3D(1, 1, idcubeml3D, dis);
    end
end


function iso_slider1(ObjH, EventData, varargin)
    idcubeml3D = getappdata(0, 'handle');
    sliderFlag = getappdata(0, 'sliderFlag');

    if sliderFlag ~= 0
        dis = getappdata(0, 'Display_axes');
        display_image_3D(1, 1, idcubeml3D, dis);
    end
end

function color2_callback(src, event)
    idcubeml3D = getappdata(0, 'handle');
    vol = getappdata(0, 'vol');
    color = get(idcubeml3D.color2, 'String');
    setappdata(0, 'color2', color);
    sliderFlag = getappdata(0, 'sliderFlag');

    if sliderFlag ~= 0
        dis = getappdata(0, 'Display_axes');
        display_image_3D(1, 1, idcubeml3D, dis);
    end
end

function pop_callback(src, event)
    idcubeml3D = getappdata(0, 'handle');
    color = get(idcubeml3D.color2, 'Value');
    setappdata(0, 'color2', color);
    % val = get(idcubeml3D.color2, 'Value');
    % str = get(idcubeml3D.color2, 'String');
    % val = str{val};
    val = find(strcmp(idcubeml3D.color2.Items, idcubeml3D.color2.Value));
    setappdata(0, 'val', val);
    sliderFlag = getappdata(0, 'sliderFlag');


    % Update the label with the current value of val
    % labelStr = sprintf('Iso Value: %.3f', val);  % Format the label string
    % set(idcubeml3D.iso_label_slider, 'String', labelStr, 'Visible', 'on');

    if sliderFlag ~= 0
        dis = getappdata(0, 'Display_axes');
        display_image_3D(1, 1, idcubeml3D, dis);
    end
end

function pop_alpha_callback(src, event)
    idcubeml3D = getappdata(0, 'handle');
    str = get(idcubeml3D.alpha_built, 'Value');
    % str = get(idcubeml3D.alpha_built, 'String');

    % Update the label with the current value of val
    % labelStr = sprintf('Iso Value: %.3f', val);  % Format the label string
    % set(idcubeml3D.iso_label_slider, 'String', labelStr, 'Visible', 'on');

    if strcmp('custom',str)==1
        interactiveLinePlot2(6); % 6 points
    else
        setappdata(0, 'val_alpha', str);
        idcubeml3D = getappdata(0, 'handle');
        matrices = getappdata(0, 'myData');
        vol = getappdata(0, 'vol');
        color = get(idcubeml3D.color2, 'Value');
        setappdata(0, 'color2', color);
        sliderFlag = getappdata(0, 'sliderFlag');

        if sliderFlag ~= 0
            dis = getappdata(0, 'Display_axes');
            display_image_3D(1, 1, idcubeml3D, dis);
        end
    end
end

% Contrast Callback
function con_callback(src, event)
    idcubeml3D = getappdata(0, 'handle');
    con1 = get(idcubeml3D.con_pop1, 'Value');
    con2 = get(idcubeml3D.con_pop2, 'Value');
    setappdata(0, 'low_con', con1 / 10);
    setappdata(0, 'high_con', con2 / 10);
    sliderFlag = getappdata(0, 'sliderFlag');

    if sliderFlag ~= 0
        dis = getappdata(0, 'Display_axes');
        display_image_3D(1, 1, idcubeml3D, dis);
    end
end

% Scale Callback
function scale(src, event)
    idcubeml3D = getappdata(0, 'handle');
    X = str2double(get(idcubeml3D.scaleX, 'String'));
    Y = str2double(get(idcubeml3D.scaleY, 'String'));
    Z = str2double(get(idcubeml3D.scaleZ, 'String'));
    setappdata(0, 'X', X);
    setappdata(0, 'Y', Y);
    setappdata(0, 'Z', Z);
    sliderFlag = getappdata(0, 'sliderFlag');

    if sliderFlag ~= 0
        dis = getappdata(0, 'Display_axes');
        display_image_3D(1, 1, idcubeml3D, dis);
    end
end

 %%Orthogonal Scale
 function scale_ortho(src,event)
 
 idcubeml3D = getappdata(0,'handle');
 X=str2double(get(idcubeml3D.scaleX_ortho,'String'));
 Y=str2double(get(idcubeml3D.scaleY_ortho,'String'));
 Z=str2double(get(idcubeml3D.scaleZ_ortho,'String'));
 setappdata(0,'X_ort',X)
 setappdata(0,'Y_ort',Y)
 setappdata(0,'Z_ort',Z)
 
 sliderFlag = getappdata(0,'sliderFlag2');
        
          if sliderFlag~=0
           
             dis=getappdata(0,'Display_axes');
             orthogonal_slice_callback();
          end
 end
 %%

function slice_x_CallBack(ObjH, EventData)

    idcubeml3D = getappdata(0,'handle');
    value=getappdata(0,'value2');
    value.x=(get(idcubeml3D.slice_x ,'value'));
         setappdata(0,'value2',value)
         sliderFlag2 = getappdata(0,'sliderFlag2');
        if sliderFlag2~=0
        
            slice_callback2()
        end
       
end
 function slice_y_CallBack(ObjH, EventData)
   idcubeml3D = getappdata(0,'handle');
    value=getappdata(0,'value2');
    value.y=(get(idcubeml3D.slice_y ,'value'));
        setappdata(0,'value2',value)
         sliderFlag2 = getappdata(0,'sliderFlag2');
        if sliderFlag2~=0
          
            slice_callback2()
        end

 end
 function slice_z_CallBack(ObjH, EventData)
   idcubeml3D = getappdata(0,'handle'); 
    value=getappdata(0,'value2');
    value.z=(get(idcubeml3D.slice_z ,'value'));
         setappdata(0,'value2',value)
        sliderFlag2 = getappdata(0,'sliderFlag2');
        if sliderFlag2~=0
        
            slice_callback2();
        end         
 end

function slice_callback2(ObjH, EventData)
idcubeml3D = getappdata(0,'handle');
dis = getappdata(0,'Display_axes');
%new=getappdata(0,'color_back')

bgc = getappdata(0,'color_back');
slice=getappdata(0,'slice2');
%% get the camerapostion
if  slice==1
 x1= idcubeml3D.axes_input.CameraPosition;
 x2=idcubeml3D.axes_input.CameraUpVector;
end
 % if dis==0
 %     matrices=getappdata(0,'myData3');
 %     D= matrices.Images;
 %     %D=getappdata(0,'Image');
 % else
      matrices=getappdata(0,'myData3');
      D= matrices.Images;
     
 % end

%D=getappdata(0,'slice')
DIM = size(D);
[x,y,z]=size(D);

[r,c,z]=size(D);
[X,Y,Z]=meshgrid(1:DIM(2),1:DIM(1),1:DIM(3));
step_min=8.333333e-4; step_max=step_min*10;

min=0;
max_x=r;
max_y=c;
max_z=z;
sliderflag2 = getappdata(0,'sliderflag2');
value=getappdata(0,'value2');
if get(idcubeml3D.reset,'value')==1
    value.x=max_x/2;
    value.y=max_y/2;
    value.z=max_z/2;
end

slice2(X,Y,Z,D,round(value.x),round(value.y),round(value.z),'Parent',idcubeml3D.axes_input );
az=getappdata(0,'az');
el= getappdata(0,'el');
 dx=getappdata(0,'dx');
 dy=getappdata(0,'dy');
% idcubeml3D.axes_input.View=[az,el];
% camorbit(gca, dx, dy)
%campan(gca, dx, dy)
% set(idcubeml3D.slice_x,'tooltipstring',sprintf(num2str(value.x)))
% set(idcubeml3D.slice_y,'tooltipstring',sprintf(num2str(value.y)))
% set(idcubeml3D.slice_z,'tooltipstring',sprintf(num2str(value.z)))
set(idcubeml3D.slice_x,'value',value.x)
set(idcubeml3D.slice_y,'value',value.y)
set(idcubeml3D.slice_z,'value',value.z)
set(idcubeml3D.axes_input, 'XTick',[], 'YTick',[],'ZTick',[],'color',bgc)
slice=getappdata(0,'slice2');
%% get the camerapostion
if  slice==1
 idcubeml3D.axes_input.CameraPosition=x1;
 idcubeml3D.axes_input.CameraUpVector=x2;
end
shading flat;
% Turn off the grid
grid off;

sliderflag2=1;
setappdata(0,'sliderflag2',sliderflag2)
setappdata(0,'value2',value)
setappdata(0,'handle',idcubeml3D)

 end
 function reset_callback(ObjH, EventData)
 
 slice_callback2()
 end
 
 %%Color Callback
  function color1_R_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.x1=(get(idcubeml3D.color1_R,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');

        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end

end

  function color1_G_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.y1=(get(idcubeml3D.color1_G,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');
        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
 end
  function color1_B_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.z1=(get(idcubeml3D.color1_B,'value'));
       setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');
        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
  end
 
   function color2_R_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.x2=(get(idcubeml3D.color2_R,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');

        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end

 end
   

 function color2_G_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.y2=(get(idcubeml3D.color2_G,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');

        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
 end
  function color2_B_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.z2=(get(idcubeml3D.color2_B,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');
        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
  end
   function color3_R_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.x3=(get(idcubeml3D.color3_R,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');
        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
 end
 function color3_G_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.y3=(get(idcubeml3D.color3_G,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');
        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
 end
  function color3_B_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.z3=(get(idcubeml3D.color3_B,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');
        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
  end
   function color4_R_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.x4=(get(idcubeml3D.color4_R,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');
        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
 end
 function color4_G_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.y4=(get(idcubeml3D.color4_G,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');
        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
 end
  function color4_B_CallBack(ObjH, EventData)
        idcubeml3D = getappdata(0,'handle');
       
        color_b = getappdata(0,'color_b');
        color_b.z4=(get(idcubeml3D.color4_B,'value'));
        setappdata(0,'color_b',color_b)

        sliderFlag = getappdata(0,'sliderFlag');
        if sliderFlag~=0
            dis=getappdata(0,'Display_axes');
            display_image_3D(1,1,idcubeml3D,dis);
        end
        
  end

    function disablelb(hObject,handles)
            idcubeml3D = getappdata(0,'handle');

        tool=findall(idcubeml3D.figure,'tag','lb');
        set(tool,'Visible','Off')
        
    end
        function exportsetupdlg_main(varargin)
    exportsetupdlg;       
end

function saveasfigure(~,~)
current_folder = getappdata(0,'folders');
        ax=gca;
        filter = {'*.jpg';'*.png';'*.tif';'*.pdf';'*.eps'};
        [filename,filepath] = uiputfile(filter, 'Export Setup', current_folder);
        if ischar(filename)
           saveas(ax,[filepath filename]);
        end
end


function interactiveLinePlot2(numPoints, smoothingMethod)
    if nargin < 1
        numPoints = 15; % Default number of points
    end
    if nargin < 2
        smoothingMethod = 'linear'; % Default smoothing method
    end

    % Initial data
    x_initial = linspace(1, 256, numPoints);
    y_initial = linspace(0, 1, numPoints);  % Line from 0 to 1

    % Create figure and plot
    hFig = figure('Name', 'Interactive Profile', 'numbertitle','off','WindowButtonUpFcn', @onMouseRelease, 'Color', [0.9 0.9 0.9]);
%    movegui(hFig, 'onscreen'); %prevent figure from popping outside of the screen
 
set(hFig, 'MenuBar', 'none');
set(hFig, 'ToolBar', 'figure');
% hFig.WindowStyle = 'modal';


%% Change figure title icon
folder = fileparts(mfilename('fullpath'));
iconFilePath = fullfile(folder, 'Images', 'idcube-icon-transparent.png');
setIcon(hFig, iconFilePath);
    
    
    
    hold on;
    hSmoothPlot = plot(x_initial, y_initial, 'b-');  % Smooth line
    hPlot = plot(x_initial, y_initial, 'ro', 'MarkerFaceColor', 'r', 'MarkerIndices', 1:length(x_initial), 'ButtonDownFcn', @onMouseClick);
    axis([1 256 0 1.05]);
     xlabel('Intensity');
     ylabel('Opacity');

       % Set the position of the axes
    set(gca, 'Position', [0.13, 0.21, 0.80, 0.7]);

    % Store initial data in the figure's UserData
    hFig.UserData.x_initial = x_initial;
    hFig.UserData.y_initial = y_initial;
    hFig.UserData.hPlot = hPlot;
    hFig.UserData.hSmoothPlot = hSmoothPlot;
    hFig.UserData.selectedPointIdx = [];
    hFig.UserData.smoothingMethod = smoothingMethod;

    % Create buttons
    uicontrol('Style', 'pushbutton', 'String', 'Apply to 3D', 'Position', [.18, .022, .18, 0.08], 'Callback', @getCurveData);
    uicontrol('Style', 'pushbutton', 'String', 'Save Profile', 'Position', [.45, .020, .18, 0.08], 'Callback', @saveCurveData);
    uicontrol('Style', 'pushbutton', 'String', 'Open Profile', 'Position', [.69, .020, .18, 0.08], 'Callback', @openCurveData);
    uicontrol('Style', 'pushbutton', 'String', '?', 'Position', [.94, .94, .04, 0.05], 'Callback', @infoProfileButton);

    setappdata(0, 'hFig', hFig);

    % Create context menu
    hMenu = uicontextmenu;
    uimenu(hMenu, 'Label', 'Add Point', 'Callback', @addPoint);
    uimenu(hMenu, 'Label', 'Remove Point', 'Callback', @removePoint);
    uimenu(hMenu, 'Label', 'Smoothing Method', 'Separator', 'on', 'Enable', 'off'); % Just a label for the menu
    uimenu(hMenu, 'Label', 'Use Linear', 'Callback', @(src, event) setSmoothingMethod('linear'));
    uimenu(hMenu, 'Label', 'Use Nearest', 'Callback', @(src, event) setSmoothingMethod('nearest'));
    uimenu(hMenu, 'Label', 'Use Spline', 'Callback', @(src, event) setSmoothingMethod('spline'));
    uimenu(hMenu, 'Label', 'Use PCHIP', 'Callback', @(src, event) setSmoothingMethod('pchip'));
    uimenu(hMenu, 'Label', 'Use Makima', 'Callback', @(src, event) setSmoothingMethod('makima'));

    % Set the context menu for the axes
    set(gca, 'UIContextMenu', hMenu);

    proximityThreshold = 10;  % Proximity threshold for changing the pointer

    % Mouse click callback function
function onMouseClick(~, ~)
    if strcmp(hFig.SelectionType, 'normal')  % Left-click
        % Get current point
        cp = get(gca, 'CurrentPoint');
        cx = cp(1, 1);
        cy = cp(1, 2);

        % Find the closest data point
        [~, idx] = min((hFig.UserData.x_initial - cx).^2 + (hFig.UserData.y_initial - cy).^2);

        % Store the selected point index
        hFig.UserData.selectedPointIdx = idx;

        % Find the indices of the nearest neighbors
        if idx == 1
            leftIdx = 1;
            rightIdx = 2;
        elseif idx == length(hFig.UserData.x_initial)
            leftIdx = length(hFig.UserData.x_initial) - 1;
            rightIdx = length(hFig.UserData.x_initial);
        else
            leftIdx = idx - 1;
            rightIdx = idx + 1;
        end
        hFig.UserData.neighborIndices = [leftIdx, rightIdx];

        % Set motion function
        set(hFig, 'WindowButtonMotionFcn', @onMouseMove);
        set(hFig, 'WindowButtonUpFcn', @onMouseRelease);
    end
end

% Mouse move callback function
function onMouseMove(~, ~)
    % Get current point
    cp = get(gca, 'CurrentPoint');
    cx = cp(1, 1);
    cy = cp(1, 2);

    % Update x and y data of the selected point
    idx = hFig.UserData.selectedPointIdx;

    if idx == 1 || idx == length(hFig.UserData.x_initial)
        % Constrain to vertical movement
        cx = hFig.UserData.x_initial(idx);
    else
        % Constrain cx to be between the two nearest points and prevent overlap
        leftIdx = hFig.UserData.neighborIndices(1);
        rightIdx = hFig.UserData.neighborIndices(2);
        cx = max(hFig.UserData.x_initial(leftIdx) + 0.01, min(hFig.UserData.x_initial(rightIdx) - 0.01, cx));
    end

    % Constrain cy to be between 0 and 1
    cy = max(0, min(1, cy));

    % Update the selected point
    hFig.UserData.x_initial(idx) = cx;
    hFig.UserData.y_initial(idx) = cy;

    % Update plot
    updatePlot();
end

% Mouse release callback function
function onMouseRelease(~, ~)
    % Remove motion function
    set(hFig, 'WindowButtonMotionFcn', '');
    set(hFig, 'Pointer', 'arrow');  % Reset pointer to arrow

    % Clear selected point index
    hFig.UserData.selectedPointIdx = [];
end


    % Callback to add a point
    function addPoint(~, ~)
        % Get current point
        cp = get(gca, 'CurrentPoint');
        cx = cp(1, 1);
        cy = cp(1, 2);

        % Add the new point
        hFig.UserData.x_initial = [hFig.UserData.x_initial, cx];
        hFig.UserData.y_initial = [hFig.UserData.y_initial, cy];
        [hFig.UserData.x_initial, sortIdx] = sort(hFig.UserData.x_initial);
        hFig.UserData.y_initial = hFig.UserData.y_initial(sortIdx);

        % Update plot
        updatePlot();
    end

    % Callback to remove a point
    function removePoint(~, ~)
        % Get current point
        cp = get(gca, 'CurrentPoint');
        cx = cp(1, 1);
        cy = cp(1, 2);

        % Find the closest data point
        [~, idx] = min((hFig.UserData.x_initial - cx).^2 + (hFig.UserData.y_initial - cy).^2);

        % Remove the point
        if numel(hFig.UserData.x_initial) > 1 % Ensure at least one point remains
            hFig.UserData.x_initial(idx) = [];
            hFig.UserData.y_initial(idx) = [];
        end

        % Update plot
        updatePlot();
    end

    % Function to set smoothing method
    function setSmoothingMethod(method)
        hFig.UserData.smoothingMethod = method;
        updatePlot();
    end
    % Update plot function
    function updatePlot()
        hFig.UserData.hPlot.XData = hFig.UserData.x_initial;
        hFig.UserData.hPlot.YData = hFig.UserData.y_initial;

        % Interpolate to get a smooth line
        xx = linspace(min(hFig.UserData.x_initial), max(hFig.UserData.x_initial), 100);
        switch hFig.UserData.smoothingMethod
            case 'spline'
                yy = spline(hFig.UserData.x_initial, hFig.UserData.y_initial, xx);
            case 'linear'
                yy = interp1(hFig.UserData.x_initial, hFig.UserData.y_initial, xx, 'linear');
            case 'nearest'
                yy = interp1(hFig.UserData.x_initial, hFig.UserData.y_initial, xx, 'nearest');
            case 'pchip'
                yy = interp1(hFig.UserData.x_initial, hFig.UserData.y_initial, xx, 'pchip');
            case 'makima'
                yy = interp1(hFig.UserData.x_initial, hFig.UserData.y_initial, xx, 'makima');
            otherwise
                error('Unknown smoothing method');
        end
        yy = max(0, min(1, yy)); % Ensure yy values are between 0 and 1
        hFig.UserData.hSmoothPlot.XData = xx;
        hFig.UserData.hSmoothPlot.YData = yy;
    end


    % Callback function to retrieve full curve data
    function getCurveData(~, ~)
        idcubeml3D = getappdata(0,'handle');
        % Interpolate to get the full curve data over all 256 points
        xx_full = linspace(1, 256, 256); % Full range of x values
        switch hFig.UserData.smoothingMethod
            case 'spline'
                yy_full = spline(hFig.UserData.x_initial, hFig.UserData.y_initial, xx_full);
            case 'linear'
                yy_full = interp1(hFig.UserData.x_initial, hFig.UserData.y_initial, xx_full, 'linear');
            case 'nearest'
                yy_full = interp1(hFig.UserData.x_initial, hFig.UserData.y_initial, xx_full, 'nearest');
            case 'pchip'
                yy_full = interp1(hFig.UserData.x_initial, hFig.UserData.y_initial, xx_full, 'pchip');
            case 'makima'
                yy_full = interp1(hFig.UserData.x_initial, hFig.UserData.y_initial, xx_full, 'makima');
            otherwise
                error('Unknown smoothing method');
        end
        yy_full = max(0, min(1, yy_full)); % Ensure yy values are between 0 and 1
        setappdata(0,'custom_alpha',yy_full)
        dis = getappdata(0,'Display_axes');
        display_image_3D_custom(1,1,idcubeml3D,dis)
    end

    % Callback function to save curve data
    function saveCurveData(~, ~)
        [file, path] = uiputfile('profile.mat', 'Save Profile As');
        if isequal(file, 0)
            disp('User selected Cancel');
        else
            x = hFig.UserData.x_initial;
            y = hFig.UserData.y_initial;
            smoothingMethod = hFig.UserData.smoothingMethod;
            save(fullfile(path, file), 'x', 'y', 'smoothingMethod');
            disp(['Profile saved to ', fullfile(path, file)]);
        end
    end

    % Callback function to open curve data
    function openCurveData(~, ~)
        [file, path] = uigetfile('*.mat', 'Open Profile');
        if isequal(file, 0)
            disp('User selected Cancel');
        else
            data = load(fullfile(path, file));
            if isfield(data, 'x') && isfield(data, 'y') && isfield(data, 'smoothingMethod')
                hFig.UserData.x_initial = data.x;
                hFig.UserData.y_initial = data.y;
                hFig.UserData.smoothingMethod = data.smoothingMethod;
                updatePlot();
                disp(['Profile data loaded from ', fullfile(path, file)]);
            else
                disp('Selected file does not contain the required data.');
            end
        end
    end

 setappdata(0, 'hFig', hFig);
end


function copyfigure(~,~)
        print('-clipboard', '-dbitmap');

end

%% info window synchronized with gui movement

function infoProfileButton(varargin)
    hFig = getappdata(0, 'hFig');
    main_bgc = getappdata(0, 'main_bgc');
    tmp = get(0, 'ScreenSize');

    if tmp(4) >= 1080
        xpos = 550;
        ypos = 250;
        dimX = 1080;
        dimY = 750;
    elseif tmp(4) >= 720 && tmp(4) < 1080
        xpos = 200;
        ypos = 100;
        dimY = 700;
        dimX = 1280;
    elseif tmp(4) < 720
        xpos = 100;
        ypos = 50;
        dimY = 550;
        dimX = 700;
    end

    % Create the message figure using uifigure
    hMsgFig = uifigure('Position', [xpos + dimX + 10 ypos 300 dimY], ...
        'Color', main_bgc, ...
        'Name', 'Custom Profile', ...
        'MenuBar', 'none', ...
        'ToolBar', 'none', ...
        'Resize', 'on', ...
        'Visible', 'off', ...
        'WindowStyle', 'alwaysontop','Parent');

    % Setting the icon
    folder = fileparts(mfilename('fullpath'));
    iconFilePath = fullfile(folder, 'Images', 'idcube-icon-transparent.png');
    hMsgFig.Icon = iconFilePath;

    % Message content
setIcon(msgbox({    '1. About the Plot',...
     'The plot is initialized with 6 points displayed as red circles and a default smoothing method (linear) as a blue line.',... 
    '', '2. Moving Points:',...
     '  - Left-click on a point to select it.',...
    '  - Drag the selected point to a new position.',...
     '  - Release the mouse button to drop the point at the new location. The plot will update automatically.',...
    '', '3. Adding Points:',...
     '  - Right-click anywhere on the plot to open the context menu.',...
     '  - Select "Add Point" from the menu. A new point will be added at the clicked location, and the plot will update automatically.',...
    '', '4. Removing Points:',...
     '  - Right-click anywhere on the plot to open the context menu.',...
    '  - Select "Remove Point" from the menu. The point closest to the clicked location will be removed, and the plot will update automatically.',...
    '', '5. Changing Smoothing Method:',...
     '  - Right-click anywhere on the plot to open the context menu.',...
    '  - Select one of the smoothing methods (Linear, Nearest, Spline, PCHIP, Makima) from the menu. The plot will update with the new smoothing method applied.',...
    '', '6. Buttons:',...
     '  - Apply: Click this button to retrieve and display the full profile data.',...
     '  - Save Profile: Click this button to save the current profile (including the smoothing method) to a .mat file. You will be prompted to choose a location and filename.',...
     '  - Open Profile: Click this button to open and load previously saved profile from a .mat file. '}    ,'Custom Profile Instructions'));

    % Create a text area to display the message
    hTextArea = uitextarea(hMsgFig, 'Value', msg, ...
        'Position', [10 10 hMsgFig.Position(3) - 20 hMsgFig.Position(4) - 20], ...
        'FontSize', 12, ...
        'BackgroundColor', [0.94 0.94 0.94], ...
        'Editable', 'off');

    % Store the handles in the main figure's UserData for easy access
    hMainFig = hFig;
    hMainFig.UserData = struct('MsgFig', hMsgFig);

    % Make both figures visible after setting up everything
    hMainFig.Visible = 'on';
    hMsgFig.Visible = 'on';

    % Update the message figure position immediately
    updateMessageFigurePosition();

    % Set up a listener for the main figure's movement
    addlistener(hMainFig, 'LocationChanged', @updateMessageFigurePosition);

    % Callback function to update the message figure position
    function updateMessageFigurePosition(~, ~)
        mainFigPos = hMainFig.Position;
        msgFigPos = hMsgFig.Position;

        % Set the new position of the message figure
        newMsgPos = [mainFigPos(1) + mainFigPos(3) + 10, mainFigPos(2), msgFigPos(3), mainFigPos(4)];
        hMsgFig.Position = newMsgPos;

        % Update the text area size
        hTextArea.Position = [10 10 newMsgPos(3) - 20 newMsgPos(4) - 20];
    end
end
