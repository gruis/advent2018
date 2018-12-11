#!/usr/bin/env ruby

VERBOSE = ARGV.delete('-v')
SKIP = ARGV.delete('-s')

input = (ARGV.empty? ? DATA : ARGF).read.split("\n---\n")
input.each_index do |i|
  next if i > 0 && SKIP
  data = input[i]

end

__END__

