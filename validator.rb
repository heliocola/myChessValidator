require 'pry'

class Board
  attr_reader :board
  
  def initialize(file)
    @board = {
      8 => nil,
      7 => nil,
      6 => nil,
      5 => nil,
      4 => nil,
      3 => nil,
      2 => nil,
      1 => nil
    }
    parse(file)
  end
  
  def parse(file)
    count = 8
    File.open(file).each do |line|
      @board[count] = line.split(" ")
      count -= 1
    end
  end
  
  def columnIndex(n)
    n[0].unpack('C')[0] - "a".unpack('C')[0]
  end
  
  def element(n)
    @board[n[1].to_i][n[0].unpack('C')[0] - "a".unpack('C')[0]]
  end
  
  def print
    puts "This is my board:"
    @board.each do |line|
      puts "#{line[0]} - #{line[1].to_s}"
    end
  end
end

class Moves
  attr_reader :moves
  
  def initialize(file)
    count = 0
    @moves = Array.new
    File.open(file).each do |line|
      @moves[count] = line.split(" ")
      count += 1
    end
  end
  
  def print
    puts "This are my moves:"
    @moves.each do |line|
      puts line.to_s
    end
  end
end

def validMove(board, move)
  movingPiece = board.element(move[0])
  destinationPiece = board.element(move[1])
  
  #puts "This is the moving piece: #{movingPiece}"
  #puts "This is the piece in the destination: #{destinationPiece}"
  
  return false if movingPiece.eql? "--"
  return false if movingPiece[0].eql? destinationPiece[0]
  
  startingColumnIndex = board.columnIndex(move[0][0])
  finishingColumnIndex = board.columnIndex(move[1][0])
  
  case movingPiece[1]
  when 'K' # King
    # one square in each direction, and diagonally
    return false if startingColumnIndex - finishingColumnIndex < -1 and
                    startingColumnIndex - finishingColumnIndex > -1
    return false if move[0][1].to_i - move[1][1].to_i < -1 and
                    move[0][1].to_i - move[1][1].to_i > 1

    #can't move himself to check (where he can be captured)
    # TODO: need to find the other King
    
  when 'Q' # Queen
  when 'R' # Rook
  when 'B' # Bishop
  when 'N' # Night
  when 'P' # Pawn
    forward = move[0][0].eql?move[1][0]
    if forward
      totalSquares = (move[0][1].to_i - move[1][1].to_i).abs
      return false if totalSquares > 2
      if totalSquares.eql?2
        # can move forward 2 squares if it is the first move
        case movingPiece
        when 'wP'
          return false if !move[0][1].eql?"2"
        when 'bP'
          return false if !move[0][1].eql?"7"
        end
      end
    else
      #can move diagonally to capture
      return false if destinationPiece.eql?"--"
    end

  else
    8.times puts "INVALID PIECE"
    return false
  end
  
  true
end

board = Board.new(ARGV[0])
board.print

moves = Moves.new(ARGV[1])
#moves.print

moveCount = 1
moves.moves.each do |move|
  #puts "Validating move: #{move.to_s}"
  if validMove board, move
    puts "#{moveCount} - LEGAL"
  else
    puts "#{moveCount} - ILLEGAL"
  end

  moveCount += 1
end
