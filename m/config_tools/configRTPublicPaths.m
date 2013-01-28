function public_paths = configRTPublicPaths()
%CONFIGRTPUBLICPATHS  Configure public product and figure paths for glider deployment real time data.
%
%  PUBLIC_PATHS = CONFIGRTPUBLICPATHS() should return a struct with the path 
%  patterns for the public copies of the deployment product files generated by 
%  the glider processing chain. It should have the following fields:
%    FIGURE_PATH: path pattern of the public directory for deployment figures.
%    FIGURE_LIST: path pattern of the public JSON file providing the list of 
%      deployment figures with their description and their URL. 
%    NETCDF_L0: path pattern of the public NetCDF file for raw data
%      (data provided by the glider without any meaningful modification).
%    NETCDF_L1: path pattern of the publict NetCDF file for processed trajectory
%      data (properly referenced data with conversions, corrections and 
%      derivations).
%    NETCDF_L2: path pattern of the public NetCDF file for gridded data
%      (already processed data interpolated on vertical instantaneous profiles).
%  These path patterns are converted to true paths through the function
%  STRFGLIDER.
%
%  Notes:
%    Edit this file filling in the paths to reflect your desired file layout.
%
%  Examples:
%    public_paths = configRTPublicPaths()
%
%  See also:
%    MAIN_GLIDER_DATA_PROCESSING_RT
%    CONFIGRTLOCALPATHS
%    STRFGLIDER
%
%  Author: Joan Pau Beltran
%  Email: joanpau.beltran@socib.cat

  error(nargchk(0, 0, nargin, 'struct'));

  public_paths.netcdf_l0 = '/path/to/public/glider_data/${GLIDER_NAME}/${DEPLOYMENT_START_DATE}/netcdf/${GLIDER_NAME}_${DEPLOYMENT_START_DATE}_l0.nc';
  public_paths.netcdf_l1 = '/path/to/public/glider_data/${GLIDER_NAME}/${DEPLOYMENT_START_DATE}/netcdf/${GLIDER_NAME}_${DEPLOYMENT_START_DATE}_l1.nc';
  public_paths.netcdf_l2 = '/path/to/public/glider_data/${GLIDER_NAME}/${DEPLOYMENT_START_DATE}/netcdf/${GLIDER_NAME}_${DEPLOYMENT_START_DATE}_l2.nc';
  
end
