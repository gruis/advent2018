#!/usr/bin/env ruby

VERBOSE = ARGV.delete('-v')
SKIP = ARGV.delete('-s')

def explode(state)
  "....#{state}....".each_char.each_cons(5).map(&:join)
end

def part1(state, transitions)
  state = "#{state}"
  puts " 0: #{state}" if VERBOSE

  gen = 0
  20.times do
    gen += 1
    state = explode(state).map do |str|
      transition = transitions.find { |t,_| t.match(str) }
      transition.nil? ? str[2] : transition[1]
    end.join("")
    puts "%2d: #{state}" % gen if VERBOSE
  end

  total(state, gen)
end

def part2(state, transitions)
  puts " 0: #{state}" if VERBOSE
  #TODO: make it work

  gen = 0
  2500.times do |gen|
    gen += 1
    state = explode(state).map do |str|
      transition = transitions.find { |t,_| t.match(str) }
      transition.nil? ? '.' : transition[1]
    end.join("")
    print "\r%5d -%10d-    " % [gen, total(state, gen)]
    puts "%2d: #{state}" % gen if VERBOSE
  end

  total(state, gen)
end

def total(state, gen)
  zero_spot = 2 * gen
  total = 0
  state[zero_spot..-1].each_char.each_with_index do |c, i|
   total = total + i if c == "#"
  end
  total
  #idx = -(2 * gen)
  #total = 0
  #state.each_char do |c|
  #  total = total + idx if c == "#"
  #  idx += 1
  #end
  #total
end

input = (ARGV.empty? ? DATA : ARGF).read.split("\n---\n")
input.each_index do |i|
  next if i < 1 && SKIP
  data = input[i]

  state, transitions = data.split("\n\n", 2)
  state = state.split(":", 2)[1].strip

  transitions = transitions.each_line.map do |line|
    match, mutation = line.split(" => ").map(&:strip)
    [Regexp.new("^#{match.gsub(".", "\\.")}$"), mutation]
  end

  puts part1(state.clone, transitions.clone)
  puts part2(state.clone, transitions.clone)

end

__END__
initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
---
initial state: ##.#############........##.##.####..#.#..#.##...###.##......#.#..#####....##..#####..#.#.##.#.##

###.# => #
.#### => #
#.### => .
.##.. => .
##... => #
##.## => #
.#.## => #
#.#.. => #
#...# => .
...## => #
####. => #
#..## => .
#.... => .
.###. => .
..#.# => .
..### => .
#.#.# => #
..... => .
..##. => .
##.#. => #
.#... => #
##### => .
###.. => #
..#.. => .
##..# => #
#..#. => #
#.##. => .
....# => .
.#..# => #
.#.#. => #
.##.# => .
...#. => .
