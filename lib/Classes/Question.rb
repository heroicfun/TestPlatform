class Question
  attr_accessor :id, :test_id, :body, :options, :answer

  def initialize
    @id = SecureRandom.uuid.to_s
    @test_id = '',
    @body = '',
    @options = [],
    @answer = 0
  end

  def self.from_h(h)
    question = self.new()

    question.id = h['id']
    question.test_id = h['test_id']
    question.body = h['body']
    question.options = h['options']
    question.answer = h['answer']

    question
  end

  def to_h
    {
      id: @id,
      test_id: @test_id,
      body: @body,
      options: @options,
      answer: @answer
    }
  end
end
