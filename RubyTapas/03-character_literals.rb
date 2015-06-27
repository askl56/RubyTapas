?c                              # => "c"
?q                              # => "q"


case $stdin.getc.downcase
when ?y then puts "Proceeding..."
when ?n then puts "Aborting."
else puts "I don't understand"
end
