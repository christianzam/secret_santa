class Customer
  attr_accessor :id
  attr_reader :name, :birthday, :notes

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @birthday = attributes[:birthday]
    @notes = attributes[:notes]
  end
end
