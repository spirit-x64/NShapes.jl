#
# Linear{D,T}
# ├── Line{D,T}
# ├── LineSegment{D,T}
# └── Ray{D,T}
#

abstract type Linear{D,T<:Number} end

struct Line{D,T<:Number} <: Linear{D,T}
    first_point::NTuple{D,T}
    last_point::NTuple{D,T}
end
Line(::Tuple{}, ::Tuple{}) = Line{0,Union{}}((), ())
function Line(p1::NTuple{D,Number}, p2::NTuple{D,Number}) where {D}
    T = promote_type(eltype(p1), eltype(p2))
    Line{D,T}(convert(NTuple{D,T}, p1), convert(NTuple{D,T}, p2))
end

struct LineSegment{D,T<:Number} <: Linear{D,T}
    first_point::NTuple{D,T}
    last_point::NTuple{D,T}
end
LineSegment(::Tuple{}, ::Tuple{}) = LineSegment{0,Union{}}((), ())
function LineSegment(o::NTuple{D,Number}, v::NTuple{D,Number}) where {D}
    T = promote_type(eltype(o), eltype(v))
    LineSegment{D,T}(convert(NTuple{D,T}, o), convert(NTuple{D,T}, v))
end

struct Ray{D,T<:Number} <: Linear{D,T}
    first_point::NTuple{D,T}
    last_point::NTuple{D,T}
end
Ray(::Tuple{}, ::Tuple{}) = Ray{0,Union{}}((), ())
function Ray(p1::NTuple{D,Number}, p2::NTuple{D,Number}) where {D}
    T = promote_type(eltype(p1), eltype(p2))
    Ray{D,T}(convert(NTuple{D,T}, p1), convert(NTuple{D,T}, p2))
end

# overloads

Base.show(io::IO, l::Line) = print(io, "<$(l.first_point)↔$(l.last_point)>")
Base.show(io::IO, l::LineSegment) = print(io, "<$(l.first_point)―$(l.last_point)>")
Base.show(io::IO, l::Ray) = print(io, "<$(l.first_point)→$(l.last_point)>")

Base.getindex(l::Linear, i::Int) = getfield(l, i)
Base.length(::Linear) = 2

Base.iterate(l::Linear, i=1) = i > 2 ? nothing : (getfield(l, i), i + 1)
Base.lastindex(::Linear) = 2
Base.last(l::Linear) = l.last_point

Base.convert(::Type{Line}, l::Linear) = Line(l.first_point, l.last_point)
Base.convert(::Type{Line{D,T}}, l::Linear{D}) where {D,T<:Number} = Line{D,T}(l.first_point, l.last_point)
Base.convert(::Type{Line{D,T}}, l::Line{D,T}) where {D,T<:Number} = l
Base.convert(::Type{LineSegment}, l::Linear) = LineSegment(l.first_point, l.last_point)
Base.convert(::Type{LineSegment{D,T}}, l::Linear{D}) where {D,T<:Number} = LineSegment{D,T}(l.first_point, l.last_point)
Base.convert(::Type{LineSegment{D,T}}, l::LineSegment{D,T}) where {D,T<:Number} = l
Base.convert(::Type{Ray}, l::Linear) = Ray(l.first_point, l.last_point)
Base.convert(::Type{Ray{D,T}}, l::Linear{D}) where {D,T<:Number} = Ray{D,T}(l.first_point, l.last_point)
Base.convert(::Type{Ray{D,T}}, l::Ray{D,T}) where {D,T<:Number} = l
