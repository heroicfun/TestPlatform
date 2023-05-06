class QuestionMenu
  def self.run question, test
    question_menu_loop question, test
  end

  def self.make_question_name_in_test_valid(question, test)
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

  private

  def self.question_menu_loop question, test
    while true
      puts 'Select the command: 1-Show options, 2-Add option, 3-Edit option, 4-Remove option, 5-Show answer, 6-Change answer, 7-Rename question, 0-Exit'
      option = gets.chomp
      case option.to_i
        when 1
          show_question_options question
        when 2
          puts 'Enter option:'
          question.options.append gets.chomp
          puts 'Option added successfully!'
        when 3
          begin
            show_question_options question
            puts 'Select option number:'
            selected_option_index = gets.chomp.to_i - 1
            if selected_option_index > -1 && selected_option_index < question.options.length
              puts 'Enter new option:'
              question.options[selected_option_index] = gets.chomp
              puts 'Option edited successfully!'
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
            if selected_option_index > -1 && selected_option_index < question.options.length
              question.options.delete_at selected_option_index
              puts 'Option removed successfully!'
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
            if selected_option_index > -1 && selected_option_index < question.options.length
              question.answer = selected_option_index
              puts 'Answer changed successfully!'
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
          else
            puts 'Question body edited successfully!'
          end
        when 0
          break
      end
    end
  end
  
  def self.show_question_options(question)
    puts question.body
    display_numbered question.options
  end
end
