class FileHelper
  attr_accessor :file_path, :file_ext
  
  def initialize
    yield self
  end

  def write file_name, content
    File.open("#{@file_path}/#{file_name}.#{@file_ext}", 'w') do |f|
      f.write(content)
    end
  end

  def read file_name
    File.read("#{@file_path}/#{file_name}.#{@file_ext}")
  end
end