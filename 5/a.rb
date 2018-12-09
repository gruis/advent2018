#!/usr/bin/env ruby

def reactive?(a, b)
  (a.ord - b.ord).abs == 32
end

def react(input)
  result = []
  input.each_char do |unit|
    if result[-1].nil?
      result << unit
      next
    end

    reactive?(result[-1], unit) ?  result.pop : result.push(unit)
  end

  result.join
end

polymer = react(ARGF.read.strip)

puts polymer
puts polymer.length

mutations = 25.times.map do |i|
  unit = [ (65 + i).chr, (65 + 32 + i).chr ]
  react(
    polymer.gsub(unit[0], "").gsub(unit[1], "")
  )
end

shortest = mutations.sort_by(&:length).first
puts shortest
puts shortest.length
