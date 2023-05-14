class AttemptStatistics
  attr_accessor :correct_answer_count, :incorrect_answer_count

  def initialize
    @correct_answer_count = 0
    @incorrect_answer_count = 0
  end

  def self.from_attempt test_attempt
    statistics = self.new()

    test_attempt.question_answers.each { |answer| answer.is_correct? ? statistics.correct_answer_count +=1 : statistics.incorrect_answer_count += 1 }

    statistics
  end
  
  def show
    puts "The test is complete:"
    puts "  - Correct answer count - #{@correct_answer_count}"
    puts "  - Incorrect answer count - #{@incorrect_answer_count}"
    puts "  - Correct answers percentage - %.000f%%" % [(@correct_answer_count * 100) / (@correct_answer_count + @incorrect_answer_count)]
  end

  def to_s
    return "The test is complete:\n" +
           "  - Correct answer count - #{@correct_answer_count}\n" +
           "  - Incorrect answer count - #{@incorrect_answer_count}\n" +
           "  - Correct answers percentage - %.000f%%" % [(@correct_answer_count * 100) / (@correct_answer_count + @incorrect_answer_count)]
  end
end
