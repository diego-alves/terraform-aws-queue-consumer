# Nested modules

Nested modules should exist under the `module/` subdirectory. Any nested module with a `README.md` is considered usable by an external user. If a README doesn't exist, it is considered for internal use only. These are purely advisory; Terraform will not actively deny usage of internal modules. Nested modules should be used to split complex behavior into multiple small modules that advanced users can carefully pick and choose.

If the root module includes calls to nested modules, they should use relative paths like `./modules/submodule` so that Terraform will consider them to be part of the same repository or package, rather than downloading them again separately.

If a repository or package contains multiple nested modules, they should ideally be [composable](https://www.terraform.io/docs/language/modules/develop/composition.html) by the caller, rather than calling directly to each other and creating a deeply-nested tree of modules.
