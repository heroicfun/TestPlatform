class TelegramBot
  TOKEN = '5955642556:AAEUtklOhc3lEHMYKSRy165daqMc68pvkYQ'.freeze
  def self.init settings
    @@answers_dir = settings['answer_files']['path']

    @@file = FileHelper.new do |helper|
      helper.file_path = settings['answer_files']['path']
      helper.file_ext = settings['answer_files']['ext']
    end
  end

  def run
    bot.listen do |message|
      Thread.new { process_message message }
    end
  end

  private

  def bot
    Telegram::Bot::Client.run(TOKEN) { |bot| return bot }
  end

  def process_message message
    chat_id = message.chat.id
    case message.text.downcase
      when '/start'
        send_test_select_keyboard chat_id
      when '/exit'

      else
        input = message.text.split(': ', 2)
        user_name = message.from.id
        case input[0].downcase
          when 'test'
            test_name = input[1]

            test = TestService.load_test test_name        
            test_attempt = TestAttempt.from_test test
            test_attempt.user_name =  user_name
            save_test_attempt test_attempt

            proceed_attempt test_attempt, chat_id
          else
            test_attempt = load_last_test_attempt user_name.to_s
            if test_attempt != nil
              question = get_next_unanswered_question test_attempt
              if question != nil
                puts "quest"
                answer_index = input[0][0].to_i - 1
                answer = question.options[answer_index]
                question.user_answer = answer
                save_test_attempt test_attempt
    
                proceed_attempt test_attempt, chat_id
              elsif test_attempt.status != AttemptStatus::COMPLETED
                finish_attempt test_attempt, chat_id
              end
            else
              clean_keyboard = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
              bot.api.send_message(chat_id: chat_id, text: 'The test list has been refreshed', reply_markup: clean_keyboard)
              send_test_select_keyboard chat_id
            end
        end
    end
  end

  def send_test_select_keyboard chat_id
    text = 'Select a test to start'
    keyboard = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: [],
          one_time_keyboard: true
        )

    TestService.get_test_names.each { |test_name| keyboard.keyboard.append([{ text: "Test: #{test_name}" }])}

    bot.api.send_message(chat_id: chat_id, text: text, reply_markup: keyboard)
  end

  def save_test_attempt test_attempt
    filename = "#{test_attempt.user_name}_#{test_attempt.test_name}_#{test_attempt.start_time.to_i}"
    json = JSON.pretty_generate test_attempt.to_h
    @@file.write filename, json
  end

  def load_last_test_attempt user_name
    user_attempts = Dir.entries(@@answers_dir).select { |f| f.start_with? user_name }
    if user_attempts.any?
      filename = user_attempts.last
      json = @@file.read File.basename(filename, File.extname(filename))
      return TestAttempt.from_h JSON.parse json 
    else 
      return nil
    end
  end

  def proceed_attempt test_attempt, chat_id
    unanswered_questions = get_next_unanswered_question test_attempt
    if unanswered_questions != nil
      send_next_question_keyboard unanswered_questions, chat_id
    else
      finish_attempt test_attempt, chat_id
    end
  end

  def send_next_question_keyboard question, chat_id
    text = question.body
    keyboard = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: [],
          one_time_keyboard: true
        )
 
    question.options.each.with_index { |option, index| keyboard.keyboard.append([{ text: "#{index + 1}. #{option}" }])}

    bot.api.send_message(chat_id: chat_id, text: text, reply_markup: keyboard)
  end

  def finish_attempt test_attempt, chat_id
    test_attempt.status = AttemptStatus::COMPLETED
    save_test_attempt test_attempt
    send_attempt_statistics test_attempt, chat_id
    send_test_select_keyboard chat_id
  end

  def send_attempt_statistics test_attempt, chat_id
    statistics = AttemptStatistics.from_attempt test_attempt
    bot.api.send_message(chat_id: chat_id, text: statistics.to_s)
  end

  def get_next_unanswered_question test_attempt
    test_attempt.question_answers.find { |question| question.user_answer == nil }
  end
end
