require_relative 'Dependencies'

def get_test_names
  tests = []
  Dir.foreach("./Tests") do |filename|
    if filename != '.' && filename != '..'
      name_without_extension = File.basename(filename, File.extname(filename))
      tests.append(name_without_extension)
    end
  end
  tests
end

def display_numbered enumerable
  enumerable.each.with_index {|e, i| puts "#{i + 1}. #{e}" }
end