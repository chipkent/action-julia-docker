using Pkg

repo = ENV["REPO"]
branch = ENV["BRANCH"]
package = last(split(replace(replace(repo,".jl" => ""), ".git" => "")), "/"))

println("REPO: $repo")
println("BRANCH: $branch")
println("PACKAGE: $package")

mkpath("/root/.julia/dev/")
run(`git clone --branch=$branch $repo /root/.julia/dev/$package`)

println("Activating package: $package")
Pkg.activate("/root/.julia/dev/$package")
println("Instantiating package: $package")
Pkg.instantiate()
println("Using package: $package")
@eval using $(Symbol(package))


# Pkg.develop(Pkg.PackageSpec(url=repo, rev=branch))
# Pkg.add(Pkg.PackageSpec(url=repo, rev=branch))

# for package in readdir("/root/.julia/dev/")
#     println("Processing package: $package")
#     Pkg.activate("/root/.julia/dev/$package")
#     Pkg.instantiate()
#     @eval using $(Symbol(package))
# end