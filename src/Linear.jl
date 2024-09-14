#
# Linear{D,T}
# ├── Line{D,T}
# ├── LineSegment{D,T}
# └── Ray{D,T}
#

abstract type Linear{D,T<:Number} end

struct Line{D,T<:Number} <: Linear{D,T}
    origin::NTuple{D,T}
    vector::NTuple{D,T}
end
Line(::Tuple{}, ::Tuple{}) = Line{0,Union{}}((), ())
function Line(o::NTuple{D,Number}, v::NTuple{D,Number}) where {D}
    T = promote_type(eltype(o), eltype(v))
    Line{D,T}(convert(NTuple{D,T}, o), convert(NTuple{D,T}, v))
end

struct LineSegment{D,T<:Number} <: Linear{D,T}
    origin::NTuple{D,T}
    vector::NTuple{D,T}
end
LineSegment(::Tuple{}, ::Tuple{}) = LineSegment{0,Union{}}((), ())
function LineSegment(o::NTuple{D,Number}, v::NTuple{D,Number}) where {D}
    T = promote_type(eltype(o), eltype(v))
    LineSegment{D,T}(convert(NTuple{D,T}, o), convert(NTuple{D,T}, v))
end

struct Ray{D,T<:Number} <: Linear{D,T}
    origin::NTuple{D,T}
    vector::NTuple{D,T}
end
Ray(::Tuple{}, ::Tuple{}) = Ray{0,Union{}}((), ())
function Ray(o::NTuple{D,Number}, v::NTuple{D,Number}) where {D}
    T = promote_type(eltype(o), eltype(v))
    Ray{D,T}(convert(NTuple{D,T}, o), convert(NTuple{D,T}, v))
end

# overloads

Base.show(io::IO, l::Line) = print(io, "<$(l.origin)↔$(l.vector)>")
Base.show(io::IO, l::LineSegment) = print(io, "<$(l.origin)―$(l.vector)>")
Base.show(io::IO, l::Ray) = print(io, "<$(l.origin)→$(l.vector)>")

Base.getindex(l::Linear, i::Int) = getfield(l, i)
Base.length(::Linear) = 2

Base.iterate(l::Linear, i=1) = i > 2 ? nothing : (getfield(l, i), i + 1)

Base.convert(::Type{Line}, l::Linear) = Line(l.origin, l.vector)
Base.convert(::Type{Line{D,T}}, l::Linear{D}) where {D,T<:Number} = Line{D,T}(l.origin, l.vector)
Base.convert(::Type{Line{D,T}}, l::Line{D,T}) where {D,T<:Number} = l
Base.convert(::Type{LineSegment}, l::Linear) = LineSegment(l.origin, l.vector)
Base.convert(::Type{LineSegment{D,T}}, l::Linear{D}) where {D,T<:Number} = LineSegment{D,T}(l.origin, l.vector)
Base.convert(::Type{LineSegment{D,T}}, l::LineSegment{D,T}) where {D,T<:Number} = l
Base.convert(::Type{Ray}, l::Linear) = Ray(l.origin, l.vector)
Base.convert(::Type{Ray{D,T}}, l::Linear{D}) where {D,T<:Number} = Ray{D,T}(l.origin, l.vector)
Base.convert(::Type{Ray{D,T}}, l::Ray{D,T}) where {D,T<:Number} = l
