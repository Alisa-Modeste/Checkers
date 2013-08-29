class CheckersGame
end

class Piece
  MOVES = [[-1, 1], [1, 1]]
  JUMPS = [[-2, 2], [2, 2]]
end

class King < Piece
  KING_MOVES = [[-1, 1], [1, 1],
      [-1, -1], [1, -1]]
  KING_JUMPS = [[-2, 2], [2, 2],
      [-2, -2], [2, -2]]
end