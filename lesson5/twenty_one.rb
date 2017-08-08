require 'pry'

class Participant
  attr_accessor :hand, :total
  def initialize
    @hand = []
    @total = 0
  end

  def total
    @total = calculate_total
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

  protected

  def values(value)
    case value
    when '2', '3', '4', '5', '6', '7', '8', '9', '10'
      value.to_i
    when 'J', 'Q', 'K'
      10
    when 'A'
      11
    end
  end

  def calculate_total
    total = 0
    hand.each do |card|
      total += values(card.value)
    end
    if total > 21
      number_of_aces = hand.select { |card| card.value == 'A' }.count
      number_of_aces.times do
        total -= 10
        break if total <= 21
      end
    end
    total
  end

  # def separate_aces
  #   no_aces = hand.dup
  #   just_aces = hand.dup
  #   no_aces.delete_if { |card| card.value == 'A' }
  #   just_aces.delete_if { |card| card.value != 'A' }
  #   return just_aces, no_aces
  # end

  # def calculate_total_without_aces
  #   total = 0
  #   just_aces, no_aces = separate_aces
  #   if hand.empty?
  #     calculate_total_with_aces
  #   else
  #     no_aces.each do |card|
  #       total += values(card.value)
  #     end
  #   end
  #   return total, just_aces
  # end

  # def calculate_total_with_aces
  #   total, just_aces = calculate_total_without_aces
  #   unless just_aces.empty?
  #     just_aces.each do |_|
  #       value = if total <= 10
  #                 11
  #               else
  #                 1
  #               end
  #       total += value
  #     end
  #   end
  #   total
  # end

  # def assign_total
  #   calculate_total_with_aces
  # end
end

class Player < Participant
  def show_hand
    puts "Your Hand:"
    super
    puts "Your total is #{total}"
  end
end

class Dealer < Participant
  UNKOWN_CARD = %(
    +-----+
    |?    |
    |     |
    |  ?  |
    |     |
    |    ?|
    +-----+
)

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

  def deal_card_to(player)
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
    @deck = Deck.new
    reset
  end

  def start
    display_welcome_message
    loop do
      main_game_loop
      break unless play_again?
      reset
    end
    display_goodbye_message
  end

  private

  def main_game_loop
    deck.deal_hand(player, dealer)
    dealer.show_hand_initial
    player.show_hand
    player_turn
    wait
    dealer_turn
    dealer.show_hand
    wait
    display_results
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
    sleep 1
  end

  def reset
    system 'clear'
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
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
        deck.deal_card_to(player)
        player.show_hand
      when 's'
        player.stay
      end
      break if move == 's' || player.busted?
    end
  end

  def perform_move_dealer
    deck.deal_card_to(dealer)
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
      break if dealer.total >= 17
      perform_move_dealer
    end
  end

  def determine_winner
    winner = nil
    loop do
      winner = check_for_player_busted
      break unless winner.nil?
      winner = check_for_closest_to_21_total
      break
    end
    winner
  end

  def check_for_player_busted
    if both_busted?
      false
    elsif player.busted?
      dealer
    elsif dealer.busted?
      player
    end
  end

  def check_for_closest_to_21_total
    if totals_are_equal
      false
    elsif player_has_greater_total
      player
    elsif dealer_has_greater_total
      dealer
    end
  end

  def both_busted?
    player.busted? && dealer.busted?
  end

  def totals_are_equal
    player.total == dealer.total
  end

  def player_has_greater_total
    player.total > dealer.total
  end

  def dealer_has_greater_total
    dealer.total > player.total
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
