function genGriddedGliderNcFile(outFilename, griddedData, params)
%GENGRIDDEDGLIDERNCFILE - Generates a glider netcdf file from gridded data
% This function creates, defines and fills in a netcdf file with glider data
%
% Syntax: genGriddedGliderNcFile(outFilename, griddedData, params)
%
% Inputs:
%    outFilename - Fully qualified name of the netcdf output file
%    griddedData - structure containing the fields to be converted to
%    variables
%    params - structure containing the glider deployment metadata
%
% Outputs: none
%
% Example:
%    genGriddedGliderNcFile(outFilename, griddedData, params)
%
% Other m-files required: SNCTOOLS toolbox required
% Subfunctions: none
% MAT-files required: none
%
% See also: NC_CREATE_EMPTY, NC_ADD_DIMENSION, NC_ADDVAR, NC_ATTPUT,
% NC_VARPUT
%
% Author: Bartolome Garau
% Work address: Parc Bit, Naorte, Bloc A 2ºp. pta. 3; Palma de Mallorca SPAIN. E-07121
% Author e-mail: tgarau@socib.es
% Website: http://www.socib.es
% Creation: 17-Feb-2011
%

%% FILE CREATION
    % First of all, generate an empty file to be filled in
    nc_create_empty(outFilename);
    %nc_padheader(outFilename, 2^15);
%% DIMENSIONS
    numCasts  = length(griddedData.gridCoords.distanceRange);
    numDepths = length(griddedData.gridCoords.depthRange);
    % Add the horizontal and vertical dimensions
    nc_add_dimension(outFilename, 'depth', numDepths); 
    nc_add_dimension(outFilename, 'profile', numCasts);
    
%% VARIABLES

    % Coordinate variables
    coordList = fieldnames(griddedData.gridCoords);
    % Loop through the list of fields to define the file
    for fieldIdx = 1:length(coordList)
        currFieldName = coordList{fieldIdx};
        name = currFieldName(1:end-5);
        varstruct.Name = currFieldName;
        varstruct.Nctype = 'NC_DOUBLE';
        if strcmp(currFieldName, 'depthRange')
            varstruct.Dimension = {'depth'};
        else
            varstruct.Dimension = {'profile'};
        end;
        varstruct.Attribute = getProcGliderVarAtts(name);
        nc_addvar(outFilename, varstruct);

    end;

    % Scientific variables
    fieldList = fieldnames(griddedData.grids);
    % Loop through the list of fields to define the file
    for fieldIdx = 1:length(fieldList)
        currFieldName = fieldList{fieldIdx};
        % If the field contains just one number, 
        % it will be assumed to be a column definition, thus,
        % a variable for the netcdf
        varstruct.Name = currFieldName;
        varstruct.Nctype = 'NC_DOUBLE';
        varstruct.Dimension = {'depth', 'profile'};
        varstruct.Attribute = getProcGliderVarAtts(currFieldName);
        nc_addvar(outFilename, varstruct);
    end;

%% GLOBAL ATTRIBUTES: METADATA
    % A list of 'fixed' attributes (user can override them)
    nc_attput(outFilename, nc_global, 'creation_date', datestr(now));
    writeGliderStaticMetadata(outFilename);
    
    % Get the list of fields appearing on the params structure
    paramNames = fieldnames(params);
    
    % Define a parameter name preffix to look for
    mdPreffix = 'METADATA_';
    preffixLength = length(mdPreffix);
    
    % Loop through the list of fields to find metadata fields
    for paramIdx = 1:length(paramNames)
        currentParamName = paramNames{paramIdx};
        
        % If the field name starts with the predefined preffix
        % get the rest of the name and add it to the netcdf file
        % as a global attribute
        if strncmp(currentParamName, mdPreffix, preffixLength)
            attName = currentParamName(preffixLength+1:end);
            nc_attput(outFilename, nc_global, attName, params.(currentParamName));
        end;
    end;

    % Source ascii files list
    if isfield(griddedData, 'source') && ~isempty(griddedData.source)
        sourceFileList = griddedData.source{1};
        for srcIdx = 2:length(griddedData.source)
            sourceFileList = strcat(sourceFileList, ['; ', griddedData.source{srcIdx}]);
        end;
        nc_attput(outFilename, nc_global, 'source_files', sourceFileList);
    end;
    
%% FILE FILLING

    % Coordinate variables
    fieldList = fieldnames(griddedData.gridCoords);
    % Loop through the list of fields to define the file
    for fieldIdx = 1:length(fieldList)
        currentFieldName = fieldList{fieldIdx};
        currentFieldData = griddedData.gridCoords.(currentFieldName);
        try
            nc_varput(outFilename, currentFieldName, currentFieldData(:));
        catch
            keyboard;
        end;
    end;

    % Scientific variables
    fieldList = fieldnames(griddedData.grids);
    % Loop through the list of fields to define the file
    for fieldIdx = 1:length(fieldList)
        currentFieldName = fieldList{fieldIdx};
        currentFieldData = griddedData.grids.(currentFieldName);
        nc_varput(outFilename, currentFieldName, currentFieldData);
    end;

    lat = griddedData.gridCoords.latitudeRange;
    lon = griddedData.gridCoords.longitudeRange;
     
    latIdx  = find(~isnan(lat),  1, 'first');
    lonIdx  = find(~isnan(lon),  1, 'first');

    % Rewrite some global attributes with contained information
 	nc_attput(outFilename, nc_global, 'launch_latitude', lat(latIdx));
    nc_attput(outFilename, nc_global, 'launch_longitude', lon(lonIdx));
    
    nc_attput(outFilename, nc_global, 'southernmost_latitude', nanmin(lat));
    nc_attput(outFilename, nc_global, 'northernmost_latitude', nanmax(lat));
    nc_attput(outFilename, nc_global, 'westernmost_longitude', nanmin(lon));
    nc_attput(outFilename, nc_global, 'easternmost_longitude', nanmax(lon));
    
end
