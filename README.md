<!-- Markdown link & img dfn's -->
[license]: LICENSE

# NShapes.jl
> Simplify your geometry-related tasks with this versatile Julia package. providing tools for defining shapes of N-dimension and performing essential calculations in real-time.

<div align="center">
  <br />
  <p>
    <a target="_blank" href="https://julialang.org/"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Julia_Programming_Language_Logo.svg/320px-Julia_Programming_Language_Logo.svg.png" alt="Julia Programming Language Logo" /></a>
  </p>
  <p>
    <a target="_blank" href="https://github.com/spirit-x64/NShapes.jl/actions/workflows/CI.yml?query=branch%3Amain"><img src="https://github.com/spirit-x64/NShapes.jl/actions/workflows/CI.yml/badge.svg?branch=main" alt="Build Status" /></a>
    <a target="_blank" href="https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/N/NShapes.html"><img src="https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/N/NShapes.svg" alt="PkgEval" /></a>
    <a target="_blank" href="https://github.com/JuliaTesting/Aqua.jl"><img src="https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg" alt="Aqua" /></a>
  </p>
  <p>
    <a target="_blank" href="https://spirit-x64.github.io/NShapes.jl/stable/"><img src="https://img.shields.io/badge/docs-stable-blue.svg" alt="Stable" /></a>
    <a target="_blank" href="https://spirit-x64.github.io/NShapes.jl/dev/"><img src="https://img.shields.io/badge/docs-dev-blue.svg" alt="Dev" /></a>
  </p>
  <p>
    <a target="_blank" href="https://discord.gg/cST4tkAMy6"><img src="https://img.shields.io/discord/1266889650987860009?color=060033&logo=discord&logoColor=white" alt="Spirit's discord server" /></a>
  </p>
  <p>Geometric calculations and shape drawing in Julia</p>
  <br />
</div>


> [!IMPORTANT]
> This package prioritizes **simplicity**, **ease of use**, and real-time **performance**. There may be a trade-off in terms of precision in certain geometric calculations. For use cases requiring high-precision results (e.g., scientific simulations, engineering), it's recommended to use specialized, precision-focused geometry packages.

## Installation
```julia
using Pkg; Pkg.add(url="https://github.com/spirit-x64/NShapes.jl")
```

## License
All code licensed under the [MIT license][license].

## structs:
```
AbstractTransformation{D}
├── Transformation{D}
├── Translation{D}
├── Rotation{D}
└── Scaling{D}

Linear{D,T}
├── Line{D,T}
├── LineSegment{D,T}
└── Ray{D,T}

Shape{D}
├── PrimitiveShape{D}
│   ├── NSphere{D}
│   └── Polytope{D}
│       ├── ArbitraryPolytope{D} - a raw vertices type for exporting purposes
│       ├── ConvexPolytope{D, S} - S = number of sides
│       └── ConcavePolytope{D, S} - S = number of sides
└── ComplexShape{D}
    ├── BendedShape{D}
    ├── TwistedShape{D}
    ├── AbstractExtrudedShape{D, Linear|Shape}
    │   ├── ExtrudedShape{D, Linear|Shape} - Can represent Cylinder and Prism like shapes
    │   └── TaperExtrudedShape{D, Linear|Shape} - type of ExtrudedShape but for Cone and Pyramid like shapes
    └── CompositeShape{D, Shape, Shape}
        ├── UnionShape{D, Shape, Shape}
        ├── IntersectShape{D, Shape, Shape}
        ├── SubtractShape{D, Shape, Shape}
        └── DifferenceShape{D, Shape, Shape}

Space{D}
├── InfiniteSpace{D}
└── ShapedSpace{D, Linear{D}|Shape{D}}
```

## operations:
```
Boolean
├── union(Shape, Shape) - alias `∪`
├── intersect(Shape, Shape) - alias `∩`
├── subtract(Shape, Shape)
└── difference(Shape, Shape)

Transformations
├── translate(Shape, Translation)
├── rotate(Shape, Rotation)
├── scale(Shape, Scaling)
├── extrude(Shape, Vector, [Taper])
├── bend(Shape, Vector)
├── twist(Shape, Vector)
├── reflect(Shape, Shape)
└── shear(Shape, Shape)

Mesurements
├── volume(Shape)
├── surface(Shape)
├── area(Shape{2})
├── perimeter(Shape{2})
├── distance(Linear) - Euclidean length
├── distance²(Point, Point)
├── distance(Point, Point)
└── normalize(Vector)

Queries
├── iscontaining(Shape, Shape)
├── isintersecting(Shape, Shape)
├── isoverlapping(Shape, Shape)
├── isdistant(Shape, Shape)
├── isdegenerate(Linear|Shape)
├── iscollinear(Linear, Linear)
├── iscollinear(Vector, Vector)
├── iscollinear(Point, Point, Point)
├── isparallel(Linear, Linear)
├── isconvex(Shape)
├── isregular(Shape)
├── isclockwise(Shape{2})
├── closestpoint(Shape, Vector)
├── projection(Shape, Vector)
├── centroid(Shape)
└── normal(Shape)

Bounding volumes
├── convexhull(Shape)
├── boundingbox(Shape)
└── boundingsphere(Shape)

Tessellation and Simplification
├── simplify(Shape, tolerance)
├── decompose(CompositeShape; recursive=false)
├── tessellate(Shape, resolution)
└── voxelize(Shape, resolution) - pixelize(Shape{2}, resolution)

Space
├── ShortestPath(Space, Point, Point)
├── collisions(Space)
├── isvisible(Space, Shape, Point|Linear|Shape)
└── visibilitygraph(Space)
```
