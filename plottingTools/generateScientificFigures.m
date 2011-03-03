function varargout = generateScientificFigures(processedData, griddedData, imageryPath, imgPreffix)

    [figProperties, cmJet] = setFiguresProperties([1280, 768]);

    texts.imgsPath = imageryPath;

    imageList = struct('name', {}, 'description', {}, 'path', {});
    

    % Plot vertical transects of in situ Temperature, Salinity and Density
    desiredAxis = 'dist';
    switch lower(desiredAxis),
        case 'time'
            texts.xLabelStr = 'Time';
            xAxisVar = epoch2datenum(processedData.navTime);
        case 'dist'
            texts.xLabelStr = 'Distance (Km)';
            xAxisVar = processedData.distanceOverGround;
        case 'lat'
            texts.xLabelStr = 'Latitude (Degrees)';
            xAxisVar = processedData.lat;
        case 'lon'
            texts.xLabelStr = 'Longitude (Degrees)';
            xAxisVar = processedData.lon;
    end;

    if isfield(processedData, 'temperature')
        texts.colorbarTitle = 'Temperature (^{o}C)';
        texts.figureTitle = 'In Situ Temperature';
        texts.imageFilename = [imgPreffix, 'temperature'];
        figProperties.linearColorScale = 1;

        fn = plotVerticalTransect(figProperties, cmJet, ...
            xAxisVar, processedData.depth, processedData.temperature, texts);
        imageList(end+1).name = 'Temperature Section';
        imageList(end).description = 'Cross Section of in situ measured temperature';
        imageList(end).path = fn;
    end;
    
    if isfield(processedData, 'salinity_corrected_TH')
        texts.colorbarTitle = 'Salinity (psu)';
        texts.figureTitle = 'In Situ Salinity (ThL corrected)';
        texts.imageFilename = [imgPreffix, 'salinity'];
        figProperties.linearColorScale = 1;

        fn = plotVerticalTransect(figProperties, cmJet, ...
            xAxisVar, processedData.depth, processedData.salinity_corrected_TH, texts);
        imageList(end+1).name = 'Salinity Section';
        imageList(end).description = 'Cross Section of thermal lag corrected derived salinity';
        imageList(end).path = fn;
        
    elseif isfield(processedData, 'salinity')
        texts.colorbarTitle = 'Salinity (psu)';
        texts.figureTitle = 'In Situ Salinity';
        texts.imageFilename = [imgPreffix, 'salinity'];
        figProperties.linearColorScale = 1;

        fn = plotVerticalTransect(figProperties, cmJet, ...
            xAxisVar, processedData.depth, processedData.salinity, texts);
        imageList(end+1).name = 'Salinity Section';
        imageList(end).description = 'Cross Section of derived salinity';
        imageList(end).path = fn;
    end;
		
    if isfield(processedData, 'density')
        texts.colorbarTitle = 'Density (Kg/m^3)';
        texts.figureTitle = 'In Situ Density';
        texts.imageFilename = [imgPreffix, 'density'];
        figProperties.linearColorScale = 1;

        fn = plotVerticalTransect(figProperties, cmJet, ...
            xAxisVar, processedData.depth, processedData.density, texts);
        imageList(end+1).name = 'Density Section';
        imageList(end).description = 'Cross Section of derived density';
        imageList(end).path = fn;

    end;

    if isfield(processedData, 'sound_velocity')
        texts.colorbarTitle = 'Sound Speed (m/s)';
        texts.figureTitle = 'Sound Speed';
        texts.imageFilename = [imgPreffix, 'soundspeed'];
        figProperties.linearColorScale = 1;

        fn = plotVerticalTransect(figProperties, cmJet, ...
            xAxisVar, processedData.depth, processedData.sound_velocity, texts);
        imageList(end+1).name = 'Sound Velocity Section';
        imageList(end).description = 'Cross Section of in situ measured salinity';
        imageList(end).path = fn;

    end;
    
    % Plot vertical transects of in situ Chlorophyll, Turbidity and Oxygen
    if isfield(processedData, 'chlorophyll')
        texts.colorbarTitle = 'Chlorophyll (\mug/l)';
        texts.figureTitle = 'In Situ Chlorophyll';
        texts.imageFilename = [imgPreffix, 'chlorophyll'];
        figProperties.linearColorScale = 0;

        varValues = processedData.chlorophyll;
        varValues(varValues < 0) = min(varValues(varValues > 0));
        fn = plotVerticalTransect(figProperties, cmJet, ...
            xAxisVar, processedData.depth, log10(varValues), texts);
        imageList(end+1).name = 'Chlorophyll Section';
        imageList(end).description = 'Cross Section of derived chlorophyll';
        imageList(end).path = fn;
    end;

    if isfield(processedData, 'cdom')
        texts.colorbarTitle = 'CDOM (ppb)';
        texts.figureTitle = 'In Situ CDOM';
        texts.imageFilename = [imgPreffix, 'cdom'];
        figProperties.linearColorScale = 0;

        varValues = processedData.cdom;
        varValues(varValues < 0) = min(varValues(varValues > 0));
        fn = plotVerticalTransect(figProperties, cmJet, ...
            xAxisVar, processedData.depth, log10(varValues), texts);
        imageList(end+1).name = 'CDOM Section';
        imageList(end).description = 'Cross Section of in situ measured CDOM';
        imageList(end).path = fn;
    end;
    
    if isfield(processedData, 'turbidity')
        texts.colorbarTitle = 'Turbidity (NTU)';
        texts.figureTitle = 'In Situ Turbidity';
        texts.imageFilename = [imgPreffix, 'turbidity'];
        figProperties.linearColorScale = 0;

        varValues = processedData.turbidity;
        varValues(varValues < 0) = min(varValues(varValues > 0));
        fn = plotVerticalTransect(figProperties, cmJet, ...
            xAxisVar, processedData.depth, log10(varValues), texts);
        imageList(end+1).name = 'Turbidity Section';
        imageList(end).description = 'Cross Section of in situ measured turbidity';
        imageList(end).path = fn;
    end;
    
    if isfield(processedData, 'oxygen')
        texts.colorbarTitle = 'Oxygen (perc.)';
        texts.figureTitle = 'In Situ Oxygen Saturation';
        texts.imageFilename = [imgPreffix, 'oxygen_saturation'];
        figProperties.linearColorScale = 1;

        fn = plotVerticalTransect(figProperties, cmJet, ...
            xAxisVar, processedData.depth, processedData.oxygen, texts);
        imageList(end+1).name = 'Oxygen Section';
        imageList(end).description = 'Cross Section of in situ measured dissolved oxygen';
        imageList(end).path = fn;
    end;

    % Irradiance
    for wavLen = [412, 442, 491, 664]
        varName = sprintf('irradiance%03dnm', wavLen);
        if isfield(processedData, varName)
            varValues = processedData.(varName);
            varValues(varValues <= 0) = min(varValues(varValues > 0)) / 2;
            texts.colorbarTitle = 'Irradiance (uW/cm^2/nm)';
            texts.figureTitle = sprintf('Irradiance at %03d nm', wavLen);
            texts.imageFilename = [imgPreffix, varName];
            figProperties.linearColorScale = 0;
            
            fn = plotVerticalTransect(figProperties, cmJet, ...
                xAxisVar, processedData.depth, log10(varValues), texts);
            imageList(end+1).name = [varName, ' Section'];
            imageList(end).description = ['Cross Section of in situ measured ', varName];
            imageList(end).path = fn;
        end;
    end;
    
    % Backscatter:
    colorChannels = {'470', '532', '660'};
    for channelIdx = 1:length(colorChannels)
        varName = sprintf('backscatter%s', colorChannels{channelIdx});
        if isfield(processedData, varName)
            varValues = processedData.(varName);
            varValues(varValues <= 0) = min(varValues(varValues > 0));
            texts.colorbarTitle = 'Backscatter (1)';
            texts.figureTitle = sprintf('%s backscatter', colorChannels{channelIdx});
            texts.imageFilename = [imgPreffix, varName];
            figProperties.linearColorScale = 0;

            fn = plotVerticalTransect(figProperties, cmJet, ...
                xAxisVar, processedData.depth, log10(varValues), texts);
            imageList(end+1).name = [varName, ' Section'];
            imageList(end).description = ['Cross Section of in situ measured ', varName];
            imageList(end).path = fn;
        end;
    end

    % Plot mean vertical profiles of in situ Temperature, Salinity and Density
    if all(isfield(processedData, ...
            {'meanTemperatureProfile';
             'stdTemperatureProfile';
             'meanSalinityProfile';
             'stdSalinityProfile';
             'meanDensityProfile';
             'stdDensityProfile'}))
         
        texts.imageFilename = [imgPreffix, 'ctd_profiles'];

        profileData(1).meanVarProfile = processedData.meanTemperatureProfile;
        profileData(1).stdVarProfile  = processedData.stdTemperatureProfile;
        profileData(1).varName        = 'Temperature';
        profileData(1).varUnits       = '^{o}C';

        profileData(2).meanVarProfile = processedData.meanSalinityProfile;
        profileData(2).stdVarProfile  = processedData.stdSalinityProfile;
        profileData(2).varName        = 'Salinity';
        profileData(2).varUnits       = 'psu';

        profileData(3).meanVarProfile = processedData.meanDensityProfile;
        profileData(3).stdVarProfile  = processedData.stdDensityProfile;
        profileData(3).varName        = 'Density';
        profileData(3).varUnits       = 'Kg/m^3';
    
        for k = 1:length(profileData)
            if any(isnan(profileData(k).stdVarProfile))
                profileData(k).stdVarProfile = zeros(size(profileData(k).meanVarProfile));
            end;
        end;
        fn = plotMeanProfiles(figProperties, profileData,...
            processedData.depthRangeMatrix, texts);
        imageList(end+1).name = ' CTD Profiles';
        imageList(end).description = 'CTD Profiles';
        imageList(end).path = fn;

    end;
    if 0,%isfield(processedData, 'meanChlorophyllProfile'),
        clear profileData;
        % Plot mean vertical profiles of in situ Oxygen
        texts.imageFilename = 'chlor_profiles';

        profileData(1).meanVarProfile = processedData.meanChlorophyllProfile;
        profileData(1).stdVarProfile  = processedData.stdChlorophyllProfile;
        profileData(1).varName        = 'Chlorophyll';
        profileData(1).varUnits       = '\mug/l';

        fn = plotMeanProfiles(figProperties, profileData,...
            processedData.depthRange, texts);
        imageList(end+1).name = ' BGC Profiles';
        imageList(end).description = 'BGC Profiles';
        imageList(end).path = fn;

    end;
    
    if 0,%isfield(processedData, 'meanOxygenProfile'),
        clear profileData;
        % Plot mean vertical profiles of in situ Oxygen
        texts.imageFilename = 'oxy_profiles';

        profileData(2).meanVarProfile = processedData.meanOxygenProfile;
        profileData(2).stdVarProfile  = processedData.stdOxygenProfile;
        profileData(2).varName        = 'Oxygen';
        profileData(2).varUnits       = '% saturation';

        plotMeanProfiles(figProperties, profileData,...
            processedData.depthRange, texts);
    end;
    
    [figProperties, cmJet] = setFiguresProperties([1280, 1024]);

    % Plot a TS Diagram for water masses identification
    texts.imageFilename = [imgPreffix, 'ts_diagram'];
    fn = plotTSDiagram(figProperties, processedData.temperature, processedData.salinity, texts);
    imageList(end+1).name = 'TS Diagram';
    imageList(end).description = 'Temperature vs. Salinity Diagram';
    imageList(end).path = fn;

    % Plot a horizontal map to check glider trajectory
    % and currents found along the way
    if isfield(processedData, 'waterInfo')
        texts.imageFilename = [imgPreffix, 'currents'];
        fn = plotCurrentsMap(figProperties, processedData.waterInfo, texts);
        imageList(end+1).name = 'Currents Map';
        imageList(end).description = 'map with vertically integrated currents derived from navigation';
        imageList(end).path = fn;
        
    end;
    % Plot gridded vertical sections here?

    close all;
    
    if nargout > 0
    	varargout{1} = imageList;
    end

return;
