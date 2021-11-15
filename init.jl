using Pkg


org = ENV["ORG"]
project = ENV["PROJECT"]
branch = ENV["BRANCH"]
run_script = ENV["RUN_SCRIPT"]

println("ORG: $org")
println("PROJECT: $project")
println("BRANCH: $branch")
println("RUN_SCRIPT: $run_script")

package = replace(project, ".jl" => "")
println("PACKAGE: $package")

repo="git@github.com:$org/$project.git"
println("REPO: $repo")

println("Git checkout")
mkpath("/root/.julia/dev/")
run(`git clone --branch=$branch $repo /root/.julia/dev/$package`)

println("Creating symlink: ", "/root/.julia/dev/$package/$run_script", "/run.sh")
symlink("/root/.julia/dev/$package/$run_script", "/run.sh")

println("Activating package: $package")
Pkg.activate("/root/.julia/dev/$package")
println("Instantiating package: $package")
Pkg.instantiate()
println("Using package: $package")
@eval using $(Symbol(package))
