#
# Math implementations for NShape.jl
#

# distance²(Δ)
# distance²(Point, Point)

@inline distance²(Δ::Tuple{Vararg{Number}}) = reduce((i, j) -> i + j^2, Δ; init=zero(eltype(Δ)))
@inline distance²(a::NTuple{D,Number}, b::NTuple{D,Number}) where {D} = reduce((i, j) -> i + j^2, b .- a; init=zero(eltype(a)))
@inline distance²(::Tuple{}) = 0
@inline distance²(::Tuple{}, ::Tuple{}) = 0
const distance_sq = distance²

# distance(Δ)
# distance(Point, Point)

@inline distance(Δ) = √distance²(Δ)
@inline distance(a, b) = √distance²(a, b)

# normalize(Vector)

@inline normalize(v::NTuple{D,Number}) where {D} = v ./ distance(v)
@inline normalize(::Tuple{}) = ()

# iscollinear(Vector, Vector)

iscollinear(a::NTuple{D,Number}, b::NTuple{D,Number}) where {D} = isproportional(a, b)
iscollinear(a::NTuple{2,Number}, b::NTuple{2,Number}) = iszero(det(a, b))
iscollinear(::NTuple{1,Number}, ::NTuple{1,Number}) = true
iscollinear(::Tuple{}, ::Tuple{}) = true

# iscollinear(Point, Point, Point)

iscollinear(a::NTuple{D,Number}, b::NTuple{D,Number}, c::NTuple{D,Number}) where {D} = iscollinear(b .- a, c .- a)
iscollinear(a::NTuple{2,Number}, b::NTuple{2,Number}, c::NTuple{2,Number}) = iszero(det(a, b, c))
iscollinear(::NTuple{1,Number}, ::NTuple{1,Number}, ::NTuple{1,Number}) = true
iscollinear(::Tuple{}, ::Tuple{}, ::Tuple{}) = true

# internal usage

@inline norm(Δ::Tuple{Vararg{Number}}) = reduce((i, j) -> i + abs(j), Δ; init=zero(eltype(Δ)))
@inline norm(a::NTuple{D,Number}, b::NTuple{D,Number}) where {D} = reduce((i, j) -> i + abs(j), b .- a; init=zero(eltype(a)))
@inline norm(::Tuple{}) = 0
@inline norm(::Tuple{}, ::Tuple{}) = 0

@inline lerp(x, y, t) = x + (y - x)t # y*t + x(1-t) # linear interpolation

@inline dot(a::NTuple{D,Number}, b::NTuple{D,Number}) where {D} = sum(ntuple(i -> a[i] * b[i], D)) # dot product
@inline dot(::Tuple{}, ::Tuple{}) = 0

# det for 2D and 3D vectors
@inline det(a::NTuple{2,Number}, b::NTuple{2,Number}) = a[1] * b[2] - a[2] * b[1]
@inline function det(a::NTuple{2,Number}, b::NTuple{2,Number}, c::NTuple{2,Number})
    (a[1] - c[1]) * (b[2] - c[2]) - (a[2] - c[2]) * (b[1] - c[1])
end
@inline function det(a::NTuple{3,Number}, b::NTuple{3,Number}, c::NTuple{3,Number})
    a[1] * (b[2] * c[3] - b[3] * c[2]) -
    a[2] * (b[1] * c[3] - b[3] * c[1]) +
    a[3] * (b[1] * c[2] - b[2] * c[1])
end

# 2D cross product (returns a scalar)
cross(a::NTuple{2,Number}, b::NTuple{2,Number}) = det(a, b)

# 3D cross product (returns a 3D vector)
function cross(a::NTuple{3,Number}, b::NTuple{3,Number})
    (
        a[2] * b[3] - a[3] * b[2],
        a[3] * b[1] - a[1] * b[3],
        a[1] * b[2] - a[2] * b[1]
    )
end

# divide and return 0 instead of Inf
@inline div_no_inf(a, b) = (!isinf(a) && !iszero(b)) * (a / b)

# Check if all elements are proportional
isproportional(a::NTuple{D,Number}, b::NTuple{D,Number}) where {D} = all(i -> a[i] * b[1] == a[1] * b[i], 2:D)
isproportional(::Tuple{Number}, ::Tuple{Number}) = true
isproportional(::Tuple{}, ::Tuple{}) = true
