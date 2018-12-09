#!/usr/bin/env ruby

class Claim
  attr_reader :id, :x1, :y1, :width, :height, :x2, :y2
  def initialize(line)
    parse(line)
    @x2 = @x1 + @width
    @y2 = @y1 + @height
  end

  def cords
    @cords ||= cords!
  end

  def cords!
    list = []
    @width.times do |i|
      x = i + @x1
      @height.times do |j|
        y = j + @y1
        list.push([x, y])
      end
    end
    list
  end

  def parse(line)
    id, rest = line.split("@", 2)
    xy, wh = rest.split(":", 2)
    @id = id[1..-1].chomp
    @x1, @y1 = xy.split(",").map(&:strip).map(&:to_i)
    @width, @height = wh.split("x",2).map(&:strip).map(&:to_i)
  end
end


class Fabric
  def initialize(x, y)
    @sheet = Array.new(x) do |row|
      Array.new(y, 0)
    end
  end

  def to_s
    @sheet.map { |row| row.inspect }.join("\n")
  end

  def add(x, y)
    @sheet[x][y] += 1
  end

  def overlap
    @overlap ||= overlap!
  end

  def overlap!
    overlaps = []
    @sheet.each_index do |x|
      @sheet[x].each_index do |y|
        overlaps << [x,y] if @sheet[x][y] > 1
      end
    end
    overlaps
  end
end

claims = ARGF.each_line.map {|l| Claim.new(l) }

max_x = claims.map(&:x2).max + 1
max_y = claims.map(&:y2).max + 1

fabric = Fabric.new(max_x + 1, max_y + 1)


claims.each do |claim|
  claim.cords.each do |x, y|
    fabric.add(x,y)
  end
end

#puts claims.map(&:inspect)
#puts fabric
#
#puts fabric.overlap.inspect
puts fabric.overlap.length
