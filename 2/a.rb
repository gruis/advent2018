#!/usr/bin/env ruby


def checksum(input)
  counts = Hash.new { |h,k| h[k] = 0 }
  input.each_char { |c| counts[c] += 1 }
  [
    counts.values.select { |c| c == 2 }.length > 0 ? 1 : 0,
    counts.values.select { |c| c == 3 }.length > 0 ? 1 : 0
  ]
end

totals = [0, 0]
list = ARGF.each_line.map(&:chomp)
list.each do |id|
  sums = checksum(id)
  totals[0] += sums[0]
  totals[1] += sums[1]
end

puts totals[0] * totals[1]
