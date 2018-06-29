classdef (Abstract) Viewable < handle
% VIEWABLE represents objects that can be viewed (cameras)
%
% Methods (Abstract)
%   view()        Show an image from the device.
%
% Methods:
%   viewTarget()  Show an image of the target region from the device.
%       The default behaviour is just to call view().
%
% Properties (Abstract)
%   size          Size of the device [rows, columns]
%   roisize       Size of the target region [rows, columns]
%
% This is the interface that utility functions which request an
% image from the experiment/simulation use.  For declaring a new
% camera, you should inherit from this class and define the view method.
%
% Copyright 2018 Isaac Lenton
% This file is part of OTSLM, see LICENSE.md for information about
% using/distributing this file.

  methods (Abstract)
    view(obj)       % Acquire an image from the device
  end

  methods
    function im = viewTarget(obj)
      % View the target, applies a ROI to the result of view()
      % TODO: Not yet implemented
      im = obj.view();
    end
  end

  properties (Abstract, SetAccess=protected)
    size        % Size of the device [rows, columns]
    roisize     % Size of the region of interest [rows, columns]
  end

end