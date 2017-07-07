class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    full_name = name.split(' ')
    @first_name = full_name.first
    @last_name = full_name.size > 1 ? full_name.last : ''
  end

  def name=(name)
    full_name = name.split(' ')
    self.first_name = full_name.first
    self.last_name = full_name.size > 1 ? full_name.last : ''
  end

  def name
    self.first_name + ' ' + self.last_name
  end

end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'

