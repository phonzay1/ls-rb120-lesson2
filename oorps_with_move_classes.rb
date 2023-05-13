class Move
  VALUES = %w(rock paper scissors lizard spock)
  WINNING_MOVES = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['paper', 'spock'],
    'spock' => ['rock', 'scissors']
  }

  def to_s
    value
  end

  def >(other_move)
    WINNING_MOVES[value].include?(other_move.value)
  end

  def <(other_move)
    WINNING_MOVES.any? do |winner, losers|
      losers.include?(value) && other_move.value == winner
    end
  end

  protected

  attr_reader :value
end

class Rock < Move
  def initialize
    @value = 'rock'
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    @score = 0
    set_name
  end

  def instantiate_move_obj(move_value)
    case move_value
    when 'rock' then Rock.new
    when 'paper' then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard' then Lizard.new
    when 'spock' then Spock.new
    end
  end

  def reset_wins
    self.score = 0
  end
end

class Human < Player
  def set_name
    puts "What's your name?"
    human_name = ''
    loop do
      human_name = gets.chomp
      break unless human_name.empty?
      puts "Sorry, must enter a value"
    end
    self.name = human_name
  end

  def choose
    choice = nil
    loop do
      puts "Please choose one: #{Move::VALUES}"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, that's not a valid choice."
    end
    self.move = instantiate_move_obj(choice)
    system 'clear'
  end
end

class Computer < Player
  def set_name
    self.name = %w(R2D2 C3PO BB8).sample
  end

  def choose
    self.move = instantiate_move_obj(Move::VALUES.sample)
  end
end

class RPSGame
  WINNING_SCORE = 3

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to the Rock, Paper, Scissors, Lizard, Spock game! First " \
    "player to #{WINNING_SCORE} wins is the grand champion."
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def add_scores
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def display_score
    puts "#{human.name} has #{human.score} wins."
    puts "#{computer.name} has #{computer.score} wins."
  end

  def grand_champion?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def champion
    puts "Congratulations! You have #{human.score} wins - the grand champion" \
    " is #{human.name}!" if human.score >= WINNING_SCORE
    puts "#{computer.name} has #{computer.score} wins - it's the grand " \
    "champion. Better luck next time, human!" if computer.score >= WINNING_SCORE
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock - goodbye!"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y or n)"
      answer = gets.chomp
      break if %w(y n).include?(answer.downcase)
      puts "Sorry, answer must be y or n"
    end

    answer.downcase == 'y'
  end

  def play
    loop do
      display_welcome_message

      loop do
        human.choose
        computer.choose
        display_moves
        display_winner
        add_scores
        display_score
        break champion if grand_champion?
      end

      human.reset_wins
      computer.reset_wins
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
