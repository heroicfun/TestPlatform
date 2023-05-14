class QuestionAnswer
  attr_accessor :id, :test_id, :body, :options, :correct_answer, :user_answer

  def self.from_question(question)
    answer = self.new()
    
    answer.body = question.body
    answer.options = question.options
    answer.correct_answer = question.options[question.answer]
    answer.user_answer = nil

    answer
  end

  def is_correct?
    @correct_answer == @user_answer
  end

  def self.from_h(h)
    answer = self.new()

    answer.id = h['id']
    answer.test_id = h['test_id']
    answer.body = h['body']
    answer.options = h['options']
    answer.correct_answer = h['correct_answer']
    answer.user_answer = h['user_answer']

    answer
  end

  def to_h
    {
      body: @body,
      options: @options,
      correct_answer: @correct_answer,
      user_answer: @user_answer
    }
  end
end
