# mix in this module to be able to load
# descriptions of datasets.

module LoadDatasetDescription
  require 'json'

  def load_desc path, local=false
    if not local 
      data = `hdp-catd #{path}`
    else
      data = File.open path
    end
    description = []
    data.each_line do |line|
      col = JSON.parse line
      index = col.delete 'index'
      description.insert index, col
    end
    description
  end

  def load_desc_by_type path, local=false
    if not local
      data = `hdp-catd #{path}`
    else
      data = File.open path
    end
    description = {}
    data.each_line do |line|
      col = JSON.parse line
      type = col.delete('type').to_sym
      description[type] ||= []
      description[type] << col
    end
    description
  end
end
