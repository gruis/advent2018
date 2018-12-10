#!/usr/bin/env ruby

VERBOSE = ARGV.delete('-v')
SKIP = ARGV.delete('-s')

MAX_DISTANCE = 10_000

def print_grid(grid)
  xmax = grid.length
  ymax = grid[0].length

  puts "  " + xmax.times.map(&:to_i).join
  puts "  " + ("_" * xmax)
  ymax.times do |y|
    print "#{y}|"
    xmax.times do |x|
      print case grid[x][y]
      when nil
        '.'
      when String
        grid[x][y]
      when Integer
        grid[x][y] < MAX_DISTANCE ? '#' : '.'
      end
    end
    print "\n"
  end
end

def traverse(grid)
  xmax = grid.length
  ymax = grid[0].length

  ymax.times do |y|
    xmax.times do |x|
      yield(x, y, grid[x][y])
    end
  end
end

def taxicab(p, q)
  (p[0] - q[0]).abs + (p[1] - q[1]).abs
end

def closest(a, b, cords)
  list = []
  max_distance = nil
  cords.each do |x, y, id|
    distance = taxicab([x, y], [a, b])
    if max_distance.nil? || distance < max_distance
      list = [id]
      max_distance = distance
    elsif distance == max_distance
      list << id
    end
  end
  list
end

def sum(a, b, cords)
  cords.map { |x, y, _| taxicab([x, y], [a, b]) }.inject(&:+)
end

def calc_areas(grid, cords)
  areas = Hash.new { |h,k| h[k] = 0 }
  xmax = grid.length - 1
  ymax = grid[0].length - 1

  traverse(grid) do |x, y, val|
    unless val.nil?
      if x == 0 || x == xmax || y == 0 || y == ymax
        areas[val] = -1
      else
        areas[val] += 1 unless areas[val] == -1
      end
    end
  end

  areas
end

def id_gen
  Enumerator.new do |y|
    curr = 65
    while (curr.chr rescue nil)
      y << curr.chr
      curr += 1
    end
  end
end

def fill_in_grid(grid, cords)
  grid.each_index do |x|
    grid[x].each_index do |y|
      val = grid[x][y]
      if val.nil?
        close_cords = closest(x, y, cords)
        grid[x][y] = close_cords.length == 1 ? close_cords[0] : nil
      end
    end
  end

  return grid
end

def fill_sum_grid(g, cords)
  grid = Marshal.load(Marshal.dump(g))
  traverse(grid) do |x, y, val|
    next unless val.nil?
    grid[x][y] = sum(x, y, cords)
  end
  grid
end

def accept_distance?(x, y, val, grid)
  return false if val.nil?
  return val < MAX_DISTANCE if val.is_a?(Integer)
  return false if x == 0 || y == 0 || x == grid.length - 1 || y >= grid[0].length - 1
  [
    [x - 1, y], [x + 1, y],
    [x, y - 1], [x, y + 1]
  ].map { |x, y| [x, y, grid[x][y]] }
   .all? { |x, y, val| accept_distance?(x, y, val, grid) }
end

input = (ARGV.empty? ? DATA : ARGF).read.split("\n---\n")

input.each_index do |i|
  next if i > 0 && SKIP
  data = input[i]

  cords = data.each_line.map { |l| l.split(",").map(&:strip).map(&:to_i) }

  xmax = cords.map(&:first).max
  ymax = cords.map(&:last).max

  next_id = id_gen

  grid = Array.new(xmax + 1) do
    Array.new(ymax + 1, nil)
  end

  print_grid(grid) if VERBOSE

  cords.each do |cord|
    x,y = *cord
    id = next_id.next
    grid[x][y] = id
    cord[2]    = id
  end

  print_grid(grid) if VERBOSE

  sum_grid = fill_sum_grid(grid, cords)
  puts "\n\nSum Grid" if VERBOSE
  print_grid(sum_grid) if VERBOSE
  puts "\n\n" if VERBOSE

  fill_in_grid(grid, cords)


  puts "\n\n" if VERBOSE
  print_grid(grid) if VERBOSE
  puts "\n\n" if VERBOSE

  areas = calc_areas(grid, cords)
  puts areas.inspect if VERBOSE

  max = [nil, 0]
  areas.each do |id, size|
    max = [id, size] if size > max[1]
  end

  puts max.join(":")

  sums = []
  traverse(sum_grid) do |x,y,sum|
    sums << "#{x},#{y}:#{sum}" if accept_distance?(x, y, sum, sum_grid)
  end
  puts sums.length
end


__END__
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
---
267, 196
76, 184
231, 301
241, 76
84, 210
186, 243
251, 316
265, 129
142, 124
107, 134
265, 191
216, 226
67, 188
256, 211
317, 166
110, 41
347, 332
129, 91
217, 327
104, 57
332, 171
257, 287
230, 105
131, 209
110, 282
263, 146
113, 217
193, 149
280, 71
357, 160
356, 43
321, 123
272, 70
171, 49
288, 196
156, 139
268, 163
188, 141
156, 182
199, 242
330, 47
89, 292
351, 329
292, 353
290, 158
167, 116
268, 235
124, 139
116, 119
142, 259
