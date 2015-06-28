# As you know, a Symbol literal is a word with a colon in front of it.

:foo

# You may also know that symbols aren't limited to simple words;
# anything that can go in a String, can go in a symbol. But how do we
# get arbitrary characters, like spaces and dashes, into a symbol?

# One way is to start with a string and use #to_sym to convert it to a
# symbol:

"foo-bar (baz)".to_sym          # => :"foo-bar (baz)"

# But there's a more concise and idiomatic way to do it. If we precede a
# quoted string with a colon, it becomes a quoted symbol.

:"foo-bar (baz)"                # => :"foo-bar (baz)"

# You can interpolate values into the quoted symbol just as you would
# into a string.

post_id = 123
:"post-#{post_id}"              # => :"post-123"

# And it also works for single-quotes.

:'hello, "world"'               # => :"hello, \"world\""

# Finally, if that doesn't satisfy your symbol-quoting needs, there's
# also a percent-quote literal syntax. Just like %q for strings, you can
# quote a symbol with %s followed by any delimiter you want.

%s{foo:bar}                     # => :"foo:bar"
