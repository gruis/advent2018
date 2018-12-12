#!/usr/bin/env ruby

VERBOSE = ARGV.delete('-v')
SKIP = ARGV.delete('-s')

require 'pry'
GRID_SIZE = 300


# https://stackoverflow.com/a/13091729
def digits(num, base: 10)
  quotient, remainder = num.divmod(base)
  quotient == 0 ? [remainder] : [*digits(quotient, base: base), remainder]
end

def hundred_digit(num)
  digits(num).reverse[2] || 0
end

def power_level(rack_id, y, serial_number)
  hundred_digit(((rack_id * y) + serial_number) * rack_id) - 5
end

def build_grid(serial_number)
  grid = Array.new(GRID_SIZE + 1) do
    Array.new(GRID_SIZE + 1, 0)
  end

  1.upto(GRID_SIZE) do |x|
    rack_id = x + 10
    1.upto(GRID_SIZE) do |y|
      level = power_level(rack_id, y, serial_number)
      if level > 9 || level < -9
        raise "bad power level #{level.inspect}"
      end
      grid[x][y] = level
    end
  end

  grid
end

def calc_totals(grid, size = 3)
  return grid if size == grid.length # FIXME: probably off by one
  totals = []

  width       = grid.length - 1
  height      = grid.length - 1
  num_squares = width - (size - 1)

  column_totals = []
  sums = []

  # FIXME: there's a bug in here that causes `sums` to be empty once size hits
  #        256; `size` ends up being larger than column_totals.length
  1.upto(height - (size - 1)) do |yoffset|
    1.upto(width - (size - 1)) do |x|
      column_totals << (yoffset.upto(yoffset + size - 1).map { |y| grid[y][x] }).inject(&:+)
    end
  end

  0.upto(column_totals.length - size) do |i|
    sums << size.times.map { |j| column_totals[i + j] }.inject(&:+)
  end

  discard = sums.length / 2
  sums = sums[0...discard] + sums[discard + 1 .. -1]

  # There must be an efficient equation to convert position in the sum vector to x,y coordinates
  1.upto(grid.length - size) do |x|
    1.upto(grid.length - size) do |y|
      sum = sums.shift
      break unless sum
      totals << [[x,y], sum]
    end
  end

  totals
end

def print_grid(grid)
  1.upto(grid[0].length - 1) do |x|
    1.upto(grid.length - 1) do |y|
      print "%2d" % grid[x][y]
    end
    print "\n"
  end
end

def find_most_power(totals, size)
  max   = 0
  cords = [nil, nil]

  totals.each do |(x,y), total|
    if total > max
      max = total
      cords = [x,y]
    end
  end

  return [cords, max]
end

def duration(&blk)
  s = Time.now
  return [yield, Time.now - s]
end

def part1(grid)
  find_most_power( calc_totals( grid, 3), 3)
end

def part2(grid)
  max = 0
  cords = [nil, nil]
  best_size = 0

  _, total_time = duration do
    1.upto(GRID_SIZE) do |size|
      totals, calc_time = duration { calc_totals(grid, size) }
      power, find_time = duration { find_most_power(totals, size) }
      dist_time = calc_time - find_time
      print "\rsize:%3s best:%3s #{cords} calc:%8.3f find:%8.3f disc:%8.3f" % [size, best_size, calc_time, find_time, dist_time]

      if power[1] > max
        max       = power[1]
        cords     = power[0]
        best_size = size
      end
    end

    print "\n"
  end

  puts "time to find answer (#{cords}, #{max}, #{best_size})  %8.3f" % [total_time]

  [cords, max, best_size]
end

puts build_grid(8)[3][5] # should == 4
puts build_grid(57)[122][79] # should == -5
puts build_grid(39)[217][196] # should == 0
puts build_grid(71)[101][153] # should == 4

puts part1(build_grid(18)).to_s # [[33, 45], 29]

input = (ARGV.empty? ? DATA : ARGF).read.split("\n---\n")
input.each_index do |i|
  next if i > 0 && SKIP

  # FIXME: there's a bug here that causes the 'y' to be off by one in part2 for
  #        42, and 1723

  data = input[i].strip.to_i
  grid = build_grid(data)
  puts "#{data}: #{part1(grid)}"
  puts "#{data}: #{part2(grid)}"
end

__END__

1723
---
42
---
18
