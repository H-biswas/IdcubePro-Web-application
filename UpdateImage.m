classdef UpdateImage
    methods (Static)
        function updateImage(app)
            value = round(app.BandSlider.Value);
            disp(value)
            matrices = getappdata(0, 'myData');
            Image = im2double(matrices.Images);
            I = Image(:, :, value);
            axes(app.image_axes)
            selectedButton = app.ColormapSelectionButtonGroup.SelectedObject;

            if selectedButton == app.jetButton
                cmap = jet;
            elseif selectedButton == app.autumnButton
                cmap = autumn;
            elseif selectedButton == app.boneButton
                cmap = bone;
            elseif selectedButton == app.coolButton
                cmap = cool;
            elseif selectedButton == app.copperButton
                cmap = copper;
            elseif selectedButton == app.grayButton
                cmap = gray;
            elseif selectedButton == app.hotButton
                cmap = hot;
            elseif selectedButton == app.pinkButton
                cmap = pink;
            elseif selectedButton == app.springButton
                cmap = spring;
            elseif selectedButton == app.summerButton
                cmap = summer;
            elseif selectedButton == app.winterButton
                cmap = winter;
            elseif selectedButton == app.hsvButton
                cmap = hsv;
            elseif selectedButton == app.colorcubeButton
                cmap = colorcube;
            elseif selectedButton == app.flagButton
                cmap = flag;
            elseif selectedButton == app.linesButton
                cmap = lines;
            elseif selectedButton == app.prismButton
                cmap = prism;
            else
                cmap = jet;  % fallback
            end

            imshow(I, [], 'Parent', app.image_axes, 'Colormap', cmap);
            colorbar(app.image_axes, "Color", [1 1 1])
        end
    end
end
