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

    @@test_attempt = TestAttempt.from_test test
    @@test_attempt.user_name = user_name
    
    @@filename = "#{@@test_attempt.user_name}_#{@@test_attempt.test_name}_#{@@test_attempt.start_time.to_i}"

    save_test_attempt
    run_test_menu_loop test
  end
  
  private

  def self.run_test_menu_loop test
    attemp_statistics = AttemptStatistics.new
    test.questions.each.with_index do |question, question_index|
      puts "(#{question_index + 1}/#{test.questions.size}) #{question.body}"
      display_numbered question.options, indentation_level=1

      puts 'Select the answer:'
      answer_index = gets.chomp.to_i - 1
      while answer_index < 0 || answer_index >= test.questions[question_index].options.size
        puts 'Invalid value entered!'
        puts 'Select the answer again:'
        answer_index = gets.chomp
      end

      answer_index == test.questions[question_index].answer ? attemp_statistics.correct_answer_count += 1 : attemp_statistics.incorrect_answer_count += 1

      @@test_attempt.question_answers[question_index].user_answer = test.questions[question_index].options[answer_index]
      if question_index + 1 == test.questions.size
        @@test_attempt.status = AttemptStatus::COMPLETED
      end
      save_test_attempt
    end
    attemp_statistics.show
  end

  def self.save_test_attempt
    json = JSON.pretty_generate @@test_attempt.to_h
    @@file.write @@filename, json
  end
end
