require_relative '../Classes/Test'
require 'json'

class TestService

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
    File.open("./Tests/#{test.name}.json", 'w') do |f|
      f.write(JSON.pretty_generate(test.to_h))
    end
  end

  def self.load_test test_name
    json = File.read("./Tests/#{test_name}.json")
    hash = JSON.parse(json)
    Test.from_h(hash)
  end
end