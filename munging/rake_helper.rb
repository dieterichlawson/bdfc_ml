require 'gorillib'
require 'gorillib/data_munging'
require 'configliere'

S3_BUCKET = 'bigdata.chimpy.us'
S3_DATA_ROOT = "s3n://#{S3_BUCKET}/data"
HDFS_DATA_ROOT = '/data'

Settings.define :orig_data_root, default: HDFS_DATA_ROOT, description: "directory root for input data"
Settings.define :scratch_data_root, default: HDFS_DATA_ROOT, description: "directory root for scratch data"
Settings.define :results_data_root, default: HDFS_DATA_ROOT, description: "directory root for results data"

def dir_exists? (dir)
  `hadoop fs -test -e #{dir}`
  return $?.exitstatus == 0
end

def wukong(script, input, output, options={})
  input = Pathname.of(input)
  output = Pathname.of(output)
  opts = ['--rm']
  options.each_pair do |k,v|
    opts << "--#{k}=#{v}"
  end
  opts << input
  opts << output
  ruby (script, Settings.wu_run_cmd,*opts)
end

def pig(script_name, options={})
  cmd = Settings.pig_path
  options.each_pair do |k,v|
    v = Pathname.of(v) if v.is_a? Symbol
    cmd += " -param #{k.upcase}=#{v}"
  end
  cmd += " #{script_name}"
  sh cmd
end
