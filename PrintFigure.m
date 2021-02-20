function PrintFigure( filename, formats, res )
%PRINTFIGURE Print figure to PDF, EPS, or PNG.
%   PRINTFIGURE( ) exports figure to PDF titled after the figure name.
%   PRINTFIGURE( FILENAME ) specifies the filename.
%   PRINTFIGURE( FILENAME, FORMATS ) export figure to selected formats.
%   PRINTFIGURE( FILENAME, FORMATS, RES ) also defines resolution of PNG.
%
%   Inputs:
%       - filename: name of the file to export to (extension is ignored).
%       - formats : char or cell array of car of formats to export.
%                   Recognised formats: 'pdf', 'eps', 'png'
%       - res     : resolution of png export in ppi.
%
%   See also FORMATFIGURE, PRINT.
%
%   Written: Z.J. Chen, J.X.J. Bannwarth
    arguments
        filename (1,:) char                                   = ''
        formats  (1,:)        {mustBeNonempty}                = 'pdf'
        res      (1,1) double {mustBePositive, mustBeInteger} = 300
    end
    
    %% Input processing
    % If filename is not defined, read figure title
    if isempty( filename )
        h = gcf;
        if ~isempty( h.Name )
            filename = h;
        else
            % Default to figureXX if no title is defined
            filename = sprintf( 'figure%02d', h.Number );
        end
    end
    
    recognisedFormats = { 'pdf', 'eps', 'png' };
    % Remove extension to prevent double extensions, e.g. .pdf.pdf
    [filePath, filenameBody, ext] = fileparts( filename );
    if sum( contains( recognisedFormats, lower( ext(2:end) ) ) )
        filename = [ filePath filenameBody ];
    end
    
    % Convert formats to cell array
    if ~iscell( formats )
        formats = { formats };
    end
    
    % Check formats
    for ii = 1:length( formats )
        if ~contains( recognisedFormats, lower(formats{ii}) )
            error( 'Format not recognised: %s', formats{ii} )
        end
    end
    
    %% Print figure
    if sum( contains( lower( formats ), 'pdf' ) )
        print( gcf, filename, '-dpdf', '-loose' )
    end

    if sum( contains( lower( formats ), 'eps' ) )
        % Export initial eps file
        print( gcf, filename, '-depsc', '-loose' )
        
        % Replace \n by \r\n in eps file
        eps = fileread( [filename, '.eps'] );
        fid = fopen( [filename, '.eps'], 'wt' );
        fwrite( fid, eps );
        fclose( fid );
    end
    
    if sum( contains( lower( formats ), 'png' ) )
        % Set quality
        resString = sprintf( '-r%d', res );
        print( gcf, filename, '-dpng', resString )
    end
end