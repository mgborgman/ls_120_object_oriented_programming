require 'pry'

class Participant
  attr_accessor :hand
  def initialize
    @hand = []
  end

  def hit
    puts "this is a hit"
  end

  def stay
  end

  def busted?
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
      if total + 11 <= 21
        11
      else
        1
      end
    end
  end

  def total
    total = 0
    index = 0
    while index <= hand.length
      temp = values(hand[index].value)
      total += temp
      index += 1
    end
    total
  end
end

class Player < Participant
  def check_hand
    puts "Your Hand:"
    "#{hand[0]} #{hand[1]}"
    puts "Your total is #{total}"
  end
end

class Dealer < Participant
  def show_hand
    puts "Dealers Hand:"
    "#{hand[0]}"
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
    puts "+-----+"
    puts "|#{@value}    |"
    puts "|     |"
    puts "|  #{@suit}  |"
    puts "|     |"
    puts "|    #{@value}|"
    puts "+-----+"
  end
end

class Game
  attr_reader :player, :dealer, :deck
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start
    deck.deal_hand(player, dealer)
    player.check_hand
    dealer.show_hand
    # player_turn
    # dealer_turn
    # show_result
  end
end

game = Game.new
game.start

