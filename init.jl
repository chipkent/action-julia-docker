using Pkg

org = ENV["ORG"]
project = ENV["PROJECT"]
branch = ENV["BRANCH"]

println("REPO: $repo")
println("BRANCH: $branch")
println("ORG: $org")

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

