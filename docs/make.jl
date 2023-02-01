using DAQFilter
using Documenter

DocMeta.setdocmeta!(DAQFilter, :DocTestSetup, :(using DAQFilter); recursive=true)

makedocs(;
    modules=[DAQFilter],
    authors="Paulo José Saiz Jabardo",
    repo="https://github.com/pjsjipt/DAQFilter.jl/blob/{commit}{path}#{line}",
    sitename="DAQFilter.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
