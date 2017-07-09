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
    @player = Player.new
    @computer = Player.new(:computer)
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing!"
  end

  def display_winner
    if player.move == 'rock' && computer.move == 'scissors' ||
       player.move == 'scissors' && computer.move == 'paper' ||
       player.move == 'paper' && computer.move == 'rock'

       puts "You Win!"
    elsif computer.move == 'rock' && player.move == 'scissors' ||
          computer.move == 'scissors' && player.move == 'paper' ||
          computer.move == 'paper' && player.move == 'rock'
        puts "Computer Wins!"
    else
        puts "Its a Tie."
    end
  end

  def play
    display_welcome_message
    player.choose
    computer.choose
    display_winner
    display_goodbye_message
  end
end

class Player
  attr_accessor :move
  attr_reader :player_type
  def initialize(player_type=:human)
    @player_type = player_type
    @move = nil
  end

  def human?
    self.player_type == :human
  end

  def choose
    if human?
      puts "Choose: Rock, Paper, or scissors"
      choice = nil
      loop do
        choice = gets.chomp.downcase
        break if %w(rock paper scissors).include?(choice)
        puts "Invalid choice."
      end
      self.move = choice
      
    else
      self.move = %w(rock paper scissors).sample
    end
  end
end

# class Move
#   attr_reader :move
#   def initialize(move)
#     @move = move
#   end

#   def to_s
#     self.move
#   end

# end

RPSGame.new.play

# find_winner = Rule.new
# player.player_choose
# computer.computer_choose
# find_winner.compare(player.move.to_s, computer.move.to_s)





