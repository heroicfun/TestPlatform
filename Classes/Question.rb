require_relative 'Dependencies'

class Question
  attr_accessor :test_id, :question, :options, :answer

  def initialize()
    @test_id = '',
    @question = '',
    @options = [],
    @answer = []
  end

  def from_h(h)
    question = self.new()

    question.test_id = h[:test_id]
    question.question = h[:question]
    question.options = h[:options]
    question.answer = h[:answer]

    question
  end

  def to_h
    {
      test_id: @test_id,
      question: @question,
      options: @options,
      answer: @answer
    }
  end
end