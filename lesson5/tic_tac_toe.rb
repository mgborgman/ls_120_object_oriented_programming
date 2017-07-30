require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    squares[num].marker = marker
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = self.squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def chance_of_winning?
    WINNING_LINES.each do |line|
      squares = self.squares.values_at(*line)
      if two_identical_markers?(squares, TTTGame::COMPUTER_MARKER)
        return line
      end
    end
    nil
  end

  def find_empty_square(squares)
    squares.select { |square| self.squares[square].unmarked? }
  end

  def someone_won?
    !!winning_marker
  end

  def reset
    (1..9).each { |key| squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}" \
         "  |  #{squares[3]}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}" \
         "  |  #{squares[6]}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[7]}  |  #{squares[8]}" \
         "  |  #{squares[9]}  "
    puts "     |     |"
  end

  def two_identical_markers?(squares, marker)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 2
    markers.min == marker && markers.max == marker
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
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
  attr_accessor :score, :marker

  def initialize(marker='X')
    @marker = marker
    @score = 0
  end

  def choose_marker
    marker = nil
    loop do
      puts "Please enter a single letter or character for your marker: "
      puts "Ex. 'X' or '1'"
      marker = gets.chomp.strip.upcase
      if marker == 'O'
        puts "Computer has already chosen 'O'" 
        next
      end
      break unless marker.length > 1 || marker.empty?
      puts "marker must be a single character"
    end
    self.marker = marker
  end
end

class TTTGame
  COMPUTER_MARKER = 'O'

  attr_reader :board, :human, :computer
  attr_accessor :current_marker

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker
  end

  def increment_score(marker)
    if human.marker == marker
      human.score += 1
    elsif computer.marker == marker
      computer.score += 1
    end
  end

  def chance_of_losing?
    Board::WINNING_LINES.each do |line|
      squares = board.squares.values_at(*line)
      if board.two_identical_markers?(squares, human.marker)
        return line
      end
    end
    nil
  end  

  def play
    clear
    display_welcome_message
    human.choose_marker
    current_marker = human.marker
    loop do
      loop do
        display_board
        loop do
          current_player_moves
          clear_screen_and_display_board
          #wait
          break if board.someone_won? || board.full?
        end
        display_round_results
        wait
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
    wait
  end

  private

  def joinor(array, separator=', ', conjunction='or ')
    array.map! { |item| item.to_s }
    last_array_item = array.last
    last_array_item = conjunction + last_array_item
    array[-1] = last_array_item
    array.join(separator)
  end

  def wait
    system 'sleep 1.5'
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
    binding.pry
    current_marker == human.marker
  end

  def computer_moves
    if board.chance_of_winning?
      square = board.find_empty_square(board.chance_of_winning?)
      board[square.first] = computer.marker
    elsif chance_of_losing?
      square = board.find_empty_square(chance_of_losing?)
      board[square.first] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      current_marker = COMPUTER_MARKER
    else
      computer_moves
      current_marker = human.marker
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
    elsif board.winning_marker == human.marker
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
    current_marker = human.marker
  end

  def set_score_back_to_zero
    human.score = 0
    computer.score = 0
  end

  def display_board
    puts "You are: #{human.marker}  Computer is: #{COMPUTER_MARKER}\n\n"
    board.draw

    puts "player: #{human.score}  computer: #{computer.score}"
  end
end

game = TTTGame.new
game.play
