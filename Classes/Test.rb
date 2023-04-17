require 'securerandom'

class Test
  attr_accessor :id, :name, :questions

  def initialize()
    @id = SecureRandom.uuid.to_s
    @name = ''
    @questions = []
  end

  def from_h(h)
    test = self.new()
    
    test.id = h[:id]
    test.name = h[:name]
    test.questions = h[:questions]

    test
  end

  def to_h
    {
      id: @id,
      name: @name,
      questions: @questions.to_h {|question| [question.body, question.to_h] },
    }
  end

  def append(question)
    @questions.append(question)
  end

  def find(question_name)
    @questions.find { |question| question.name == question_name }
  end

  def remove(question_name)
    @questions.delete_if { |question| question.name == question_name }
  end
end