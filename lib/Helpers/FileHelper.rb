class FileHelper
  attr_accessor :file_path, :file_ext
  
  def initialize
    yield self
  end

  def write file_name, content
    unless File.directory?(file_path)
      FileUtils.mkdir_p(file_path)
    end
    File.write("#{@file_path}/#{file_name}.#{@file_ext}", content, mode: 'w')
  end

  def read file_name
    File.read("#{@file_path}/#{file_name}.#{@file_ext}")
  end
end
