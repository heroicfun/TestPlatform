require_relative 'Services/Dependencies'

def question_menu_loop(question)

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
  is_question_valid = !test.questions.any? { |q| q.body == question.body && q.id != question.id }
  while !is_question_valid
    puts 'Test already has a question with the same body!'
    puts 'Enter new question body:'
    new_question = gets.chomp

    is_question_valid = !test.questions.any? { |q| q.body == new_question }
    if is_question_valid
      question.body = new_question
    end
  end
end

def show_question_options(question)
  puts question.body
  question.options.each.with_index {|o, i| puts "#{i + 1}. #{o}" }
end

def question_menu_loop(question, test)
  while true
    puts 'Select the command: 1-Show options, 2-Add option, 3-Edit option, 4-Remove option, 5-Show answer, 6-Change answer, 7-Rename question, 0-Exit'
    option = gets.chomp
    case option.to_i
      when 1
        show_question_options question
      when 2
        puts 'Enter option:'
        question.options.append gets.chomp
      when 3
        begin
          show_question_options question
          puts 'Select option number:'
          selected_option_index = gets.chomp.to_i - 1
          if selected_option_index > -1 || selected_option_index < question.options.length
            puts 'Enter new option:'
            question.options[selected_option_index] = gets.chomp
          else
            puts 'Invalid value entered!'
          end
        rescue => exception
          puts 'Invalid value entered!'
        end
      when 4
        begin
          show_question_options question
          puts 'Select option number:'
          selected_option_index = gets.chomp.to_i - 1
          if selected_option_index > -1 || selected_option_index < question.options.length
            question.options.delete_at selected_option_index
          else
            puts 'Invalid value entered!'
          end
        rescue => exception
          puts 'Invalid value entered!'
        end
      when 5
        answer = question.options[question.answer]
        if answer == nil
          puts 'Answer is not set yet!'
        else
          puts "Answer: #{answer}"
        end
      when 6
        begin
          show_question_options question
          puts 'Select option number:'
          selected_option_index = gets.chomp.to_i - 1
          if selected_option_index > -1 || selected_option_index < question.options.length
            question.answer = selected_option_index
          else
            puts 'Invalid value entered!'
          end
        rescue => exception
          puts 'Invalid value entered!'
        end
      when 7
        begin
          puts 'Enter new question body:'
          question.body = gets.chomp
          make_question_name_in_test_valid question, test
        rescue => exception
          puts 'Invalid value entered!'
        end
      when 0
        break
    end
  end
end

def show_test_questions(test)
  puts "Test '#{test.name}':"
  test.questions.each.with_index.with_object({}) {|(q, i), q_hash| puts "#{i + 1}. #{q.body}" }
end

def test_menu_loop(test)
  while true
    puts 'Select the command: 1-Show questions, 2-Add question, 3-Edit question, 4-Remove question, 5-Rename test, 6-Save test, 0-Exit'
    option = gets.chomp
    case option.to_i
      when 1
        show_test_questions test
      when 2
        begin
          new_question = Question.new
          new_question.test_id = test.id
          puts 'Enter question body:'
          new_question.body = gets.chomp
          make_question_name_in_test_valid new_question, test
          test.questions.append new_question
          question_menu_loop new_question, test
          puts 'Question added successfully'
        rescue => exception
          puts 'An error occurred during question adding!'
        end
      when 3
        begin
          show_test_questions test
          puts 'Select question number:'
          selected_question_index = gets.chomp.to_i
          selected_question = test.questions[selected_question_index - 1]
          question_menu_loop selected_question
          puts 'Question edited successfully'
        rescue => exception
          puts 'Invalid value entered!'
        end
      when 4
        begin
          show_test_questions test
          puts 'Select question number:'
          selected_question_index = gets.chomp.to_i
          test.questions.delete_at(selected_question_index - 1)
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
    puts 'Select the command: 1-Create test, 2-Load tests, 3-Run test'
    option = gets.chomp
    case option.to_i
    when 1
      create_test
    when 2
      load_test gets.chomp
    when 3
      # display awaible tests
      # read user input
      # start testing
    else
      exit 0
    end
  end
end

manager_menu_loop