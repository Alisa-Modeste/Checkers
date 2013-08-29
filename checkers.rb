class CheckersGame
  players = [ Player.new, Player.new ]
  game = Board.new(players)



end

class Board
  def initialize(players)
    @board = Hash.new
    @players = players

    (0..7).each do |row|
      (0..7).each do |col|
        board[[row,col]] = nil
      end
    end
  end

  def which_piece(pos)

    #return player and type
  end

  def populate_board

    #the four rows get updated
    board.players.each do |player|
      rows = player == board.players[0] ? (0..1) : (6..7)
      rows.each do |row|
        (0..7).each do |col|

      player.pieces.each do |piece|
        piece.position = [row, col]
        board[row, col] = piece
      end
    end

  end

end

class Player
  def initialize
    @pieces = []

    create_pieces
  end

  def create_pieces
    12.times { pieces << Piece.new(self) }
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