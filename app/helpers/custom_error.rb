class CustomError < StandardError
  def initialize(message, code)
    super(message)
    @code = code
  end
  attr_reader :code
end
