def display_numbered enumerable, indentation_level=0
  enumerable.each.with_index {|e, i| puts "#{"  "*indentation_level}#{i + 1}. #{e}" }
end
