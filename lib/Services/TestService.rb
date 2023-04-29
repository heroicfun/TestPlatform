require_relative '../Classes/Test'
require_relative '../Helpers/FileHelper'
require 'json'

class TestService
  def self.init settings
    @@file = FileHelper.new do |helper|
      helper.file_path = settings['test_files']['path']
      helper.file_ext = settings['test_files']['ext']
    end
  end

  def self.get_test_names
    tests = []
    Dir.foreach("./Tests") do |filename|
      if filename != '.' && filename != '..'
        name_without_extension = File.basename(filename, File.extname(filename))
        tests.append(name_without_extension)
      end
    end
    tests
  end

  def self.save_test test
    json = JSON.pretty_generate(test.to_h)
    @@file.write test.name, json
  end

  def self.load_test test_name
    json = @@file.read test_name
    Test.from_h(JSON.parse(json))
  end
end