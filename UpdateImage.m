classdef UpdateImage
    methods (Static)
        function updateImage(app)
            matrices = getappdata(0, 'myData');
            if isempty(matrices)
                return;
            end
            Image = im2double(matrices.Images);
            diff = abs(round(app.BandSlider.Value)-matrices.Wavelengths);
            index = diff==min(diff);
            I = Image(:, :, index);
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
            axis(app.image_axes, 'image')
            colorbar(app.image_axes, "Color", [1 1 1])
        end
        function updateRGB(app)
            matrices = getappdata(0, 'myData');
            if isempty(matrices)
                return;
            end
            Image = im2double(matrices.Images); 

            diff = abs(round(app.Band1Slider.Value)-matrices.Wavelengths);
            band1 = diff==min(diff);
            diff = abs(round(app.Band2Slider.Value)-matrices.Wavelengths);
            band2 = diff==min(diff);
            diff = abs(round(app.Band3Slider.Value)-matrices.Wavelengths);
            band3 = diff==min(diff);
            
            R = Image(:, :, band1);
            G = Image(:, :, band2);
            B = Image(:, :, band3);
        
            R = mat2gray(R);
            G = mat2gray(G);
            B = mat2gray(B);
        
            RGB = cat(3, R, G, B);
            
            axes(app.image_axes);
            app.ColormapSelectionButtonGroup.Visible = "off";
            colorbar(app.image_axes, 'off')
            imshow(RGB,[],'Parent', app.image_axes);
            axis(app.image_axes, 'image')
        end
    end
end
