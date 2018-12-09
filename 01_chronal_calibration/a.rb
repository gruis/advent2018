#!/usr/bin/env ruby


puts ARGF.each_line.inject(0) { |value, s_num| value + s_num.to_i }
