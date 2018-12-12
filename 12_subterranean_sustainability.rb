#!/usr/bin/env ruby

VERBOSE = ARGV.delete('-v')
SKIP = ARGV.delete('-s')

def explode(state)
  3.downto(0)
  state = "  #{state}"
  0.upto(state.length - 3).map do |i|
    state[i..i+4]
  end
end
def part1(state, transitions)
  puts "part1(#{state.inspect}, #{transitions.inspect})"

  puts " 0: #{state}"

  20.times do |gen|
    gen = gen + 1
    state = explode(state).map do |str|
      transition = transitions.find { |t,_| t.match(str) }
      transition.nil? ? '.' : transition[1]
    end.join("")
    puts "%2d: #{state}" % gen
  end
end

def part2(state, transitions)

end

input = (ARGV.empty? ? DATA : ARGF).read.split("\n---\n")
input.each_index do |i|
  next if i > 0 && SKIP
  data = input[i]

  state, transitions = data.split("\n\n", 2)
  state = state.split(":", 2)[1].strip
  state = "......#{state}#{"." * 25}"

  transitions = transitions.each_line.map do |line|
    match, mutation = line.split(" => ").map(&:strip)
    [Regexp.new("^#{match.gsub(".", "\\.")}$"), mutation]
  end

  part1(state.clone, transitions.clone)
  part2(state.clone, transitions.clone)

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
