#!/usr/bin/env ruby

def calibrate(current, changes)
  changes.inject(current) do |value, s_num|
    (value + s_num.to_i).tap {|v| yield v}
  end
end

current        = 0
freqs          = Hash.new { |h,k| h[k] = 0 }
freqs[current] += 1
list           = ARGF.each_line.map(&:chomp).map(&:to_i)
iterations     = 0

while true
  iterations += 1
  current = calibrate(current, list) do |freq|
    freqs[freq] += 1
    if freqs[freq] > 1
      puts "\nrepeat: #{freq}"
      Process.exit
    end
  end

  print "\rno repeat found after #{iterations} iterations"
end
