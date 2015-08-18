class Greeter
  def hello
    puts "hello, world"
  end
end

greeter = Greeter.new
m = greeter.method(:hello) #  => #<Method: Greeter#hello>

m.call
# >> hello, world

class TeaClock
  attr_accessor :timer
  attr_accessor :ui

  def initialize(minutes)
    self.ui - StdioUi.new
    self.timer = SleepTimer.new(minutes, ui)
    init_plugins
  end

  def init_plugins
    @plugins = []
    ::Plugins.constants.each do |name|
      @plugins << ::Plugins.const_get(name).new(self)
    end
  end

  def start
    timer.start
  end
end

SleepTimer = Struct.new(:minutes, :notifier) do
  def start
    sleep minutes * 60
    notifier.notify("Tea is ready!")
  end
end

class StdioUi
  def notify(text)
    puts text
  end
end

module Plugins
  class Beep
    def initialize(tea_clock)
      tea_clock.ui.extend(UiWithBeep)
    end

    module UiWithBeep
      def notify(*)
        puts "BEEP!"
        super
      end
    end
  end
end

t = TeaClock.new(0.01).start
# >>
