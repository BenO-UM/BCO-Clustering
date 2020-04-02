function r = randomIntInRangeExcept(a,b,except,varargin)

% Returns random integers in range [a,b] (inclusive), except for numbers in
% "except"

r = randomIntInRange(a,b-1,varargin{:});
r(r>=except) = r(r>=except)+1;

end