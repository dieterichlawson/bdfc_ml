require 'gorillib'
require 'gorillib/data_munging'
require 'configliere'

S3_BUCKET = 'bigdata.chimpy.us'
S3_DATA_ROOT = "s3n://#{S3_BUCKET}/data"
HDFS_DATA_ROOT = '/data'

Settings.define :orig_data_root, default: HDFS_DATA_ROOT, description: "directory root for input data"
Settings.define :scratch_data_root, default: HDFS_DATA_ROOT, description: "directory root for scratch data"
Settings.define :results_data_root, default: HDFS_DATA_ROOT, description: "directory root for results data"
