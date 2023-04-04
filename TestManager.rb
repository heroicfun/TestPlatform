require_relative 'Services/Dependencies'

def quetion_menu_loop(question)

end

def make_test_name_valid(test)
  is_name_valid = !File.exist?("./Tests/#{test.name}.json")
  while !is_name_valid
    puts 'Test with the same name already exist!'
    puts 'Enter new test name:'
    new_name = gets.chomp

    is_name_valid = !File.exist?("./Tests/#{new_name}.json")
    if is_name_valid
      test.name = new_name
    end
  end
end

def make_question_name_in_test_valid(question, test)
  is_question_valid = !test.questions.any? { |q| q.question == question.question }
  while !is_question_valid
    puts 'Test already has a question with the same question!'
    puts 'Enter new question question:'
    new_question = gets.chomp

    is_question_valid = !test.questions.any? { |q| q.question == new_question }
    if is_question_valid
      question.question = new_question
    end
  end
end

def show_test_quetions(test)
  puts "Test '#{test.name}':"
  test.questions.each.with_index.with_object({}) {|(q, i), q_hash| puts "#{i + 1}. #{q.question}" }
  puts 'Select quetion number'
end

def test_menu_loop(test)
  while true
    puts 'Select the command: 1-Show questions, 2-Add question, 3-Edit question, 4-Remove question, 5-Rename test, 6-Save test, 0-Exit'
    option = gets.chomp
    case option.to_i
    when 1
      puts JSON.pretty_generate(test.questions.to_h {|question| [question.question, question.options] })
    when 2
      begin
        new_question = Question.new
        new_question.test_id = test.id
        puts 'Enter question name:'
        new_question.question = gets.chomp
        make_question_name_in_test_valid new_question, test
        test.questions.append new_question
        quetion_menu_loop new_question
        puts 'Question added successfully'
      rescue => exception
        puts 'An error occurred during question adding!'
      end
    when 3
      show_test_quetions test
      begin
        selected_quetion_index = gets.chomp.to_i
        selected_quetion = test.questions[selected_quetion_index - 1]
        quetion_menu_loop selected_quetion
        puts 'Question edited successfully'
      rescue => exception
        puts 'Invalid value entered!'
      end
    when 4
      show_test_quetions test
      begin
        selected_quetion_index = gets.chomp.to_i
        test.questions.delete_at(selected_quetion_index - 1)
      rescue => exception
        puts 'Invalid value entered!'
      else
        puts 'Question removed successfully'
      end
    when 5
      begin
        puts 'Enter new test name:'
        test.name = gets.chomp
        make_test_name_valid test
      rescue => exception
        puts 'An error occurred during test renaming!'
      else
        puts 'Test renamed successfully'
      end
    when 6
      begin
        make_test_name_valid test
        save_to_json test
      rescue => exception
        puts 'An error occurred during test saving!'
      else
        puts 'Test saved successfully'
      end
    when 0
      break
    end
  end
end

def save_to_json(test)
  File.open("./Tests/#{test.name}.json", 'w') do |f|
    f.write(JSON.pretty_generate(test.to_h))
  end
end

def create_test
  test = Test.new

  puts 'Enter test name:'
  test.name = gets.chomp

  make_test_name_valid test
  
  test_menu_loop test
end

def load_from_json

end

def manager_menu_loop
  while true
    puts 'Select the command: 1-Create test, 2-Load tests'
    option = gets.chomp
    case option.to_i
    when 1
      create_test
    when 2
      load_test gets.chomp
    else
      exit 0
    end
  end
end

manager_menu_loop