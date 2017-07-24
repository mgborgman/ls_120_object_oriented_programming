module Moveable
  def walk
    puts "#{self} #{gait} forward"
  end
end

class Person
  attr_reader :name
  include Moveable
  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  private
  
  def gait
    "strolls"
  end
end

class Cat
  include Moveable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  include Moveable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  private
  
  def gait
    "runs"
  end
end

class Noble
  include Moveable
  attr_accessor :name, :title

  def initialize(name, title)
    @name = name
    @title = title
  end

  def to_s
    "#{title} #{name}"
  end

  def gait
    "struts"
  end
end


mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"

byron = Noble.new("byron", "Lord")
byron.walk