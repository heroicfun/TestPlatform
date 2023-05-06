class QuestionAnswer
  attr_accessor :id, :test_id, :body, :correct_answer, :user_answer

  def initialize(question)
    @body = question.body
    @correct_answer = question.answer
    @user_answer = nil
  end

  def is_correct?
    @correct_answer == @user_answer
  end

  def self.from_h(h)
    answer = self.new()

    answer.id = h['id']
    answer.test_id = h['test_id']
    answer.body = h['body']
    answer.correct_answer = h['correct_answer']
    answer.user_answer = h['user_answer']

    answer
  end

  def to_h
    {
      id: @id,
      test_id: @test_id,
      body: @body,
      options: @correct_answer,
      answer: @user_answer
    }
  end
end
