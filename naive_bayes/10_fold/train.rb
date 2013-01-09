#! /usr/bin/env ruby

require 'configliere'

Settings.use :commandline

Settings.define :data_dir
Settings.define :model_dir
Settings.define :splits, default: 10
Settings.resolve!
(1..Settings.splits).each do |split_num|
  fork {  `./nb_train.rb --run --reduce_tasks=20 --rm #{Settings.data_dir}/split_#{split_num} #{Settings.model_dir}/model_#{split_num}` }
end
p Process.waitall
