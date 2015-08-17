# It's common to want to find the current user's home directory, for
# instance to read or write a config file.

# Since Ruby version 1.9.2, this has become particularly easy. You can
# just use the =Dir.home= method.

config_file = File.join(Dir.home, ".rubytapas")

# So you might think is going to be an extra short episode! But there's
# a small complication.

# =Dir.home= depends on the =$HOME= environment variable being set. We
# can demonstrate this fact by removing the =$HOME= variable and trying
# to use =Dir.home=:

ENV.delete('HOME')
config_file = File.join(Dir.home, ".rubytapas")
# ~> -:2:in `home': couldn't find HOME environment -- expanding `~' (ArgumentError)
# ~>    from -:2:in `<main>'

# Actually, that's not completely true. =Dir.home= doesn't need the
# =$HOME= environment variable to be set if you pass it an explicit
# username.

ENV.delete('HOME')
config_file = File.join(Dir.home("avdi"), ".rubytapas")
# => "/home/avdi/.rubytapas"

# So now the question becomes: how do we get a hold of the current user's
# login? We might look at the =$USER= variable, but in a situation where
# the =$HOME= variable isn't set, I wouldn't rely on the =$USER= variable
# being available either.

# Of course, the operating system knows who the current user is. Can't
# we ask it? As a matter of fact we can. To do so, we use the =etc=
# standard library. =etc= provides a module called (surprise) =Etc=,
# which exposes a method called =#getlogin= which returns the login of
# the current user.

require 'etc'

user = Etc.getlogin
config_file = File.join(Dir.home(user), ".rubytapas")

