require 'pry'

class Participant
  attr_accessor :hand, :total
  def initialize
    @hand = []
    @total = 0
  end

  def total
    @total = assign_total
  end

  def stay
    true
  end

  def busted?
    total > 21
  end

  def show_hand
    hand.each(&:to_s)
  end

  def values(value)
    case value
    when '2', '3', '4', '5', '6', '7', '8', '9', '10'
      value.to_i
    when 'J', 'Q', 'K'
      10
    end
  end

  def separate_aces
    index = 0
    aces = []
    while index < hand.length
      if hand[index].value == 'A'
        aces << hand[index]
        hand.delete_at(index)
      end
      index += 1
    end
    aces
  end

  def calculate_total_without_aces
    total = 0
    index = 0
    aces = separate_aces
    while index < hand.length
      total += values(hand[index].value)
      index += 1
    end
    return aces, total
  end

  def add_aces_back_to_hand(aces)
    aces.each do |card|
      self.hand << card
    end
  end

  def calculate_total_with_aces
    index = 0
    aces, total = calculate_total_without_aces
    unless aces.empty?
      while index < aces.length
        value = if total <= 10
                  11
                else
                  1
                end
        total += value
        index += 1
      end     
    end
    add_aces_back_to_hand(aces)
    #binding.pry
    total
  end

  def assign_total
    calculate_total_with_aces
  end
end

class Player < Participant
  def show_hand
    puts "Your Hand:"
    super
    puts "Your total is #{total}"
  end
end

class Dealer < Participant
  UNKOWN_CARD = """
    +-----+
    |?    |
    |     |
    |  ?  |
    |     |
    |    ?|
    +-----+
    """

  attr_reader :deck

  def initialize
    @deck = Deck.new
    super
  end

  def show_hand_initial
    puts "Dealers Hand:"
    hand[0].to_s
    puts UNKOWN_CARD
  end

  def show_hand
    puts "Dealers Hand:"
    super
    puts "Dealers total is #{total}"
  end
end

class Deck
  SUITS = ['C', 'D', 'H', 'S']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  attr_accessor :cards

  def initialize
    @cards = []
    @test = 'Hello'
    reset_deck
  end

  def shuffle
    cards.shuffle!
  end

  def deal_hand(player1, player2)
    shuffle
    2.times do
      player1.hand << cards.shift
      player2.hand << cards.shift
    end
  end

  def deal_card(player)
    player.hand << cards.shift
  end

  def reset_deck
    SUITS.each do |suit|
      VALUES.each do |value|
        @cards << Card.new(suit, value)
      end
    end
  end
end

class Card
  attr_reader :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    print """
    +-----+
    |#{@value}    |
    |     |
    |  #{@suit}  |
    |     |
    |    #{@value}|
    +-----+
    """
  end
end

class Game
  attr_reader :player, :dealer, :deck
  def initialize
    reset
  end

  def start
    display_welcome_message
    loop do
      dealer.deck.deal_hand(player, dealer)
      dealer.show_hand_initial
      player.show_hand
      player_turn
      wait
      dealer_turn
      dealer.show_hand
      wait
      display_results
      break unless play_again?
      reset
    end
    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to Twenty One!"
  end

  def display_goodbye_message
    puts "Thanks for playing Twenty One!"
  end

  def play_again?
    answer = nil
    loop do
      puts "would you like to play again? (y/n)"
      answer = gets.chomp.strip.downcase
      break if %w[y n].include?(answer)
      puts "Please answer y or n"
    end
    answer == 'y'
  end

  def wait
    system 'sleep 1'
  end

  def reset
    system 'clear'
    @player = Player.new
    @dealer = Dealer.new
  end

  def prompt_for_move
    move = nil
    loop do
      puts "would you like to (H)it or (S)tay?"
      move = gets.chomp.strip.downcase
      break if %w[h s].include?(move)
      puts "Please enter h or s."
    end
    move
  end

  def perform_move_player
    loop do
      move = prompt_for_move
      case move
      when 'h'
        dealer.deck.deal_card(player)
        player.show_hand
      when 's'
        player.stay
      end
      break if move == 's' || player.busted?
    end
  end

  def perform_move_dealer
    dealer.deck.deal_card(dealer)
  end

  def player_turn
    loop do
      break if player.busted?
      perform_move_player
      break if player.stay
    end
  end

  def dealer_turn
    loop do
      break if dealer.total == 21
      break if dealer.total >= 17
      perform_move_dealer
    end
  end

  def determine_winner
    if player.busted? && dealer.busted?
      false
    elsif player.busted?
      dealer
    elsif dealer.busted?
      player
    elsif player.total == dealer.total
      false
    elsif player.total > dealer.total
      player
    elsif dealer.total > player.total
      dealer
    end
  end

  def display_results
    winner = determine_winner
    case winner
    when player
      puts "You Won!"
    when dealer
      puts "The House Won."
    when false
      puts "It's a Tie."
    end
    puts "Your total: #{player.total}  Dealer Total: #{dealer.total}"
  end
end

game = Game.new
game.start
