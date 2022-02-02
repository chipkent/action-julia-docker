using Pkg


org = ENV["ORG"]
project = ENV["PROJECT"]
branch = ENV["BRANCH"]
entrypoint = ENV["ENTRYPOINT"]

println("ORG: $org")
println("PROJECT: $project")
println("BRANCH: $branch")
println("ENTRYPOINT: $entrypoint")

package = replace(project, ".jl" => "")
println("PACKAGE: $package")

repo="git@github.com:$org/$project.git"
println("REPO: $repo")

println("Setup TimeZones")
Pkg.add("TimeZones")
Pkg.build("TimeZones")

println("Git checkout")
mkpath("/root/.julia/dev/")
run(`git clone --branch=$branch $repo /root/.julia/dev/$package`)

println("Creating symlink: ", "/root/.julia/dev/$package/$entrypoint", "/run.sh")
symlink("/root/.julia/dev/$package/$entrypoint", "/run.sh")

println("Activating package: $package")
Pkg.activate("/root/.julia/dev/$package")
println("Instantiating package: $package")
Pkg.instantiate()
println("Using package: $package")
@eval using $(Symbol(package))
