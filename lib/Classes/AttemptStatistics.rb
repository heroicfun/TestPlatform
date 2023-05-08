class AttemptStatistics
  attr_accessor :correct_answer_count, :incorrect_answer_count

  def initialize
    @correct_answer_count = 0
    @incorrect_answer_count = 0
  end
  
  def show
    puts "Attemp statistics:"
    puts "  Correct answer count - #{@correct_answer_count}"
    puts "  Incorrect answer count - #{@incorrect_answer_count}"
    puts "  Correct answers percentage - %.000f%%" % [(@correct_answer_count * 100) / (@correct_answer_count + @incorrect_answer_count)]
  end
end
