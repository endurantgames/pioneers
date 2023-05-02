package = "pioneers"
version = "dev-1"
source = {
   url = "git+https://github.com/endurantgames/pioneers.git"
}
description = {
   homepage = "https://github.com/endurantgames/pioneers",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {},
   copy_directories = {
      "docs"
   },
   install = {
      bin = {
         "bin/make-markdown.lua"
      }
   }
}
