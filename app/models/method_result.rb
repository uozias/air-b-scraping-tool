class MethodResult
  attr_accessor :result, :message, :content

  def initialize
    self.result = false
    self.content = []
    self.message = ''
  end
end