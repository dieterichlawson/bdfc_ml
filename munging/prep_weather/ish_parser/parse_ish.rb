#!/usr/bin/env ruby
require_relative './ish_parser.rb'

parser = ISHParser::Parser.new

$stdin.each_line do |line|
  p parser.parse line
end
headers = parser.headers.collect { |k,v| [k,v] }
headers.sort! {|a1,a2| a2[1] - a1[1]}
p headers
