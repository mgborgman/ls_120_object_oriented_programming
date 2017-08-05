require 'pry'

class Participant 
  attr_accessor :hand, :total
  def initialize
    @hand = []
    @total = calculate_total
  end

  def total
    @total = calculate_total
  end

  # def hit

  # end

  def stay
    true
  end

  def busted?
    #total = calculate_total
    total > 21
  end

  def show_hand
    #binding.pry
    hand.each do |card|
      "#{card}"
    end
  end

  def values(value)
    case value
    when '2'
      2
    when '3'
      3
    when '4'
      4
    when '5'
      5
    when '6'
      6
    when '7'
      7
    when '8'
      8
    when '9'
      9
    when '10'
      10
    when 'J'
      10
    when 'Q'
      10
    when 'K'
      10
    when 'A'
      if self.total <= 21
        11
      else
        1
      end
    end
  end

  def calculate_total
    total = 0
    index = 0
    while index < hand.length
      if hand[index].value == 'A'
        if total <= 10
          value = 11
        else
          value = 1
        end
      else
        value = values(hand[index].value)
      end
      total += value
      index += 1
    end
    self.total = total
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
  attr_reader :deck

  def initialize
    @deck = Deck.new
    super
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
    SUITS.each do |suit|
      VALUES.each do |value|
        @cards << Card.new(suit, value)
      end
    end
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
    @player = Player.new
    @dealer = Dealer.new
    #@deck = Deck.new
  end

  def start
    dealer.deck.deal_hand(player, dealer)
    dealer.show_hand
    player.show_hand
    player_turn
    dealer_turn
    dealer.show_hand
    display_results
  end

  def prompt_for_move
    move = nil
    loop do
      puts "would you like to (H)it or (S)tay?"
      move = gets.chomp.strip.downcase
      break if %w[h s].include?(move)
      puts "Please enter 'h' or 's'."
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

