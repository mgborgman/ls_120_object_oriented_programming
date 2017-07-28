# class Example
#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end
  
#   def say_hello
#     puts "My name is #{name}"
#   end
# end

class Example
  attr_writer :name
  attr_reader :name
  
  def say_hello
    name = "Jeff"
    self.name + " " + name
  end
end

# class Example
  
#   def initialize(name)
#     @name = name
#   end  
  
#   def say_hello
#     puts "My name is #{@name}"
#   end
# end

hello = Example.new
hello.name = "Matt"
p hello.say_hello