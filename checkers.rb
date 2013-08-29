class Piece
  attr_accessor :player, :position

  P1_MOVES = [[-1, 1], [1, 1]]
  P2_MOVES = [[-1, -1], [1, -1]]
  P1_JUMPS = [[-2, 2], [2, 2]]
  P2_JUMPS = [[-2, -2], [2, -2]]

  def initialize(player)
    @player = player
    @position = nil
  end

  # def can_move?(dest)
  #   p position
  #   cur_x, cur_y = position
  #
  #   my_moves = player.num == 1 ? P1_MOVES : P2_MOVES
  #   my_moves.each do |distance|
  #     dist_x, dist_y = distance
  #     if [cur_x + dist_x, cur_y + dist_y] == dest
  #       return true
  #     end
  #   end
  #
  #
  # end


  def can_slide?(board, dest)
    cur_x, cur_y = position

    my_moves = player.num == 1 ? P1_MOVES : P2_MOVES
    my_moves.each do |distance|
      dist_x, dist_y = distance

      p "[cur_x + dist_x, cur_y + dist_y] #{[cur_x + dist_x, cur_y + dist_y]}"
      p "dest #{dest}"
      p "board.squares[dest] #{board.squares[dest]}"
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

    my_moves = player.num == 1 ? P1_MOVES : P2_MOVES
    my_moves.each do |distance|
      dist_x, dist_y = distance
      #board opponent piece; is there an opponent piece there?
      midway = [cur_x + dist_x, cur_y + dist_y]
      unless board.squares[midway].nil? or board.squares[midway].player == player
        return true if one_over?(midway, dest)
      end
    end

  end

  def perform_slide(board, dest)
    #players[0].pieces[11].perform_slide([6,3])
    #piece = player.pieces[11]
    start_pos = position

    position = dest
    board.squares[start_pos] = nil
    board.squares[dest] = self
  end

  def capture_piece(board, opp_piece)
    #got here even though the jump was all wrong - 4,5 5,2
    board.squares[opp_piece.position] = nil
    opp_piece.player.pieces.delete(self)

    #other_player = board.squares.players.index(player) - 1
    #board.squares.players[other_player].captured_pieces += 1
  end

  def perform_jump(board, dest)
    end_point = position
    midway = [ (end_point[0] + dest[0]) / 2, (end_point[1] + dest[1]) / 2 ]
    opp_piece = board.squares[midway]

    capture_piece(board, opp_piece)
    perform_slide(self, dest)
  end


end

class King < Piece
  KING_MOVES = [[-1, 1], [1, 1],
      [-1, -1], [1, -1]]
  KING_JUMPS = [[-2, 2], [2, 2],
      [-2, -2], [2, -2]]
end

class Player

  attr_accessor :pieces, :num
  def initialize(num)
    @pieces = []
    @num = num
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
  attr_accessor :board, :turn

  def initialize
    @players = [ Player.new(1), Player.new(2) ]
    @board = Board.new(players)
    @turn = 0
  end

  def input


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

    p "board.squares[start].player #{board.squares[start].player} players[turn] #{players[turn]}"
    p "players[turn-1] #{players[turn-1]}"
    p "turn is #{turn}"

    unless defined?(board.squares[start].position) and
      board.squares[start].player == players[turn]

      raise InvalidMoveError.new "Invalid move"
      # puts "Invalid"
#       return false
    end

    piece = board.squares[start]
    p "piece is #{piece}"

    if piece.can_slide?(board, dest)
      p "Yep. I can slide"
      piece.perform_slide(board, dest)

    elsif piece.can_jump?(board, dest)
      p "Yep. I can jump"
      piece.perform_jump(board, dest)
    else
    #  raise InvalidMoveError.new "Invalid move"
    end

  # rescue InvalidMoveError => e
 #    puts "Problem: #{e}"
 #    retry

   #turn = turn == 1 ? 0 : 1
   # if self.turn == 0
#      puts "I changed myself"
#      self.turn = 1
#      puts "Self turn is #{self.turn}"
#    else
#      puts "I'm in the other one"
#      self.turn = 0
#    def end

  self.turn = self.turn == 0 ? 1 : 0



  end



  # def play
 #    while true
 #      if players[turn].piece.can_slide?(dest)
 #        players[turn].piece.perform_slide(dest)
 #      elsif players[turn].piece.can_jump?(dest)
 #        players[turn].piece.perform_jump(dest)
 #      end
 #
 #      turn == 0 ? 1 : 0
 #    end
 #  end

  #def play

end