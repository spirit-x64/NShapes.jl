#
# Linear{D,T}
# ├── Line{D,T}
# ├── LineSegment{D,T}
# └── Ray{D,T}
#

abstract type Linear{D,T<:Number} end

struct Line{D,T<:Number} <: Linear{D,T}
    point1::NTuple{D,T}
    point2::NTuple{D,T}
end
Line(::Tuple{}, ::Tuple{}) = Line{0,Union{}}((), ())
function Line(p1::NTuple{D,Number}, p2::NTuple{D,Number}) where {D}
    T = promote_type(eltype(p1), eltype(p2))
    Line{D,T}(convert(NTuple{D,T}, p1), convert(NTuple{D,T}, p2))
end

struct LineSegment{D,T<:Number} <: Linear{D,T}
    point1::NTuple{D,T}
    point2::NTuple{D,T}
end
LineSegment(::Tuple{}, ::Tuple{}) = LineSegment{0,Union{}}((), ())
function LineSegment(p1::NTuple{D,Number}, p2::NTuple{D,Number}) where {D}
    T = promote_type(eltype(p1), eltype(p2))
    LineSegment{D,T}(convert(NTuple{D,T}, p1), convert(NTuple{D,T}, p2))
end

struct Ray{D,T<:Number} <: Linear{D,T}
    point1::NTuple{D,T}
    point2::NTuple{D,T}
end
Ray(::Tuple{}, ::Tuple{}) = Ray{0,Union{}}((), ())
function Ray(p1::NTuple{D,Number}, p2::NTuple{D,Number}) where {D}
    T = promote_type(eltype(p1), eltype(p2))
    Ray{D,T}(convert(NTuple{D,T}, p1), convert(NTuple{D,T}, p2))
end

# overloads

Base.show(io::IO, l::Line) = print(io, "<$(l.point1)↔$(l.point2)>")
Base.show(io::IO, l::LineSegment) = print(io, "<$(l.point1)―$(l.point2)>")
Base.show(io::IO, l::Ray) = print(io, "<$(l.point1)→$(l.point2)>")

Base.getindex(l::Linear, i::Int) = getfield(l, i)
Base.length(::Linear) = 2

Base.iterate(l::Linear, i=1) = i > 2 ? nothing : (getfield(l, i), i + 1)
Base.lastindex(::Linear) = 2
Base.last(l::Linear) = l.point2

Base.convert(::Type{Line}, l::Linear) = Line(l.point1, l.point2)
Base.convert(::Type{Line{D,T}}, l::Linear{D}) where {D,T<:Number} = Line{D,T}(l.point1, l.point2)
Base.convert(::Type{Line{D,T}}, l::Line{D,T}) where {D,T<:Number} = l
Base.convert(::Type{LineSegment}, l::Linear) = LineSegment(l.point1, l.point2)
Base.convert(::Type{LineSegment{D,T}}, l::Linear{D}) where {D,T<:Number} = LineSegment{D,T}(l.point1, l.point2)
Base.convert(::Type{LineSegment{D,T}}, l::LineSegment{D,T}) where {D,T<:Number} = l
Base.convert(::Type{Ray}, l::Linear) = Ray(l.point1, l.point2)
Base.convert(::Type{Ray{D,T}}, l::Linear{D}) where {D,T<:Number} = Ray{D,T}(l.point1, l.point2)
Base.convert(::Type{Ray{D,T}}, l::Ray{D,T}) where {D,T<:Number} = l

function Base.in(point::NTuple{D,Number}, l::Line{D}) where {D}
    v = l.point2 .- l.point1
    t = div_no_inf(dot(point .- l.point1, v), dot(v, v))
    lerp.(l.point1, l.point2, t) == point
end
Base.in(point::NTuple{3,Number}, l::Line{3}) = all(iszero, cross(point .- l.point1, l.point2 .- l.point1))
Base.in(point::NTuple{2,Number}, l::Line{2}) = iszero(det(l.point1, point, l.point2))
Base.in(::Tuple{Number}, ::Line{1}) = true
Base.in(::Tuple{}, ::Line{0}) = true
function Base.in(point::NTuple{D,Number}, s::LineSegment{D}) where {D}
    v = s.point2 .- s.point1
    t = div_no_inf(dot(point .- s.point1, v), dot(v, v))
    0 <= t <= 1 && lerp.(s.point1, s.point2, t) == point
end
Base.in(point::NTuple{1,Number}, l::LineSegment{1}) = l.point1[1] <= point[1] <= l.point2[1]
Base.in(::Tuple{}, ::LineSegment{0}) = true
function Base.in(point::NTuple{D,Number}, r::Ray{D}) where {D}
    v = r.point2 .- r.point1
    t = div_no_inf(dot(point .- r.point1, v), dot(v, v))
    t >= 0 && lerp.(r.point1, r.point2, t) == point
end
Base.in(point::NTuple{1,Number}, l::Ray{1}) = l.point1[1] <= point[1]
Base.in(::Tuple{}, ::Ray{0}) = true

Base.:(==)(::Linear, ::Linear) = false # diff types of Linear or diff dimensions are never equal
Base.:(==)(a::Line{D}, b::Line{D}) where {D} = iscollinear(a, b) # Two lines are equal if they collinear
function Base.:(==)(a::LineSegment{D}, b::LineSegment{D}) where {D}
    (a.point1 == b.point1 && a.point2 == b.point2) || (a.point1 == b.point2 && a.point2 == b.point1)
end # Two segments are equal if they share the same endpoints
function Base.:(==)(a::Ray{D}, b::Ray{D}) where {D}
    a.point1 == b.point1 && iscollinear(a, b)
end # Two rays are equal if the share the same origin (point1) and the same direction

# distance(Linear)

distance(::Line) = Inf
distance(l::LineSegment) = distance(l.point1, l.point2)
distance(::Ray) = Inf

# isparallel(Linear, Linear)

isparallel(a::Linear{D}, b::Linear{D}) where {D} = iscollinear(a.point2 .- a.point1, b.point2 .- b.point1)
isparallel(::Linear{1}, ::Linear{1}) = true
isparallel(::Linear{0}, ::Linear{0}) = true

# iscollinear(Linear, Linear)

iscollinear(a::Linear{D}, b::Linear{D}) where {D} = iscollinear(a[1], a[2], b[1]) && iscollinear(a[2], b[1], b[2])
iscollinear(::Linear{1}, ::Linear{1}) = true
iscollinear(::Linear{0}, ::Linear{0}) = true
