# GitHub Actions Workflows

## test-languages.yml

This workflow automatically tests all 19 language implementations in the repository to ensure they can be built/compiled without errors.

### Trigger Events

- Push to `main` or `master` branches
- Pull requests to `main` or `master` branches

### Test Jobs

The workflow includes 19 separate jobs, one for each programming language:

#### Compiled Languages (Build Tests)
- **Rust** - Builds with `cargo build --release`
- **Go** - Builds with `go build`
- **C** - Compiles with gcc and libmicrohttpd
- **C++** - Compiles with g++ and Crow framework
- **Crystal** - Builds with `crystal build --release`
- **Zig** - Builds with `zig build-exe`
- **Nim** - Builds with `nim c -d:release`
- **V** - Builds with `v -prod`
- **Fortran** - Compiles with gfortran
- **Ada** - Compiles with gnatmake and AWS libraries

#### JVM Languages (Build Tests)
- **Java** - Builds with Maven
- **Kotlin** - Builds with Gradle

#### .NET Languages (Build Tests)
- **C#** - Builds with `dotnet build`

#### Interpreted Languages (Syntax/Lint Tests)
- **Python** - Syntax check with `python -m py_compile` and basic linting
- **JavaScript** - Syntax check with `node --check`
- **TypeScript** - Compiles with `tsc`
- **Ruby** - Syntax check with `ruby -c`
- **PHP** - Syntax check with `php -l`

#### Assembly (Basic Validation)
- **Assembly** - Validates file exists and attempts NASM compilation

### Purpose

This CI/CD pipeline ensures that:
1. All code changes maintain syntactic correctness
2. Compilation errors are caught early
3. Each language implementation can be successfully built
4. Contributors receive immediate feedback on code quality

### Adding New Languages

When adding a new language implementation:

1. Create a new directory with the language name
2. Add source code and Dockerfile
3. Add a new job to `test-languages.yml` following the pattern of existing jobs
4. Ensure the job includes appropriate setup actions and build/test commands
