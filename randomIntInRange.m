function r = randomIntInRange(a,b,varargin)

% Returns a random integer in range [a,b] (inclusive)
% Additional arguments indicate size of returned matrix

r = a-1+randi(b-a+1,varargin{:});

end