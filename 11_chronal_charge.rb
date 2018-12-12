#!/usr/bin/env ruby

VERBOSE = ARGV.delete('-v')
SKIP = ARGV.delete('-s')


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
  grid = Array.new(301) do
    Array.new(301, 0)
  end

  1.upto(300) do |x|
    rack_id = x + 10
    1.upto(300) do |y|
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
  totals = Array.new(300 - (size - 1)) do
    Array.new(300 - (size - 1), 0)
  end

  1.upto(300 - size) do |x|
    1.upto(300 - size) do |y|
      (x..(x + (size - 1))).each do |sx|
        (y..(y + (size - 1))).each do |sy|
          totals[x][y] += grid[sx][sy]
        end
      end
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
  1.upto(300 - size) do |x|
    1.upto(300 - size) do |y|
      if totals[x][y] > max
        max = totals[x][y]
        cords = [x,y]
      end
    end
  end
  [cords, max]
end

def part1(grid)
  find_most_power( calc_totals( grid, 3), 3).inspect
end

def part2(grid)
  max = 0
  coords = [nil, nil]
  best_size = 0
  1.upto(300) do |size|
    # TODO: spin off a thread for each size
    result = find_most_power( calc_totals( grid, size), size)
    if result[1] > max
      max = result[1]
      cords = result[0]
      best_size = size
    end
  end
  [cords, max, best_size]
end

input = (ARGV.empty? ? DATA : ARGF).read.split("\n---\n")
input.each_index do |i|
  next if i > 0 && SKIP
  data = input[i].strip.to_i
  grid = build_grid(data)
  puts "#{data}: " + part1(data, grid)
  puts "#{data}: " + part2(data, grid)
end

__END__

18
---
42
---
1723
