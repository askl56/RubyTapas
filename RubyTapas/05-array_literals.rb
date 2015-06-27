# Most of the Ruby methods for spawning external processes accept the
# command to execute in one of two different forms. Either you can pass
# a string:

system "ln -s file1 file2"

# Or you can pass a list of strings, each one of which will become a
# sequential element in the new process' ARGV array.

system "ln", "-s", "file1", "file2"

# There are a few reasons to prefer this latter form. First, it forces
# Ruby to run the command directly. With a single string command, in
# Ruby will pass the command to the shell to be interpreted. This adds
# overhead, may behave differently depending on the system's default
# shell, and at worst, can open a program up to shell-injection
# attacks. When a command is passed as a list of strings, Ruby passes it
# directly to the operating system to be executed.

# Another advantage of using the list form is that it makes it easier to
# build up commands incrementally. Let's say we wanted to build up that
# last example from component parts. We have the command, the flags,
# and the arguments. Then we concatenate them together to form the full
# command line.

command = "ln"
options = "-s"
arguments = "file1 file2"

system command + options + arguments

# Can you see the problem here? We've left out spaces in between some of
# the arguments!

command = "ln"
options = "-s"
arguments = "file1 file2"

command + options + arguments   # => "ln-sfile1 file2"

# If we build the command up using arrays, we don't have to think about
# ensuring there are spaces between the different components. We can
# build our command up with array concatenation, then use the splat
# operator to convert the array to method parameters.

command = ["ln"]
options = ["-s"]
arguments = ["file1", "file2"]

system *(command + options + arguments)

# However, this is a little more verbose than the string version. And
# that's where one of my favorite literal syntaxes comes in: =%W=
# quoting.

# With =%W=, we precede an array with =%W=, and then surround it with
# any delimiters we choose. Inside, we put the elements of the
# array. Each whitespace-delimited token becomes a string array
# element. I'll stick with using square brackets (=[]=) for
# delimiters for these examples.

%W[file1 file2]       # => ["file1", "file2"]

# Here's a simplified example from the script I use to record
# screencasts. I build up the final command from various subsets of
# flags and arguments.

recording_options = %W[-f x11grab -s 960x600 -i 0:0+800,300 -r 30]
misc_options      = %W[-sameq -threads 6]
output_options    = %W[screencast.mp4]

ffmpeg_flags =
    recording_options +
    misc_options +
    output_options

system "ffmpeg", *ffmpeg_flags

# All the values here are hardcoded. But what if I wanted to make parts
# of the command variable? For instance, what if I wanted to be able to
# change the width and height of the recording window? That's where the
# real beauty of =%W= quoting shines. Unlike the =%w= form, =%W= enables
# interpolation, just like in double-quoted strings. So I can just
# define =width= and =height= variables, and then interpolate them into
# the appropriate place in the command line.

width  = 960
height = 600
recording_options = %W[-f x11grab -s #{width}x#{height} -i 0:0+800,300 -r 30]
recording_options
# => ["-f", "x11grab", "-s", "960x600", "-i", "0:0+800,300", "-r", "30"]
