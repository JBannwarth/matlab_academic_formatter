function FormatFigure( figSize, fontSize, makeAxBlack )
%FORMATFIGURE Set figure size, font-size, and use latex rendering.
%   FORMATFIGURE() formats figure using default settings (13.5*8 cm, 12pt).
%   FORMATFIGURE( FIGSIZE ) specifies the figure size (in cm).
%   FORMATFIGURE( FIGSIZE, FONTSIZE ) also specifies the font size (in pt).
%   FORMATFIGURE( FIGSIZE, FONTSIZE, MAKEAXBLACK ) forces axes to be black.
%
%   Input:
%       - figSize:     Desired figure size in format [width, height] (cm)
%       - fontSize:    Desired font-size (pt)
%       - makeAxBlack: Force axes to be black (false by default)
%
%   See also PRINTFIGURE.
%
%   Written: Z.J. Chen, J.X.J. Bannwarth
    arguments
        figSize     (1, 2) double  {mustBeNumeric,mustBeReal} = [13.5 8]
        fontSize    (1, 1) double  {mustBeNumeric,mustBeReal} = 12
        makeAxBlack (1, 1) logical                            = false
    end
    
    % Change line-widths, title and label formatting
    set( findall(gcf, '-property', 'LineWidth'), 'LineWidth', 0.5)
    set( findall(gcf, '-property', 'TitleFontWeight'), 'TitleFontWeight', 'normal')
    set( findall(gcf, '-property', 'TitleFontSizeMultiplier'), 'TitleFontSizeMultiplier', 1)
    set( findall(gcf, '-property', 'LabelFontSizeMultiplier'), 'LabelFontSizeMultiplier', 1)
    
    % Set figure proportions
    set( gcf, 'PaperUnits',        'centimeters',   ...
              'PaperPositionMode', 'manual',        ...
              'PaperPosition',     [0, 0, figSize], ...
              'PaperSize',         figSize,         ...
              'Color',             [1, 1, 1]        )

    % Format fonts
    set( findall(gcf, '-property', 'FontSize'), 'FontSize', fontSize )
    set( findall(gcf, '-property', 'Interpreter'), 'Interpreter', 'latex' )
    set( findall(gcf, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex' )
    
    % Force axes to be black if required
    if makeAxBlack
        % Only adjust axes colours if they are not part of the default set, in
        % order not to break multi-axes plots
        axs = 'XYZ';
        defaultColours = lines();
        for ii = 1:3
            axHandles = findall(gcf, '-property', [ axs(ii) 'Color' ]);
            for jj = 1:length( axHandles )
                if ~nnz( ismember( defaultColours, ...
                        get( axHandles(jj), [ axs(ii) 'Color' ] ), 'rows' ) )
                    set( axHandles(jj), [ axs(ii) 'Color' ], 'k' );
                end
            end
        end
    end
end