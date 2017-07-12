# the user makes a choice
# the computer makes a choice
# the winner is displayed

# Write a textual description of the problem or exercise.
# User is asked to choose rock, paper, or scissors
# computer chooses rock, paper, or scissors
# Users choice is compared with computers choice
# winner is displayed

# Extract the major nouns and verbs from the description.
# Player
# move
# rule

# choose
# compare

# Organize and associate the verbs with the nouns.
# Player
# - choose
# move
# rule

# -compare

# The nouns are the classes and the verbs are the behaviors or methods.

class RPSGame
  attr_accessor :player, :computer

  def initialize
    @player = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors #{player.name}!"
  end

  def display_goodbye_message
    puts "Thanks for playing!"
  end

  def display_choice
    puts "#{player.name} chose #{player.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if player.move > computer.move
      puts "#{player.name} won!"
    elsif player.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie."
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %(y n).include?(answer)
      puts "Invalid entry. Must be y or n."
    end
    return true if answer == 'y'
    false
  end

  def play
    display_welcome_message
    loop do
      player.choose
      computer.choose
      display_choice
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

class Player
  attr_accessor :move, :name
  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What is your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Must enter a value."
    end
    self.name = n
  end

  def choose
    puts "Choose: Rock, Paper, or scissors"
    choice = nil
    loop do
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)
      puts "Invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def >(other_player)
    rock? && other_player.scissors? ||
      (paper? && other_player.rock?) ||
      (scissors? && other_player.paper?)
  end

  def <(other_player)
    rock? && other_player.paper? ||
      (paper? && other_player.scissors?) ||
      (scissors? && other_player.rock?)
  end

  def to_s
    value
  end
end

RPSGame.new.play


# find_winner = Rule.new
# player.player_choose
# computer.computer_choose
# find_winner.compare(player.move.to_s, computer.move.to_s)
