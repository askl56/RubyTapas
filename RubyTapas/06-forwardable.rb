# One of the most important concepts in object-oriented programming is
# /composition/. Composition enables an object's behavior to be
# implemented in terms of other collaborator objects.

# For instance, here's a User class. In order to work with multiple
# sources of user authentication info, it delegates certain fields, like
# first_name, last_name, and email_address, to an "account"
# collaborator.

# #+name: user1

class User

  attr_reader :account

  def initialize(account)
    @account = account
  end

  def first_name
    account.first_name
  end

  def last_name
    account.last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def email_address
    account.email_address
  end
end

# The account may be any of several different account types. For
# instance, a Github account, or a Facebook account. For these examples
# I'm just using simple structs, but in a real app these might have
# substantially different implementations from each other.

# #+name: accounts

GithubAccount = Struct.new(:uid, :email_address, :first_name, :last_name)
FacebookAccount = Struct.new(:login, :email_address, :first_name, :last_name)

# When we instantiate a user account, we pass an instance of an account
# object, and the user's methods use that account object internally. We
# can say that the user is /composed of/ an account plus it's own added
# behavior.

avdi = User.new(GithubAccount.new("avdi", "avdi@avdi.org", "Avdi", "Grimm"))
avdi.full_name # => "Avdi Grimm"

# That definition of =User= is awfully verbose, though, as well as
# repetitive. Most of the methods are simply delegating directly to an
# identically-named method on the =account= attribute.

# The Ruby standard library gives us a tool to clean up this
# repetition. It's called "forwardable".

# To use it, We require the 'forwardable' library, and extend the =User=
# class with the =Forwardable= module. Take note that we use =extend=
# here, not =include=. Then, we can use the new =def_delegators= class
# method to declare which methods are delegated to the =account=.

require 'forwardable'

class User

  attr_reader :account

  extend Forwardable

  def_delegators :account, :first_name, :last_name, :email_address

  def initialize(account)
    @account = account
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

# This substantially trims down the class. It also ensures that if we
# ever change the name of the =account= attribute, we won't have to
# update it in so many places.

# Now, what if we didn't want to expose =account= as a readable
# attribute? What if we wanted to keep it as a private instance variable
# only? That's fine; we need only update the =def_delegators=
# declaration to use the name of the instance variable, including the
# '=@=' sign.

require 'forwardable'

class User

  extend Forwardable

  def_delegators :@account, :first_name, :last_name, :email_address

  # ...
end

# In fact, the target of delegation can be anything which can be
# converted to a string and evaluated as code. So we can easily delegate
# to objects at a two-step remove from self. For instance, here's a
# somewhat contrived example of a =Store= class which delegates the
# =owner_email= attribute to account attribute of the store's =owner=.

class Store
  extend Forwardable

  def_delegator '@owner.account', :email_address, :owner_email

  def initialize(owner)
    @owner = owner
  end
end

avdi = User.new(GithubAccount.new("avdi", "avdi@avdi.org", "Avdi", "Grimm"))
store = Store.new(avdi)
store.owner_email               # => "avdi@avdi.org"

# This demonstrates three new concepts:

# 1. Using an evaluatable string as the target of the delegation.
# 2. The singular form =def_delegator= instead of =def_delegators=
# 3. The use of the "alias" argument, which is only available in the
#    singular =def_delegator= method. Here, we alias the delegated
#    method to the name =owner_email=, instead of simply
#    =email_address=.

# Of course, like I said this is pretty contrived. We've already
# provided direct access to the user account email address, so we don't
# actually need the two-step delegation here. We could just as well
# delegate =email_address= to the =owner= object and let it worry about
# where it gets an email address from.

class Store
  extend Forwardable

  def_delegator '@owner', :email_address, :owner_email

  def initialize(owner)
    @owner = owner
  end
end
