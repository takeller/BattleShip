class Ship

  attr_reader :length, :name
  def initialize(name, length)
    @name = name
    @length = length
    @health = length
  end

  def health
    @health
  end

end
