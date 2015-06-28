# Let's say we need to pull out some user info from an
# Omniauth-style hash.

auth = {
  'uid'  => 12345,
  'info' => {
    'email'      => 'avdi@avdi.org'
    'first_name' => 'avdi',
    'last_name'  => 'grimm'
  },
  'credentials' => {
    'token' => "TOKEN123"
  }
}

User = Struct.new(:email_address, :first_name, :last_name, :token)

u = User.new

u.email_address = auth['info']['email']
u.first_name    = auth['info']['first_name']
u.last_name     = auth['info']['last_name']
u.token         = auth['credentials']['token']

# Later on, we use this user info with the assumption that it was all
# collected successfully.

greeting = "Good morning, #{u.first_name.capitalize}"

# Unfortunately, there's no guarantee in the Omniauth hash schema that
# any of these fields will be supplied by a given provider. If we add a
# provider that omits some or all of these fields, we may get a rude
# surprise.

greeting = "Good morning, #{u.first_name.capitalize}"
greeting # =>
# ~> -:4:in `<main>': undefined method `capitalize' for nil:NilClass (NoMethodError)

# The worst thing about this error is that there's no direct connection
# between the error and the missing auth info. The occurrence of the
# error may be widely separated in code and in time from the point where
# the user object was originally populated.

# It would be better to catch the fact that some fields are missing from
# the auth info at the point where the fields are first extracted. The
# presence of these fields is a part of our assumption, and it's always
# a good idea to verify our assumptions about data from external
# sources.

# We might do this by adding statement modifiers to each assignment:

u.email_address = auth['info']['email'] or raise ArgumentError
# ...

# But this is tedious. There's a much more concise and idiomatic way to
# do this, which is to use the =#fetch= method instead of the subscript
# (=[]=) operator.

u.email_address = auth['info'].fetch('email'])
u.first_name    = auth['info'].fetch('first_name')
u.last_name     = auth['info'].fetch('last_name')
u.token         = auth.fetch('credentials').fetch('token')

# Note that we use fetch for the nested "credentials" hash as well,
# because it too is not guaranteed to be present.

# The =#fetch= method on =Hash= behaves similarly to the subscript
# operator except that it is more strict. If the specified key is
# missing, it raises a =KeyError=.

auth = {
  'uid'  => 12345,
  'info' => {
  }
}

# ...

u.email_address = auth['info'].fetch('email')
# ~> -:11:in `fetch': key not found: "email" (KeyError)
# ~>    from -:11:in `<main>'
