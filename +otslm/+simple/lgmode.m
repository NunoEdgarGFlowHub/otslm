function [phase, amplitude] = lgmode(sz, amode, rmode, varargin)
% LGMODE generates the phase pattern for a LG beam
%
% pattern = lgbeam(sz, amode, rmode, radius, ...) generates the phase
% pattern with azimuthal order amode, radial order rmode.
%
% [phase, amplitude] = lgbeam(...) also generates the amplitude pattern.
%
% Optional named parameters:
%
%   'centre'    [ x, y ]    centre location (default: pattern centre)
%   'aspect'    aspect      aspect ratio of generated pattern
%   'angle'     angle       Rotation angle about axis (radians)
%   'angle_deg' angle       Rotation angle about axis (degrees)
%   'radius'    radius      scaling factor for radial mode rings
%   'p0'        p0          incident amplitude correction factor
%       Should be 1.0 (default) for plane wave illumination (w_i = Inf),
%       for Gaussian beams should be p0 = 1 - radius^2/w_i^2.

% Check mode numbers
assert(rmode >= 0, 'Radial mode must be >= 0');
assert(floor(rmode) == rmode, 'Radial mode must be integer');
assert(floor(amode) == amode, 'Azimuthal mode must be integer');

% Parse inputs
p = inputParser;
p.addParameter('centre', [ sz(2)/2, sz(1)/2 ]);
p.addParameter('aspect', 1.0);
p.addParameter('angle', []);
p.addParameter('angle_deg', []);
p.addParameter('radius', min(sz(1), sz(2))/10);
p.addParameter('p0', 1.0);
p.parse(varargin{:});

% Generate coordinates
[~, ~, rho, phi] = otslm.simple.grid(sz, ...
    'centre', p.Results.centre, 'aspect', p.Results.aspect, ...
    'angle', p.Results.angle, 'angle_deg', p.Results.angle_deg);

% Calculate azimuthal part of pattern
phase = amode .* phi ./ (2.0*pi);

% Calculate laguerre polynomials in radial direction
maxrho = max(rho(:));
rr = linspace(0.0, maxrho, 2*maxrho);
Lpoly_rr = laguerreL(rmode, abs(amode), (rr./p.Results.radius).^2);

% Interpolate between points using splines
Lpoly_rho = interp1((rr./p.Results.radius).^2, Lpoly_rr, ...
    (rho./p.Results.radius).^2, 'spline');

% Calculate radial part of phase
phase = phase + (sign(Lpoly_rho) > 0)*0.5;

% Calculate the amplitude too
if nargout == 2

  amplitude = (rho./p.Results.radius).^abs(2*amode) ...
      .* Lpoly_rho .* exp(-p.Results.p0*0.5*(rho./p.Results.radius).^2);

  % Normalize amplitude maximum value
  amplitude = amplitude ./ max(abs(amplitude(:)));

end

end

