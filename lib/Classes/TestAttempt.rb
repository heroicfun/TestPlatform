class TestAttempt
  attr_accessor :id, :start_time, :user_name, :test_id, :test_name, :status, :question_answers

  def initialize(user_name, test)
    @id = SecureRandom.uuid.to_s
    @start_time = Time.now.utc
    @user_name = user_name
    @test_id = test.id
    @test_name = test.name
    @status = AttemptStatus::STARTED
    @question_answers = []
    test.questions.each do |question|
      @question_answers.append QuestionAnswer.new question
    end
  end
  
  def self.from_h(h)
    attempt = self.new()
    
    attempt.id = h['id']
    attempt.start_time = Time.at h['start_time']
    attempt.user_name = h['user_name']
    attempt.test_id = h['test_id']
    attempt.test_name = h['test_name']
    attempt.status = h['status']
    attempt.question_answers = h['question_answers'].map { |answer| QuestionAnswer.from_h(answer) }

    attempt
  end

  def to_h
    {
      id: @id,
      start_time: @start_time.to_i,
      user_name: @user_name,
      test_id: @test_id,
      test_name: @test_name,
      status: @status,
      question_answers: @question_answers.map { |answer| answer.to_h },
    }
  end
end

module AttemptStatus
  STARTED = 0
  COMPLETED = 1
end
