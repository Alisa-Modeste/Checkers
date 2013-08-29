class Piece
#  attr_reader :position
  attr_accessor :player, :position

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

class Player
  attr_accessor :pieces
  def initialize
    @pieces = []

    create_pieces
  end

  def create_pieces
    12.times { pieces << Piece.new(self) }
  end
end



class Board
  attr_accessor :players
  attr_reader :board

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
    p "in populate"
    #the four rows get updated
#    board.players.each do |player|
    players.each do |player|
#      rows = player == board.players[0] ? (0..1) : (6..7)
      rows = player == players[0] ? [ 0,1 ] : [ 6,7 ]
      piece_count = 0
      col = 0
    player.pieces.each do |piece|
      # rows.each do |row|
#
#         (0..7).each do |col|



        rows.shift if piece_count == 4
        col = 0 if piece_count == 4
        piece.position = [rows[0], col]
        board[[rows[0], col]] = piece
        col += 1
        piece_count += 1
          # end
 #        end
      end

    end

  end

end


class CheckersGame
  attr_reader :players
  attr_accessor :board #, :players

  def initialize
    @players = [ Player.new, Player.new ]
    @board = Board.new(players)
  end


end