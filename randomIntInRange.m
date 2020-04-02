function r = randomIntInRange(a,b,varargin)

% Returns a random integer in range [a,b] (inclusive)
% Additional arguments indicate size of returned matrix

r = floor((b-a+1)*rand(varargin{:}))+a;

end