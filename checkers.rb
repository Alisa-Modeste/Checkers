class Piece
  attr_accessor :player, :position

  MOVES = [[-1, 1], [1, 1]]
  JUMPS = [[-2, 2], [2, 2]]

  def initialize(player)
    @player = player
    @position = nil
  end

  def can_move?(dest)
    cur_x, cur_y = position
    # dest_x, dest_y = dest

    MOVES.each |distance|
      dist_x, dist_y = distance
      #if (cur_x + dist_x) == dest_x && (cur_y + dist_y) == dest_y
       if [cur_x + dist_x, cur_y + dist_y] == dest
        return true
      end
    end

    #opponent_piece(dest)


  end

  # def opponent_piece?(dest)
  #   cur_x, cur_y = position
  #   dest_x, dest_y = dest
  #
  #
  # end

  def can_slide?(dest)
    MOVES.each |distance|
      dist_x, dist_y = distance

      if [cur_x + dist_x, cur_y + dist_y] == dest
        return true
      end
    end
  end

  def one_over?(midway, dest)
    cur_x, cur_y = position
    mid_x, mid_y = midway

    vector_x = cur_x - mid_x
    vector_y = cur_y - mid_y

    [mid_x + vector_x, mid_y + vector_y] == dest
    #if [mid_x + vector_x, mid_y + vector_y] == dest
      # true
 #     end
 #
 #    false
  end

  def can_jump?(board, dest)
    cur_x, cur_y = position

    MOVES.each |distance|
      dist_x, dist_y = distance
      #board opponent piece; is there an opponent piece there?
      midway = [cur_x + dist_x, cur_y + dist_y]
      unless board[midway].nil? # == opponent piece
        return true if one_over?(midway, dest)
      end
    end

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
    #the six rows get updated
    players.each do |player|
      rows = player == players[0] ? [ 0,1,2 ] : [ 5,6,7 ]
      piece_count = 0
      col = 0
    player.pieces.each do |piece|

        rows.shift if piece_count % 4 == 0 and piece_count != 0

        col_start = rows[0] % 2 == 1 ? 0 : 1
        col = 0 if (col_start == 0 || col_start == 1) && piece_count % 4 == 0

     piece.position = [col + col_start, rows[0]]
     board[[col + col_start, rows[0]]] = piece

        col += 2
        piece_count += 1

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