#!/usr/bin/env ruby


VERBOSE = ARGV.delete('-v')
SKIP = ARGV.delete('-s')

STEP_DURATIONS = [ 0, 60 ].freeze
WORKERS = [2, 5].freeze

def next_step(steps, done)
  return nil if steps.empty?
  roots = steps.select { |name, parents| parents.empty? }
  name = roots.keys.sort.first
  steps.delete(name)
  name
end

def complete(step, done, steps)
  done = "#{done}#{step}"
  steps.values.each { |deps| deps.delete(step) }
  done
end

def part1(steps)
  path = ""

  puts steps.inspect if VERBOSE
  while (name = next_step(steps, path)) do
    path = complete(name, path, steps)
    puts path.inspect if VERBOSE
    puts steps.inspect if VERBOSE
  end

  puts path
end

def part2(steps, step_duration, worker_cnt)
  path    = ""
  sec     = 0
  workers = Array.new(worker_cnt) { { step: "", cnt: nil } }

  workers_hdr = 1.upto(workers.length).map { |i| "Worker #{i}" }.join("        ")
  puts "Second   #{workers_hdr}   Done" if VERBOSE
  fmts = "%5d      " + workers.map { "%1s:%3d" }.join("           ") + "    %s"

  req_len = steps.length
  until path.length == req_len do
    workers.reject { |w| w[:cnt].nil? }.each { |w| w[:cnt] = w[:cnt] - 1 }

    workers.select { |w| w[:cnt] == 0 }.sort { |a, b| a[:id] <=> b[:id] }.each do |worker|
      path = complete(worker[:step], path, steps)
      worker[:step] = ""
      worker[:cnt] = nil
    end


    workers.select { |w| w[:cnt].nil? }.each do |worker|
      step = next_step(steps, path)
      break unless step
      worker[:step] = step
      worker[:cnt]  = step.ord % 64 + step_duration
    end

    if VERBOSE
      puts fmts %
        [
          sec,
          workers.map(&:values).map { |a,b| [a, b.nil? ? 0 : b] },
         path
        ].flatten
    end

    sec += 1
  end

  duration = sec - 1
  puts "#{path}:#{duration}"
end

input = (ARGV.empty? ? DATA : ARGF).read.split("\n---\n")
input.each_index do |i|
  next if i > 0 && SKIP
  data = input[i]

  steps1 = Hash.new {|h,k| h[k] = [] }
  steps2 = Hash.new {|h,k| h[k] = [] }

  data.each_line do |line|
    parent, child = line.scan(/Step (\w+) must be finished before step (\w+) can begin\./).first
    steps1[child] << parent
    steps1[parent]
    steps2[child] << parent
    steps2[parent]
  end

  part1(steps1)
  part2(steps2, STEP_DURATIONS[i], WORKERS[i])
end


__END__
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
---
Step G must be finished before step W can begin.
Step X must be finished before step S can begin.
Step F must be finished before step V can begin.
Step C must be finished before step Y can begin.
Step M must be finished before step J can begin.
Step K must be finished before step Z can begin.
Step U must be finished before step W can begin.
Step I must be finished before step H can begin.
Step W must be finished before step B can begin.
Step A must be finished before step Y can begin.
Step Y must be finished before step D can begin.
Step S must be finished before step Q can begin.
Step N must be finished before step V can begin.
Step H must be finished before step D can begin.
Step D must be finished before step Q can begin.
Step L must be finished before step E can begin.
Step Q must be finished before step E can begin.
Step T must be finished before step R can begin.
Step J must be finished before step P can begin.
Step R must be finished before step E can begin.
Step E must be finished before step V can begin.
Step O must be finished before step P can begin.
Step P must be finished before step B can begin.
Step Z must be finished before step V can begin.
Step B must be finished before step V can begin.
Step Y must be finished before step B can begin.
Step C must be finished before step B can begin.
Step Q must be finished before step T can begin.
Step W must be finished before step P can begin.
Step X must be finished before step Z can begin.
Step L must be finished before step T can begin.
Step G must be finished before step Y can begin.
Step Y must be finished before step R can begin.
Step E must be finished before step B can begin.
Step X must be finished before step E can begin.
Step Y must be finished before step V can begin.
Step H must be finished before step L can begin.
Step L must be finished before step J can begin.
Step S must be finished before step T can begin.
Step F must be finished before step T can begin.
Step Y must be finished before step J can begin.
Step A must be finished before step H can begin.
Step P must be finished before step Z can begin.
Step R must be finished before step O can begin.
Step X must be finished before step F can begin.
Step I must be finished before step O can begin.
Step Y must be finished before step Q can begin.
Step S must be finished before step D can begin.
Step Q must be finished before step B can begin.
Step C must be finished before step D can begin.
Step Y must be finished before step N can begin.
Step O must be finished before step Z can begin.
Step G must be finished before step D can begin.
Step A must be finished before step O can begin.
Step U must be finished before step N can begin.
Step Y must be finished before step P can begin.
Step E must be finished before step O can begin.
Step I must be finished before step Q can begin.
Step W must be finished before step O can begin.
Step D must be finished before step B can begin.
Step Z must be finished before step B can begin.
Step L must be finished before step B can begin.
Step P must be finished before step V can begin.
Step C must be finished before step E can begin.
Step S must be finished before step O can begin.
Step U must be finished before step T can begin.
Step U must be finished before step O can begin.
Step Y must be finished before step L can begin.
Step N must be finished before step L can begin.
Step Q must be finished before step Z can begin.
Step U must be finished before step L can begin.
Step U must be finished before step D can begin.
Step J must be finished before step O can begin.
Step L must be finished before step R can begin.
Step S must be finished before step P can begin.
Step H must be finished before step R can begin.
Step F must be finished before step I can begin.
Step D must be finished before step T can begin.
Step C must be finished before step M can begin.
Step W must be finished before step D can begin.
Step R must be finished before step V can begin.
Step U must be finished before step S can begin.
Step K must be finished before step R can begin.
Step D must be finished before step V can begin.
Step D must be finished before step R can begin.
Step I must be finished before step E can begin.
Step L must be finished before step O can begin.
Step T must be finished before step Z can begin.
Step A must be finished before step E can begin.
Step D must be finished before step Z can begin.
Step H must be finished before step V can begin.
Step A must be finished before step L can begin.
Step W must be finished before step R can begin.
Step F must be finished before step A can begin.
Step Y must be finished before step Z can begin.
Step I must be finished before step P can begin.
Step F must be finished before step J can begin.
Step H must be finished before step B can begin.
Step G must be finished before step Z can begin.
Step C must be finished before step K can begin.
Step D must be finished before step E can begin.
