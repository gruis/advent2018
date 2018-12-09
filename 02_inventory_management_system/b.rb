#!/usr/bin/env ruby


def drift(a,b)
  gap   = 0
  vec_a = a.each_char.to_a
  vec_b = b.each_char.to_a

  vec_a.each_with_index do |c,i|
    gap += 1 if vec_b[i] != c
  end

  gap
end

def strip_diff(a,b)
  vec_a = a.each_char.to_a
  vec_b = b.each_char.to_a
  vec_new = []
  vec_a.each_with_index do |v,i|
    vec_new.push(v) if vec_b[i] == v
  end
  vec_new.join
end

list = ARGF.each_line.map(&:chomp)

id_a = ""
id_b = ""

list.each_with_index do |val, i|
  sub_list = list[i+1 .. -1]
  sub_list.each do |sub_val|
    if drift(val, sub_val) <= 1
      id_a = val
      id_b = sub_val
      break
    end
  end
end

puts "#{id_a}:#{id_b}"
puts strip_diff(id_a, id_b)
