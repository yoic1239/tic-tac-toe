# Build a tic-tac-toe game on the command line where two human players can play against each other
# and the board is displayed in between turns.
class GameBoard
  def initialize
    @board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end

  def display
    @board.each_with_index do |row, index|
      puts " #{row[0]} | #{row[1]} | #{row[2]} "
      puts '---+---+---' if index != @board.length - 1
    end
  end

  def valid_position?(position)
    position.between?(1, 9)
  end

  def available_space?(position)
    position -= 1
    @board[position / 3][position % 3].instance_of?(Integer)
  end

  def mark_space(position, mark)
    position -= 1
    @board[position / 3][position % 3] = mark
  end

  def full?
    @board.flatten.none?(Integer)
  end

  def horizontal_line?
    @board.any? { |row| row.all?('O') || row.all?('X') }
  end

  def vertical_line?
    @board.transpose.any? { |col| col.all?('O') || col.all?('X') }
  end

  def diagonal?
    left_diagonal = [@board.dig(0, 0), @board.dig(1, 1), @board.dig(2, 2)]
    right_diagonal = [@board.dig(0, 2), @board.dig(1, 1), @board.dig(2, 0)]
    left_diagonal.all?('O') || left_diagonal.all?('X') || right_diagonal.all?('O') || right_diagonal.all?('X')
  end
end

class Game
  def initialize
    @board = GameBoard.new

    print "Enter Player 1's name: "
    @player1 = Player.new('O')

    print "Enter Player 2's name: "
    @player2 = Player.new('X')

    @curr_player = @player1

    puts "Hi, #{@player1.name} and #{@player2.name}!"
    puts 'Use method .play to start the game!'
  end

  def play
    loop do
      each_turn
      break if game_over?

      @curr_player = @curr_player == @player1 ? @player2 : @player1
    end
    puts ''
    @board.display
    puts result
  end

  protected

  def each_turn
    puts ''
    puts "It's #{@curr_player.name}'s turn."
    @board.display
    @board.mark_space(select_position, @curr_player.mark)
  end

  def select_position
    loop do
      print "Select where to place your sign (#{@curr_player.mark}): "
      position = gets.chomp.to_i
      return position if @board.valid_position?(position) && @board.available_space?(position)

      puts 'Invalid position. Please try again.'
    end
  end

  def game_over?
    @board.full? || @board.horizontal_line? || @board.vertical_line? || @board.diagonal?
  end

  def result
    @board.full? ? 'Draw!' : "#{@curr_player.name} wins!"
  end
end

# Store the player's name and mark (O/X)
class Player
  attr_reader :name, :mark

  def initialize(mark)
    @name = gets.chomp
    @mark = mark
  end
end

game = Game.new
game.play
