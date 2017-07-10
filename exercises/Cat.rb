module Walkable
    def walk
        puts "Let's go for a walk!"
    end
end


class Cat
    # include module
    include Walkable
    #attr_reader :name prefered for getter methods
    #attr_writer :name prefered for setter methods
    attr_accessor :name #prefered for both
    def initialize(name)
        @name = name
    end
    # # getter method
    # def name
    #     @name
    # end
    # # setter method
    # def name=(name)
    #     @name = name
    # end
    # greet method
    def greet
        puts "Hello! My name is #{name}!"
    end
end

kitty = Cat.new("Sophie")
kitty.greet
kitty.walk