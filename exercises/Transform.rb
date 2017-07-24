class Transform
  def initialize(value)
    @value = value
  end

  def uppercase
    @value.upcase
  end

  def self.lowercase(value)
    value.downcase
  end

  def to_s
    @value
  end
end 


my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')

# ABC
# xyz