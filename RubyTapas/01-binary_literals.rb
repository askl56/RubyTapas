42
3.13159
"foo"

0x7FFF # Hexidecimal
0755 # Octal

require 'fileutils'
include FileUtils

chmod 0755, 'somefile'

# U G O

# rwxrwxrwx

0b111101101

perms = 0b111101101
perms.to_s(8)

chmod perms, 'somefile'
