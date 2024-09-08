#
# Math implementations for NShape.jl
#

# distance²(Δ)
# distance²(Point, Point)

@inline distance²(Δ::Tuple{Vararg{T}}) where {T<:Number} = reduce((i, j) -> i + j^2, Δ; init=zero(T))
@inline distance²(a::NTuple{D,T}, b::NTuple{D,T}) where {D,T<:Number} = reduce((i, j) -> i + j^2, b .- a; init=zero(T))
@inline distance²(::Tuple{}) = 0
@inline distance²(::Tuple{}, ::Tuple{}) = 0
const distance_sq = distance²

# distance(Δ)
# distance(Point, Point)

@inline distance(Δ) = √distance²(Δ)
@inline distance(a, b) = √distance²(a, b)

# internal usage

@inline norm(Δ::Tuple{Vararg{T}}) where {T<:Number} = reduce((i, j) -> i + abs(j), Δ; init=zero(T))
@inline norm(a::NTuple{D,T}, b::NTuple{D,T}) where {D,T<:Number} = reduce((i, j) -> i + abs(j), b .- a; init=zero(T))
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
    a[1] * (b[2] * c[3] - b[3] * c[2]) - a[2] * (b[1] * c[3] - b[3] * c[1]) + a[3] * (b[1] * c[2] - b[2] * c[1])
end
