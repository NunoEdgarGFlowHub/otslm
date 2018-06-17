function [output, filtered] = spatial_filter(input, filter, varargin)
% SPATIAL_FILTER applies a spatial filter to the image spectrum
%
% output, filtered = spatial_filter(input, filter, ...) applies filter to the
% fourier transform of input and calculates the inverse fourier
% transform to give output.  Optional output filtered is the filtered
% pattern.
%
% Optional named parameters:
%     'padding'       padding     Add padding to the outside of the image.
%     'keep_padding'  keep        Keep or discard padding after filter

p = inputParser;
p.addParameter('padding', 100);
p.addParameter('keep_padding', false);
p.parse(varargin{:});

pad = p.Results.padding;

% Calculate pattern in conjugate plane
filtered = otslm.tools.visualise(ones(size(input)), 'incident', input, ...
    'method', 'fft', 'type', 'farfield', 'padding', pad);

% Apply the filter

assert(all(size(filter) <= size(filtered)), ...
  'Size of filter must be smaller than input+2*padding');

padr = size(filtered) - size(filter);
filtered_roi = zeros(size(filtered), 'logical');
filtered_roi(padr(1)+1:end-padr(1), padr(2)+1:end-padr(2)) = 1;
filtered(filtered_roi) = filtered(filtered_roi) .* filter;
filtered(~filtered_roi) = 0.0;

% Calculate pattern in output plane (no extra padding)
output = otslm.tools.visualise(ones(size(input)), 'incident', filtered, ...
    'method', 'fft', 'type', 'nearfield', 'padding', 0);

% Remove padding if asked

if ~p.Results.keep_padding
  output = output(pad+1:end-pad, pad+1:end-pad);
end