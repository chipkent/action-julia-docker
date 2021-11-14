using Pkg

repo = ENV["REPO"]
branch = ENV["BRANCH"]
println("REPO: $repo")
println("BRANCH: $branch")

Pkg.develop(Pkg.PackageSpec(url=repo, rev=branch))

for package in readdir("/root/.julia/dev/")
    println("Processing package: $package")
    Pkg.activate("/root/.julia/dev/$package")
    Pkg.instantiate()
    @eval using $(Symbol(package))
end