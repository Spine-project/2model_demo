using Pkg

# Activate environment at current directory
Pkg.activate(dirname(@__FILE__))

# Download and install all required packages
Pkg.instantiate()

# Set Python executable to current and re-build PyCall if necessary
ENV["PYTHON"] = Sys.which("python")
try
    Pkg.build("PyCall")
catch e
    if !isa(e, Pkg.Types.PkgError)
        throw(e)
    end
end

# Precompile everything
Pkg.API.precompile()
