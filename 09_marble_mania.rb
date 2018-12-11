#!/usr/bin/env ruby

VERBOSE = ARGV.delete('-v')
SKIP = ARGV.delete('-s')

class Board

  attr_reader :current

  def initialize(size)
    @size    = size
    @current = nil
    @id      = 0
  end

  def insert(v)
    if @current.nil?
      @current = Node.new(id!, v, nil, nil)
      @start   = @current
    else
      node = Node.new(id!, v, @current.right, @current.right.right)
      @current = node
    end
  end

  def remove
    return unless @current
    node     = @current
    @current = node.right
    node.left.right = node.right
    node.right.left = node.left
    node.value
  end

  def rotate(cnt = 1, type = :right)
    node = @current
    cnt.times { node = node.public_send(type) }
    @current = node
  end

  def rotate_left(cnt = 1)
    rotate(cnt, :left)
  end

  def rotate_right(cnt = 1)
    rotate(cnt, :right)
  end

  def length
    each.to_a.length
  end

  def to_s
    each.map do |node|
      suffix = ""
      if node.value
        if node.value > 9
          if node == @current
            prefix = "(#{prefix}"
            suffix = ") "
          else
            prefix = " #{prefix}"
            suffix = " "
          end
        else
          if node == @current
            prefix = "(#{prefix}"
            suffix = ") "
          else
            prefix = " #{prefix}"
            suffix = " "
          end
        end
      end
      "#{prefix}#{node.value}#{suffix}"
    end.join
  end

  def each(&blk)
    return to_enum.each(&blk) if block_given?
    to_enum
  end

  def to_enum
    Enumerator.new do |y|
      first = @start
      pos   = @start
      begin
        y << pos
        pos = pos.right
      end until first == pos
    end
  end

  private

  def id!
    i = @id
    @id += 1
    @id
  end

  class Node
    attr_accessor :left, :right, :value
    attr_reader :id

    def initialize(id, value, left, right)
      @id     = id
      @value  = value
      @left   = left || self
      @right  = right || self

      @left.right = self
      @right.left = self
    end

    def to_s
      prefix = left.nil? ? "" : "- "
      suffix = right.nil? ? "" : " -"
      "#{prefix}#{id}:#{value.inspect}#{suffix}"
    end
  end
end

def show(players, marbles, board, turn = nil )
  puts "  #{players.inspect} #{marbles}"
  player = turn.nil? ? "-" : turn % players.length
  puts "[#{player}] #{board}"
end


def part1(players_cnt, last_marble_num, high_score = nil)
  puts "#{players_cnt.inspect} #{last_marble_num.inspect} #{high_score.inspect}" if VERBOSE

  players        = Array.new(players_cnt, 0)
  marbles        = 0.upto(last_marble_num).map(&:to_i)
  board          = Board.new(last_marble_num)

  current_marble = marbles.shift
  board.insert(current_marble)
  show(players, marbles, board) if VERBOSE

  1.upto(last_marble_num) do |turn|
    marble = marbles.shift
    if turn % 23 == 0
      board.rotate_left(7)
      extra_marble = board.remove
      player = turn % players.length
      players[player] += (marble + extra_marble)
    else
      board.insert(marble)
    end
    show(players, marbles, board, turn) if VERBOSE
  end

  players.max
end

def part2(players_cnt, last_marble_num, high_score = nil)
  part1(players_cnt, last_marble_num * 100, high_score)
end

def elapsed(&blk)
  s = Time.now
  yield
  Time.now - s
end

input = (ARGV.empty? ? DATA : ARGF).read.split("\n---\n")
input.each_index do |i|
  next if i > 0 && SKIP
  data = input[i]
  players, last_marble = data.scan(/(\d+) players; last marble is worth (\d+) points/)[0].map(&:to_i)
  high_score = Array(data.scan(/high score is (\d+)/)[0]).map(&:to_i)[0]

  actual = part1(players, last_marble, high_score)
  if high_score
    puts "#{actual}:#{actual == high_score}"
  else
    puts "#{actual}"
  end

  speed = elapsed { puts part2(players, last_marble, high_score) }
  puts "#{speed}s" if VERBOSE

end

__END__

9 players; last marble is worth 25 points: high score is 32
---
10 players; last marble is worth 1618 points: high score is 8317
---
13 players; last marble is worth 7999 points: high score is 146373
---
17 players; last marble is worth 1104 points: high score is 2764
---
21 players; last marble is worth 6111 points: high score is 54718
---
30 players; last marble is worth 5807 points: high score is 37305
---
432 players; last marble is worth 71019 points
