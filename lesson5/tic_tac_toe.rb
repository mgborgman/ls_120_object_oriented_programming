require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def chance_of_losing?
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_markers?(squares)
        return line
      end
    end
    nil
  end

  def find_empty_square
    squares = chance_of_losing?
    squares.select { |square| @squares[square].unmarked? }
  end

  def someone_won?
    !!winning_marker
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}" \
         "  |  #{@squares[3]}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}" \
         "  |  #{@squares[6]}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}" \
         "  |  #{@squares[9]}  "
    puts "     |     |"
  end



  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

def two_identical_markers?(squares)
  markers = squares.select(&:marked?).collect(&:marker)
  return false if markers.size != 2
  markers.min == markers.max
end

class Square
  attr_accessor :marker

  INITAIL_MARKER = ' '

  def initialize(marker=INITAIL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    @marker != INITAIL_MARKER
  end

  def unmarked?
    @marker == INITAIL_MARKER
  end
end

class Player
  attr_reader :marker
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = HUMAN_MARKER
  attr_reader :board, :human, :computer
  attr_accessor :current_marker

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def increment_score(marker)
    if human.marker == marker
      human.score += 1
    elsif computer.marker == marker
      computer.score += 1
    end
  end

  def play
    clear
    display_welcome_message
    loop do
      loop do
        display_board
        loop do
          current_player_moves
          clear_screen_and_display_board
          break if board.someone_won? || board.full?
        end
        #display_round_results
        increment_score(board.winning_marker)
        break if human.score == 5 || computer.score == 5
        reset
      end
      display_match_results
      break unless play_again?
      display_play_again_message
      reset
      set_score_back_to_zero
    end
    display_goodbye_message
  end

  private

  def joinor(array, separator=', ', conjunction='or ')
    array.map! { |item| item.to_s }
    last_array_item = array.last
    last_array_item = conjunction + last_array_item
    array[-1] = last_array_item
    array.join(separator)
  end

  def prompt_for_human_move
    square = nil
    loop do
      puts "Choose a square #{joinor(board.unmarked_keys)}"
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Invalid, Choice must be #{joinor(board.unmarked_keys)}"
    end
    square
  end

  def human_moves
    square = prompt_for_human_move
    board[square] = human.marker
  end

  def human_turn?
    self.current_marker == HUMAN_MARKER
  end

  def computer_moves
    if board.chance_of_losing?
      square = board.find_empty_square
      board[square.first] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      self.current_marker = COMPUTER_MARKER
    else
      computer_moves
      self.current_marker = HUMAN_MARKER
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!\n\n"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe!\n\n"
  end

  def display_play_again_message
    puts "Let's play again!\n\n"
  end

  def display_round_results
    if board.full?
      puts "Its a Tie."
    elsif board.winning_marker == HUMAN_MARKER
      puts "You Won the Round!"
    elsif board.winning_marker == COMPUTER_MARKER
      puts "Computer Won the Round!"
    end
  end

  def display_match_results
    if human.score == 5
      puts "You Won the Match!"
    else
      puts "Computer Won the Match!"
    end
  end

  def clear
    system 'clear'
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Invalid, please enter y or n"
    end
    answer == 'y'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def reset
    board.reset
    clear
    @current_marker = FIRST_TO_MOVE
  end

  def set_score_back_to_zero
    human.score = 0
    computer.score = 0
  end

  def display_board
    puts "You are: #{HUMAN_MARKER}  Computer is: #{COMPUTER_MARKER}\n\n"
    board.draw

    puts "player: #{human.score}  computer: #{computer.score}"
  end
end

game = TTTGame.new
game.play
