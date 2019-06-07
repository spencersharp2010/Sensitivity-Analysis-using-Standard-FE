%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _______________________________________________________               %
%   _______________________________________________________               %
%                                                                         %
%   Technische Universität München                                        %
%   Lehrstuhl für Statik, Prof. Dr.-Ing. Kai-Uwe Bletzinger               %
%   _______________________________________________________               %
%   _______________________________________________________               %
%                                                                         %
%                                                                         %
%   Authors                                                               %
%   _______________________________________________________________       %
%                                                                         %
%   Dipl.-Math. Andreas Apostolatos    (andreas.apostolatos@tum.de)       %
%   Dr.-Ing. Roland Wüchner            (wuechner@tum.de)                  %
%   Prof. Dr.-Ing. Kai-Uwe Bletzinger  (kub@tum.de)                       %
%   _______________________________________________________________       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  plot_EdgesTriangularMesh2D(mesh)
%% Function documentation
%
% Plots the edges of the given triangular mesh
%
%   Input :
%    mesh : The nodes, the edges and the coonectivity of the triabgular
%           mesh
%
%  Output : 
%           Graphics
% 
%% Function main body

% Plot the edges of the mesh
cla,patch('vertices',mesh.nodes,'faces',mesh.elements,'edgecol','k','facecol','none');
% cla,patch('vertices',mesh.nodes,'faces',mesh.elements,'edgecol','k','facecol',[217 218 219]/255);

end

