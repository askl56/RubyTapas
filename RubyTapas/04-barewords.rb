# Today we've been tasked with writing the software for a new generation
# of intelligent personal disorganizers for the elite citizens of the
# city of [[http://wiki.lspace.org/wiki/Ankh-Morpork][Ankh-Morpork]]. Previous iterations of the device contained a
# tiny, mathematically-inclined imp. But they proved unreliable, and in
# this generation the Imp will be simulated in software instead.

# Here's a rough draft of some code for greeting the user of the device.

salutation  = "Most agreeable to see you"
title       = "Commander"
full_name   = "Sam Vimes"
progname    = "Dis-organizer"
version     = "Mark 7"
designation = "Seeree"
service_inquiry = "order you a coffee"

puts "#{salutation}, #{title} #{full_name}. ",
     "Welcome to #{progname} version #{version}. ",
     "My name is #{designation}.",
     "May I #{service_inquiry}?"


# We start out by pulling this code into a method in a class. We make
# the =title= and =full_name= values arguments to the method, but the
# actual code for outputting the greeting remains unchanged.

class ObsequiousImp
  def greet(title, full_name)
    salutation  = "Most agreeable to see you"
    progname    = "Dis-organizer"
    version     = "Mark 7"
    designation = "Seeree"
    service_inquiry = "order you a coffee"

    puts "#{salutation}, #{title} #{full_name}. ",
      "Welcome to #{progname} version #{version}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new.greet "Commander", "Sam Vimes"


# According to the design the Architecture Wizards have handed down to
# us, there will be multiple kinds of Imp. Different kinds of Imp will
# greet their masters differently. Since this particular salutation is
# specific to this class of imp, we make it a class-level constant. This
# necessitates modifying the greeting code to reference the constant
# instead of a local variable.

class ObsequiousImp
  SALUTATION = "Most agreeable to see you"

  def greet(title, full_name)
    progname    = "Dis-organizer"
    version     = "Mark 7"
    designation = "Seeree"
    service_inquiry = "order you a coffee"

    puts "#{SALUTATION}, #{title} #{full_name}. ",
      "Welcome to #{progname} version #{version}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new.greet "Commander", "Sam Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?


# After presenting our class to the diamond troll responsible for tying
# our code into the user interface, we've discovered a problem: the name
# of the user will actually be coming to us as separate first name and
# last name values. So we change the method's arguments accordingly, and
# update the greeting code.

class ObsequiousImp
  SALUTATION = "Most agreeable to see you"

  def greet(title, first_name, last_name)
    progname    = "Dis-organizer"
    version     = "Mark 7"
    designation = "Seeree"
    service_inquiry = "order you a coffee"

    puts "#{SALUTATION}, #{title} #{first_name} #{last_name}. ",
      "Welcome to #{progname} version #{version}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new.greet "Commander", "Sam", "Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?


# The software's name should really be a global value. In fact, for
# some reason the architects have mandated that it be a truly global
# value, outside of any kind of namespacing. We grumble a bit but do as
# we're told, and update the greeting code to reference a global instead
# of a local variable. The program version, on the other hand, doesn't have
# the same constraints on it, so we make it a constant in a module that
# represents the program as a whole. Again, we update the greeting code
# to reference this namespaced constant.

$progname = "Dis-organizer"

module DisOrganizer
  VERSION = "Mark 7"
end

class ObsequiousImp
  SALUTATION = "Most agreeable to see you"

  def greet(title, first_name, last_name)
    designation = "Seeree"
    service_inquiry = "order you a coffee"

    puts "#{SALUTATION}, #{title} #{first_name} #{last_name}. ",
      "Welcome to #{$progname} version #{DisOrganizer::VERSION}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new.greet "Commander", "Sam", "Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?


# Each user can name their own imp. To make this possible, we make the
# imp's designation an instance variable. And we update the greeting code
# with an '@' in front of the variable name.

$progname = "Dis-organizer"

module DisOrganizer
  VERSION = "Mark 7"
end

class ObsequiousImp
  SALUTATION = "Most agreeable to see you"

  def initialize(designation)
    @designation = designation
  end

  def greet(title, first_name, last_name)
    service_inquiry = "order you a coffee"

    puts "#{SALUTATION}, #{title} #{first_name} #{last_name}. ",
      "Welcome to #{$progname} version #{DisOrganizer::VERSION}. ",
      "My name is #{@designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new("Seeree").greet "Commander", "Sam", "Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?


# Finally, Imps may be configured with different special features. The question
# at the end of the greeting should depend on the enabled feature. We
# add a =special_feature= attribute to the class, and update the
# greeting code to send a message to the object it points to.

$progname = "Dis-organizer"

module DisOrganizer
  VERSION = "Mark 7"
end

class CoffeeEnabled
  def service_inquiry
    "order you a coffee"
  end
end

class ObsequiousImp
  SALUTATION = "Most agreeable to see you"

  attr_accessor :special_feature

  def initialize(designation)
    @designation = designation
  end

  def greet(title, first_name, last_name)
    puts "#{SALUTATION}, #{title} #{first_name} #{last_name}. ",
      "Welcome to #{$progname} version #{DisOrganizer::VERSION}. ",
      "My name is #{@designation}.",
      "May I #{special_feature.service_inquiry}?"
  end
end

imp = ObsequiousImp.new("Seeree")
imp.special_feature = CoffeeEnabled.new
imp.greet "Commander", "Sam", "Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?


# This is, obviously, a highly contrived example. But bear with me,
# because I'm trying to make a point about values at different scopes.

# We started with a set of named values which were all local
# variables. Step by step, we moved them to different scopes.

# - The title remained a method argument.
# - The full name was broken out into two arguments.
# - The imp's designation became a property of a single instance.
# - The special feature became a member of a composited object.
# - The salutation became a property of the class.
# - The program version became a constant in a program-wide module namespace.
# - The program name became a global.

# At every step, not only did we change the scope of the named value, we
# also changed the greeting code. Even though the actual logic of the
# greeting code never changed. That means that with each refactoring, we
# had an extra opportunity to introduce a defect by mis-typing the
# change to the greeting code, referencing the wrong variable, or (most
# likely) simply forgetting to update the variable reference.

# Let's go through this process again. But this time, let's see if we
# can do it in a way that has less impact on the core greeting code.

class ObsequiousImp
  def greet(title, full_name)
    salutation  = "Most agreeable to see you"
    progname    = "Dis-organizer"
    version     = "Mark 7"
    designation = "Seeree"
    service_inquiry = "order you a coffee"

    puts "#{salutation}, #{title} #{full_name}. ",
      "Welcome to #{progname} version #{version}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new.greet "Commander", "Sam Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?


# To make the salutation a class-level property, we make it a
# method. The greeting code is unchanged.

class ObsequiousImp
  def salutation
    "Most agreeable to see you"
  end

  def greet(title, full_name)
    progname    = "Dis-organizer"
    version     = "Mark 7"
    designation = "Seeree"
    service_inquiry = "order you a coffee"

    puts "#{salutation}, #{title} #{full_name}. ",
      "Welcome to #{progname} version #{version}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new.greet "Commander", "Sam Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?


# We update the method signature to accept a first name and last name,
# and add a local variable which combines the two into a full name. The
# greeting code remains unchanged.

class ObsequiousImp
  def salutation
    "Most agreeable to see you"
  end

  def greet(title, first_name, last_name)
    full_name   = "#{first_name} #{last_name}"
    progname    = "Dis-organizer"
    version     = "Mark 7"
    designation = "Seeree"
    service_inquiry = "order you a coffee"

    puts "#{salutation}, #{title} #{full_name}. ",
      "Welcome to #{progname} version #{version}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new.greet "Commander", "Sam", "Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?

# We make the program name global by defining it as a method on the
# top-level "main" object. Because of the semi-magical properties of the
# main object, this causes the method to become available as a private
# methods on *all* objects.


# We declare the program's version as an instance method in the
# =DisOrganizer= module, and we include that module into our imp
# class. As a result, we're able to reference the =#version= method
# directly. The greeting code is still unchanged.

def progname; "Dis-organizer"; end

module DisOrganizer
  def version; "Mark 7"; end
end

class ObsequiousImp
  include DisOrganizer

  def salutation
    "Most agreeable to see you"
  end

  def greet(title, first_name, last_name)
    full_name   = "#{first_name} #{last_name}"
    designation = "Seeree"
    service_inquiry = "order you a coffee"

    puts "#{salutation}, #{title} #{full_name}. ",
      "Welcome to #{progname} version #{version}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new.greet "Commander", "Sam", "Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?


# For the designation, we add an =attr_reader= along with the
# initializer parameter. The greeting code which once referenced a local
# variable, now references an instance method, and remains
# unchanged. You may sense a trend by now.

def progname; "Dis-organizer"; end

module DisOrganizer
  def version; "Mark 7"; end
end

class ObsequiousImp
  include DisOrganizer

  attr_reader :designation

  def initialize(designation)
    @designation = designation
  end

  def salutation
    "Most agreeable to see you"
  end

  def greet(title, first_name, last_name)
    full_name   = "#{first_name} #{last_name}"
    service_inquiry = "order you a coffee"

    puts "#{salutation}, #{title} #{full_name}. ",
      "Welcome to #{progname} version #{version}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

ObsequiousImp.new("Seeree").greet "Commander", "Sam", "Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?

# Finally, we once again add the =special_feature= collaborator to our
# class. This time, we also define a =#service_inquiry= method which
# delegates the =#service_inquiry= method to this special feature
# collaborator. The greeting code, as before, remains unchanged.

def progname; "Dis-organizer"; end

module DisOrganizer
  def version; "Mark 7"; end
end

class CoffeeEnabled
  def service_inquiry
    "order you a coffee"
  end
end

class ObsequiousImp
  include DisOrganizer
  attr_reader :designation
  attr_accessor :special_feature

  def initialize(designation)
    @designation = designation
  end

  def salutation
    "Most agreeable to see you"
  end

  def service_inquiry
    special_feature.service_inquiry
  end

  def greet(title, first_name, last_name)
    full_name   = "#{first_name} #{last_name}"

    puts "#{salutation}, #{title} #{full_name}. ",
      "Welcome to #{progname} version #{version}. ",
      "My name is #{designation}.",
      "May I #{service_inquiry}?"
  end
end

imp = ObsequiousImp.new("Seeree")
imp.special_feature = CoffeeEnabled.new
imp.greet "Commander", "Sam", "Vimes"
# >> Most agreeable to see you, Commander Sam Vimes.
# >> Welcome to Dis-organizer version Mark 7.
# >> My name is Seeree.
# >> May I order you a coffee?
