# #+TITLE: Large Integer Literals
# #+SETUPFILE: ../defaults.org
# #+BABEL:

# Continuing in this series about literals and quoting, let's talk about
# large integers.

# Quick question: how many zeroes are in this number?

100000000000

# Past a certain size, it's hard to visually identify the number of
# digits in a numeric literal. That's why in written language we usually
# break the number into groups of digits. For instance, in my US locale
# we would normally split the number into groups of three digits, with
# commas:

# 100,000,000,000

# Thankfully, we can do something similar in Ruby. Ruby lets us insert
# underscores anywhere we want in integer literals. So we could rewrite
# this number like so:

100_000_000_000
