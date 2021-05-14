class Idea
  attr_accessor :id, :name, :bought
  attr_reader :price

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @price = attributes[:price]
    @bought = attributes[:bought] || false
  end
end
