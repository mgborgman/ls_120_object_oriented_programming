# updating code for Rock Paper Scissors to create
# Rock Paper Scissors Lizard Spock
NEW_LINE = "\n\n"

class RPSLSGame
  attr_accessor :player, :computer

  def initialize
    @player = Human.new
    @computer = Computer.new
  end

  def set_score
    player.score = 0
    computer.score = 0
  end

  def show_current_score
    puts "Current score is:"
    puts "#{player.name} has won #{player.score} rounds"
    puts "#{computer.name} has won #{computer.score} rounds#{NEW_LINE}"
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors #{player.name}!#{NEW_LINE}"
  end

  def display_goodbye_message
    puts "Thanks for playing!#{NEW_LINE}"
  end

  def display_choice
    puts "#{player.name} chose #{player.move}"
    puts "#{computer.name} chose #{computer.move}#{NEW_LINE}"
  end

  def determine_round_winner
    if player.move > computer.move
      player
    elsif player.move < computer.move
      computer
    end
  end

  def increase_score
    winner = determine_round_winner
    if winner == player
      player.increase_score
    elsif winner == computer
      computer.increase_score
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
    player.score == 10 || computer.score == 10
  end

  def display_match_winner
    if player.score == 10
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

  def main_game_loop
    loop do
      set_score
      loop do
        player.choose
        computer.choose(player)
        display_choice
        display_round_winner
        increase_score
        show_current_score
        break if match_winner?
      end
      display_match_winner
      break unless play_again?
    end
  end

  def play
    display_welcome_message
    main_game_loop
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
    input = ""
    loop do
      puts "What is your name?"
      input = gets.chomp.strip
      break unless input.empty?
      puts "Must enter a value."
    end
    self.name = input
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
    @history[choice.to_sym] += 1
  end
end

class Computer < Player
  attr_accessor :most_common_move, :rules, :rule

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def find_most_common_move(other_player)
    player_moves = other_player.history
    sorted_player_moves = player_moves.sort_by { |_, count| -count }
    self.most_common_move = sorted_player_moves.shift
  end

  def most_common_move_to_s
    most_common_move[0].to_s
  end

  def choose_most_likely_to_win_move
    case most_common_move_to_s
    when 'rock'
      [Paper.new, Spock.new].sample
    when 'paper'
      [Scissors.new, Lizard.new].sample
    when 'scissors'
      [Rock.new, Spock.new].sample
    when 'lizard'
      [Rock.new, Scissors.new].sample
    when 'spock'
      [Paper.new, Lizard.new].sample
    end
  end

  def invoke_rule?
    rand(1..10) > 4 ? true : false
  end

  def use_rule
    case @name
    when 'R2D2'
      self.move = r2_d2_rule
    when 'Hal'
      self.move = hal_rule
    when 'Chappie'
      self.move = chappie_rule
    when 'Sonny'
      self.move = sonny_rule
    when 'Number 5'
      self.move = number_5_rule
    end
  end

  def r2_d2_rule
    [Rock.new, Lizard.new].sample
  end

  def hal_rule
    [Scissors.new, Rock.new].sample
  end

  def chappie_rule
    [Paper.new, Rock.new].sample
  end

  def sonny_rule
    [Scissors.new, Spock.new].sample
  end

  def number_5_rule
    [Spock.new, Lizard.new].sample
  end

  def choose(other_player)
    if invoke_rule?
      use_rule
    else
      if !other_player.history.nil?
        find_most_common_move(other_player)
        self.move = choose_most_likely_to_win_move
      else
        self.move = [Rock.new, Paper.new, Scissors.new,
                     Lizard.new, Spock.new].sample
      end
      @history[move.value.to_sym] += 1
    end
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  attr_reader :value

  def initialize(value)
    @value = value
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
    other_player.value == 'scissors' ||
      other_player.value == 'lizard'
  end

  def <(other_player)
    other_player.value == 'paper' ||
      other_player.value == 'spock'
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
  end

  def >(other_player)
    other_player.value == 'rock' ||
      other_player.value == 'spock'
  end

  def <(other_player)
    other_player.value == 'scissors' ||
      other_player.value == 'lizard'
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
  end

  def >(other_player)
    other_player.value == 'paper' ||
      other_player.value == 'lizard'
  end

  def <(other_player)
    other_player.value == 'rock' ||
      other_player.value == 'spock'
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
  end

  def >(other_player)
    other_player.value == 'paper' ||
      other_player.value == 'spock'
  end

  def <(other_player)
    other_player.value == 'rock' ||
      other_player.value == 'scissors'
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
  end

  def >(other_player)
    other_player.value == 'rock' ||
      other_player.value == 'scissors'
  end

  def <(other_player)
    other_player.value == 'paper' ||
      other_player.value == 'lizard'
  end
end

RPSLSGame.new.play
