class CheckersGame
  game = Board.new

  def populate_board
    game.board #the four rows get updated
  end
end

class Piece
  attr_reader :player, :position

  MOVES = [[-1, 1], [1, 1]]
  JUMPS = [[-2, 2], [2, 2]]

  def initialize(player)
    @player = player
    @position = nil
  end

  def slide
  end

  def jump
  end
end

class King < Piece
  KING_MOVES = [[-1, 1], [1, 1],
      [-1, -1], [1, -1]]
  KING_JUMPS = [[-2, 2], [2, 2],
      [-2, -2], [2, -2]]
end

class Board
  def initialize
    @board = Hash.new

    (0..7).each do |row|
      (0..7).each do |col|
        board[[row,col]] = nil
      end
    end
  end

  def which_piece(pos)

    #return player and type
  end


end

class Player
  def initialize
    @pieces = []

  end
end