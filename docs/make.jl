using NShapes
using Documenter

DocMeta.setdocmeta!(NShapes, :DocTestSetup, :(using NShapes); recursive=true)

makedocs(;
    modules=[NShapes],
    authors="Spirit <spirit@programmer.net>",
    sitename="NShapes.jl",
    format=Documenter.HTML(;
        canonical="https://spirit-x64.github.io/NShapes.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/spirit-x64/NShapes.jl",
    devbranch="main",
)
