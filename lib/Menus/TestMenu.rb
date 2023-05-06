class TestMenu
  def self.run test, current_file_name=''
    test_menu_loop test, current_file_name
  end
  
  def self.make_test_name_valid(test, current_file_name='')
    is_name_valid = current_file_name == test.name || !File.exist?("./Tests/#{test.name}.json")
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

  private
  
  def self.test_menu_loop test, current_file_name=''
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
            QuestionMenu.make_question_name_in_test_valid new_question, test
            test.questions.append new_question
            QuestionMenu.run new_question, test
          rescue => exception
            puts 'An error occurred during question adding!'
          else
            puts 'Question added successfully.'
          end
        when 3
          begin
            show_test_questions test
            puts 'Select question number:'
            selected_question_index = gets.chomp.to_i - 1
            selected_question = test.questions[selected_question_index]
            QuestionMenu.run selected_question, test
          rescue => exception
            puts 'Invalid value entered!'
          else
            puts 'Question edited successfully.'
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
            puts 'Question removed successfully.'
          end
        when 5
          begin
            puts 'Enter new test name:'
            test.name = gets.chomp
            make_test_name_valid test, current_file_name
          rescue => exception
            puts 'An error occurred during test renaming!'
          else
            puts 'Test renamed successfully.'
          end
        when 6
          begin
            make_test_name_valid test, current_file_name
            save_test_to_json test
          rescue => exception
            puts 'An error occurred during test saving!'
          else
            puts 'Test saved successfully.'
          end
        when 0
          break
      end
    end
  end
  
  def self.create_test
    test = Test.new
    puts 'Enter test name:'
    test.name = gets.chomp
    make_test_name_valid test
    test_menu_loop test
  end
  
  def self.show_test_questions test
    puts "Test '#{test.name}':"
    test.questions.each.with_index.with_object({}) {|(q, i), q_hash| puts "#{i + 1}. #{q.body}" }
  end
  
  def self.save_test_to_json test
    TestService.save_test test
  end
  
  def self.load_test_from_json test_name
    TestService.load_test test_name
  end
end
