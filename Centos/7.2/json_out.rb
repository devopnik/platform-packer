#!/usr/bin/ruby
require 'json'
require 'erb'
template = ERB.new File.new("template.json.erb").read, nil, "%"
t_out = template.result(binding)

output_filename = "template.json"

output_json = t_out

output_file = File.open(output_filename, 'w+')
output_file.write(output_json)
output_file.close
