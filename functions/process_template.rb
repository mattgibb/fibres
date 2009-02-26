#!/usr/bin/ruby
# Takes full path to erb template as first argument, 
require 'erb'
 template = ERB.new(File.read(ARGV[0]))
 puts template.result(binding)
