#! /usr/bin/env ruby

require 'configliere'

Settings.use :commandline

Settings.define :data_dir
Settings.define :results_dir
Settings.define :splits, default: 10
Settings.define :model_dir
Settings.resolve!

(1..Settings.splits).each do |split_num|
  fork { `./nb_test.rb --run --reduce_tasks=4 --rm --leave_out=#{split_num} --model_dir=#{Settings.model_dir} #{Settings.data_dir}/split_#{split_num} #{Settings.results_dir}/#{split_num}` }
end
p Process.waitall
