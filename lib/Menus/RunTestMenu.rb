class RunTestMenu
  def self.init settings
    @@file = FileHelper.new do |helper|
      helper.file_path = settings['answer_files']['path']
      helper.file_ext = settings['answer_files']['ext']
    end
  end

  def self.run test
    puts 'Enter your name:'
    user_name = gets.chomp

    @@test_attempt = TestAttempt.new user_name, test
    @@filename = "#{@@test_attempt.user_name}_#{@@test_attempt.test_name}_#{@@test_attempt.start_time.to_i}"

    save_test_attempt
    run_test_menu_loop test
  end
  
  private

  def self.run_test_menu_loop test
    test.questions.each.with_index do |question, question_index|
      puts "(#{question_index + 1}/#{test.questions.size}) #{question.body}"
      display_numbered question.options, indentation_level=1

      puts 'Select the answer:'
      answer_index = gets.chomp.to_i
      while answer_index < 1 || answer_index > test.questions.size
        puts 'Invalid value entered!'
        puts 'Select the answer again:'
        answer_index = gets.chomp
      end

      @@test_attempt.question_answers[question_index].user_answer = test.questions[question_index].options[answer_index - 1]
      if question_index + 1 == test.questions.size
        @@test_attempt.status = AttemptStatus::COMPLETED
      end
      save_test_attempt
    end
  end

  def self.save_test_attempt
    json = JSON.pretty_generate @@test_attempt.to_h
    @@file.write @@filename, json
  end
end
