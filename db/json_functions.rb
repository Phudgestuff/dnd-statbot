require 'json'
require 'fileutils'

PATH = './db/db.json'

module DB
  module_function

  def get_data
    # ensure that ./db exists
    FileUtils.mkdir_p('./db') unless File.directory?('./db')

    # create db file if it doesn't exist
    unless File.exist?(PATH)
      update({})
    end

    # get json from db.json and return as hash
    file_data = File.read(PATH)
    stats = JSON.parse(file_data, symbolize_names: true)
    return stats
  end

  def update(data)
    # ensure directory exists before writing
    FileUtils.mkdir_p('/.db') unless File.directory?('./db')

    File.write(PATH, JSON.pretty_generate(data))
  end
end
