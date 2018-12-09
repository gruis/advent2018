#!/usr/bin/ruby

require 'time'


events = ARGF.each_line.map do |line|
  date, msg = line.split(']', 2)
  date      = Time.parse(date[1..-1])
  msg       = msg.strip
  [date, msg]
end.sort { |a,b| a[0] <=> b[0] }

class Guard
  attr_reader :id

  def initialize(id)
    @id            = id
    @events        = []
    @asleep_vector = Array.new(60, 0)
  end

  def start(time)
    @events << [:start, time]
  end

  def asleep(time)
    @events << [:alseep, time]
  end

  def total_asleep
    @total_alseep ||= @asleep_vector.inject(&:+)
  end

  def awake(time)
    start_min = @events.last[1].min
    asleep_mins = ((time - @events.last[1]) / 60).to_i
    asleep_mins.times do |i|
      @asleep_vector[start_min + i] += 1
    end

    @events << [:awake, time]
  end

  def most_asleep_min
    @most_asleep_min ||= most_asleep_min!
  end

  def most_asleep_min!
    most = [0, 0]
    @asleep_vector.each_index do |min|
      count = @asleep_vector[min]
      most = [count, min] if count > most[0]
    end
    most[1]
  end
end

guard = nil
guards = Hash.new { |h,k| h[k] = Guard.new(k) }

events.each do |time, msg|
  action, data = msg[0..5], msg[6..-1].strip
  case action.strip
  when "Guard"
    id = data.split(" ", 2)[0][1..-1].to_i
    guard = guards[id]
    guard.start(time)
  when "falls"
    guard.asleep(time)
  when "wakes"
    guard.awake(time)
  else
    raise "Unrecognized action: #{action.inspect}"
  end
end


most_asleep = guards.values.sort_by(&:total_asleep).last
puts most_asleep.inspect

id = most_asleep.id
min = most_asleep.most_asleep_min

puts "#{id} * #{min} = #{id * min}"
