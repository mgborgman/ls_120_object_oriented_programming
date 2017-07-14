require 'pry'
# updating code for Rock Paper Scissors to create
# Rock Paper Scissors Lizard Spock
class RPSLSGame
  attr_accessor :player, :computer, :player_score, :computer_score

  def initialize
    @player = Human.new
    @computer = Computer.new
    @player_score = @player.score
    @computer_score = @computer.score
  end

  def set_score
    self.player_score = 0
    self.computer_score = 0
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

  def determine_round_winner
    if player.move > computer.move
      self.player_score += 1
      player
    elsif player.move < computer.move
      self.computer_score += 1
      computer
    end
  end

  def display_round_winner
    winner = determine_round_winner
    if winner.nil?
      puts "It's a tie"
    else
      puts "#{winner.name} won the round!"
    end
  end

  def match_winner?
    self.player_score == 10 || self.computer_score == 10
  end

  def display_match_winner
    if self.player_score == 10
      puts "#{player.name} won the match!"
    else
      puts "#{computer.name} won the match!"
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
      set_score
      loop do
        player.choose
        computer.choose(player)
        display_choice
        display_round_winner
        break if match_winner?
      end
      display_match_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

class Player
  attr_accessor :move, :name, :score, :history
  def initialize
    @history = { rock: 0, paper: 0, scissors: 0, lizard: 0, spock: 0 }
    set_name
  end

  def increase_score
    self.score += 1
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

  def assign_choice(choice)
    case choice
    when 'rock'
      self.move = Rock.new
    when 'paper'
      self.move = Paper.new
    when 'scissors'
      self.move = Scissors.new
    when 'lizard'
      self.move = Lizard.new
    when 'spock'
      self.move = Spock.new
    end
  end

  def choose
    choice = nil
    loop do
      puts "Choose: Rock, Paper, Scissors, Lizard, or Spock"
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)
      puts "Invalid choice."
    end
    assign_choice(choice)
    history[choice.to_sym] += 1
  end
end

class Computer < Player
  attr_accessor :most_common_move
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def create_most_common_move(other_player)
    player_moves = other_player.history
    sorted_player_moves = player_moves.sort_by { |_, count| -count }
    self.most_common_move = sorted_player_moves.shift
  end

  def set_most_common_move
    case most_common_move[0].to_s
    when 'rock'
      Move.new(%w[paper spock].sample)
    when 'paper'
      Move.new(%w[scissors lizard].sample)
    when 'scissors'
      Move.new(%w[rock spock].sample)
    when 'lizard'
      Move.new(%w[rock scissors].sample)
    when 'spock'
      Move.new(%w[paper lizard].sample)
    end
  end

  def choose(other_player)
    if !other_player.history.nil?
      create_most_common_move(other_player)
      self.move = set_most_common_move
    else
      self.move = Move.new(Move::VALUES.sample)
    end
    history[move.value.to_sym] += 1
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
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

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def to_s
    value
  end
end

class Rock < Move
  def initialize
    @value = 'rock'
  end

  def >(other_player)
    rock? && other_player.scissors? ||
      (rock? && other_player.lizard?)
  end

  def <(other_player)
    rock? && other_player.paper? ||
      (rock? && other_player.spock?)
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
  end

  def >(other_player)
    paper? && other_player.rock? ||
      (paper? && other_player.spock?)
  end

  def <(other_player)
    paper? && other_player.scissors? ||
      (paper? && other_player.lizard?)
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
  end

  def >(other_player)
    scissors? && other_player.paper? ||
      (scissors? && other_player.lizard?)
  end

  def <(other_player)
    scissors? && other_player.rock? ||
      (scissors? && other_player.spock?)
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
  end

  def >(other_player)
    lizard? && other_player.paper? ||
      (lizard? && other_player.spock?)
  end

  def <(other_player)
    lizard? && other_player.rock? ||
      (lizard? && other_player.scissors?)
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
  end

  def >(other_player)
    spock? && other_player.rock? ||
      (spock? && other_player.scissors?)
  end

  def <(other_player)
    spock? && other_player.paper? ||
      (spock? && other_player.lizard?)
  end
end

RPSLSGame.new.play
