class TelegramBot
  TOKEN = '5955642556:AAEUtklOhc3lEHMYKSRy165daqMc68pvkYQ'.freeze

  def run
    bot.listen do |message|
      processMessage(message)
    rescue => e
      puts e.message
    end
   end

 private

 def bot
   Telegram::Bot::Client.run(TOKEN) { |bot| return bot }
 end

 def processMessage

 end
end
