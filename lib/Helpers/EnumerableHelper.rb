def display_numbered enumerable
  enumerable.each.with_index {|e, i| puts "#{i + 1}. #{e}" }
end