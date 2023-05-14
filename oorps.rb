class Move
  VALUES = %w(rock paper scissors lizard spock)
  WINNING_MOVES = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['paper', 'spock'],
    'spock' => ['rock', 'scissors']
  }

  def initialize(value)
    @value = value
  end

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

class Player
  attr_accessor :move, :name, :score

  def initialize
    @score = 0
    set_name
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
      puts "Please choose one: #{Move::VALUES.join(', ')}"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, that's not a valid choice."
    end
    self.move = Move.new(choice)
    system 'clear'
  end
end

class Computer < Player
  def set_name
    name = ''
    loop do
      puts "Please choose a droid to play against: R2D2, C3PO, BB8, K2SO, or " \
      "B2EMO."
      name = gets.chomp
      break if %w(R2D2 C3PO BB8 K2SO B2EMO).include?(name.upcase)
      puts "Sorry, that's not a valid choice."
    end
    self.name = name.upcase
    # self.name = %w(R2D2 C3PO BB8 K2SO B2EMO).sample
  end

  def choose
    case self.name
    when 'R2D2'
      self.move = Move.new(Move::VALUES.sample)
    when 'C3PO'
      self.move = Move.new('rock')
    when 'BB8'
      self.move = Move.new(%w(lizard lizard lizard paper lizard paper).sample)
    when 'K2SO'
      self.move = Move.new(%w(rock paper lizard spock).sample)
    when 'B2EMO'
      self.move = Move.new(%w(rock rock rock rock paper scissors lizard).sample)
    end
  end
end

class RPSGame
  WINNING_SCORE = 3

  attr_accessor :human, :computer, :player_moves

  def initialize
    @human = Human.new
    @computer = Computer.new
    @player_moves = {
      human => [],
      computer => []
    }
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

  def display_move_history
    player_moves.each do |player, moves|
      puts "#{player.name} has played: #{moves.join(', ')}"
    end
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

  def reset_move_history
    self.player_moves = {
      human => [],
      computer => []
    }
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
        player_moves[human] << human.move.to_s
        computer.choose
        player_moves[computer] << computer.move.to_s
        display_moves
        display_winner
        add_scores
        display_score
        display_move_history
        break champion if grand_champion?
      end

      human.reset_wins
      computer.reset_wins
      break unless play_again?
    end

    reset_move_history
    display_goodbye_message
  end
end

RPSGame.new.play
