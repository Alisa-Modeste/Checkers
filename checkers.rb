class Piece
  attr_accessor :player, :position

  MOVES = [[-1, 1], [1, 1]]
  JUMPS = [[-2, 2], [2, 2]]

  def initialize(player)
    @player = player
    @position = nil
  end

  def can_move?(dest)
    p position
    cur_x, cur_y = position

    MOVES.each do |distance|
      dist_x, dist_y = distance
      if [cur_x + dist_x, cur_y + dist_y] == dest
        return true
      end
    end


  end


  def can_slide?(board, dest)
    cur_x, cur_y = position

    MOVES.each do |distance|
      dist_x, dist_y = distance

      if [cur_x + dist_x, cur_y + dist_y] == dest && board.squares[dest].nil?
        return true
      end
    end

    false
  end

  def one_over?(midway, dest)
    cur_x, cur_y = position
    mid_x, mid_y = midway

    vector_x = cur_x - mid_x
    vector_y = cur_y - mid_y

    [mid_x + vector_x, mid_y + vector_y] == dest

    # result = [mid_x + vector_x, mid_y + vector_y] == dest
#
#     [ result, [ vector_x, vector_y ]]

  end

  def can_jump?(board, dest)
    cur_x, cur_y = position

    MOVES.each do |distance|
      dist_x, dist_y = distance
      #board opponent piece; is there an opponent piece there?
      midway = [cur_x + dist_x, cur_y + dist_y]
      unless board[midway].nil? or squares[midway].player == player
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
    captured_pieces = 0

    create_pieces
  end

  def create_pieces
    12.times { pieces << Piece.new(self) }
  end
end



class Board
  attr_accessor :players
  attr_reader :squares

  def initialize(players)
    @squares = Hash.new
    @players = players

    (0..7).each do |row|
      (0..7).each do |col|
        squares[[row,col]] = nil
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
     squares[[col + col_start, rows[0]]] = piece

        col += 2
        piece_count += 1

      end

    end

  end

  def perform_slide(piece, dest)
    #players[0].pieces[11].perform_slide([6,3])
    #piece = player.pieces[11]
    start_pos = piece.position

    piece.position = dest
    squares[start_pos] = nil
    squares[dest] = piece
  end

  def capture_piece(piece)
    squares[piece.position] = nil
    piece.player.pieces.delete(piece)

    squares.players[i-1].captured_pieces += 1
  end

  def perform_jump(piece, dest)
    other_end_p = piece.position
    midway = [ (other_end_p[0] + dest[0]) / 2, (other_end_p[1] + dest[1]) / 2 ]
    opp_piece = squares[midway]

    capture_piece(opp_piece)
    perform_slide(piece, dest)
  end

  def render_board
    (0..7).to_a.reverse.each do |x|
      (0..7).each do |y|
        print squares[[y, x]].nil? ? "   |" : " X |"
      end
      puts ''
    end

    nil
  end

end


class CheckersGame
  attr_reader :players
  attr_accessor :board

  def initialize
    @players = [ Player.new, Player.new ]
    @board = Board.new(players)
  end

  def input
    i = 0
    #get checker position and destination

    #check board for starting point
    #make sure it's their piece
    #send the player's piece

    #[7,2] [6,3]
    # 7,2 6,3
    coordinates = gets.chomp.split(" ")
    coordinates[0] = coordinates[0].split(',').map{|x| x.to_i}
    coordinates[1] = coordinates[1].split(',').map{|x| x.to_i}
    p coordinates
    start, dest = coordinates

    p "board[start] is #{board.squares[start]}"
    p defined?(board.squares[start].position)

    unless defined?(board.squares[start].position) and
      board.squares[start].player == players[i]

      raise InvalidMoveError.new "Invalid move"
    end

    piece = board.squares[start]


    if piece.can_slide?(board, dest)
      board.perform_slide(piece, dest)

    elsif piece.can_jump?(board, dest)
      board.perform_jump(piece, dest)
    else
      raise InvalidMoveError.new "Invalid move"
    end

  rescue InvalidMoveError => e
    puts "Problem: #{e}"
    retry

  end



  def play
    while true
      if players[i].piece.can_slide?(dest)
        players[i].piece.perform_slide(dest)
      elsif players[i].piece.can_jump?(dest)
        players[i].piece.perform_jump(dest)
      end
    end
  end

end