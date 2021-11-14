using Pkg


org = ENV["ORG"]
project = ENV["PROJECT"]
branch = ENV["BRANCH"]
run_script = ENV["RUN_SCRIPT"]

println("ORG: $org")
println("PROJECT: $project")
println("BRANCH: $branch")
println("RUN_SCRIPT: $run_script")

package = replace(repo, ".jl" => "")
println("PACKAGE: $package")

repo="git@github.com:$org/$project.git"
println("REPO: $repo")

mkpath("/root/.julia/dev/")
run(`git clone --branch=$branch $repo /root/.julia/dev/$package`)

println("Activating package: $package")
Pkg.activate("/root/.julia/dev/$package")
println("Instantiating package: $package")
Pkg.instantiate()
println("Using package: $package")
@eval using $(Symbol(package))

symlink("/root/.julia/dev/$package/$run_script", "/run.sh")