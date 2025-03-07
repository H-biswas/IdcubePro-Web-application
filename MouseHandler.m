classdef MouseHandler
    methods (Static)
        function results = mouseMove(app)
            C = get(app.image_axes, 'CurrentPoint');
            x = round(C(1,1));
            y = round(C(1,2));

            matrices = getappdata(0, 'myData');
            mat = matrices.Images;
            wavelengths = matrices.Wavelengths;
            NumberChannels = numel(wavelengths);

            dim = size(mat);
            xlim = get(app.image_axes, 'XLim');
            ylim = get(app.image_axes, 'YLim');
            outX = ~any(diff([xlim(1) C(1,1) xlim(2)]) < 0);
            outY = ~any(diff([ylim(1) C(1,2) ylim(2)]) < 0);

            if outX && outY
                try
                    val_channel = reshape(mat(y, x, :), [1, dim(end)]);
                    [I, b] = max(val_channel);
                    new_x = wavelengths(1, :);
                    [val, idx] = max(val_channel);

                    plot(new_x, val_channel, '-o', ...
                        'MarkerSize', 50 / (NumberChannels + 3), ...
                        'LineWidth', 1.5, ...
                        'Color', [0.0244, 0.435, 0.8755], ...
                        'Parent', app.spectra);
                catch
                end
            end
        end
    end
end
