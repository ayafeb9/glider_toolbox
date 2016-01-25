function combined_struct = combineDataAndQc(data_struct, qc_struct)
%COMBINEDATAANDQC  Combines the data struct with QC outputs.
%
%  Syntax:
%    COMBINED_STRUCT = COMBINEDATAANDQC(DATA_STRUCT, QC_STRUCT)
%
%  Description:
%    Returns one structure consisting the data and QC flagged output, as
%    well as the QC identifiers. To add data to the COMBINED_STRUCT, the
%    QC_STRUCT fieldnames should be the same as those in the DATA_STRUCT. 
%
%  Notes:
%    Adds only qcFlaggedOutput and appliedQcIdentifiers to data fields that
%    have the same fieldname than those in DATA_STRUCT.
%
%  Examples:
%    test_struct.time = [1 2 3 4 5];
%    test_qc_struct.time.qcFlaggedOutput = [1 1 1 4 1];
%    test_qc_struct.time.appliedQcIdentifiers = ['' '' '' 'impossibleDateCheck' ''];
%    combineDataAndQc(test_struct, test_qc_struct)
%
%  See also:
%    ADDQCTONETCDFVARIABLES
%    PERFORMQC
%    PERFORMGRIDDEDQC
%
%  Authors:
%    Andreas Krietemeyer  <akrietemeyer@socib.es>

%  Copyright (C) 2016
%  ICTS SOCIB - Servei d'observacio i prediccio costaner de les Illes Balears.
%  <http://www.socib.es>
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.

names_data = fieldnames(data_struct);
combined_struct = struct();

for i=1:numel(names_data)
    combined_struct.(names_data{i}) = data_struct.(names_data{i});
    if isfield(qc_struct, (names_data{i}))
        combined_struct.(strcat(names_data{i}, '_QC')) = qc_struct.(names_data{i}).qcFlaggedOutput;
        %combined_struct.(strcat(names_data{i}, '_QC_Identifier')) = qc_struct.(names_data{i}).appliedQcIdentifiers;
    else
        disp('QC variable name not found')
    end
end
end