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
    n[0].unpack('H2')[0].to_i - "a".unpack('H2')[0].to_i
  end
  
  def columnToken(i)
    [(61 + i).to_s].pack('H2')[0]
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
  
  return 0 if movingPiece.eql? "--"
  return 0 if movingPiece[0].eql? destinationPiece[0]
  
  startingColumnIndex = board.columnIndex(move[0][0])
  finishingColumnIndex = board.columnIndex(move[1][0])

  # validate if move[0] and move[1] are inside the board
  return 0 if startingColumnIndex < 0 or startingColumnIndex > 7
  return 0 if finishingColumnIndex < 0 or finishingColumnIndex > 7
  return 0 if move[0][1].to_i < 1 or move[0][1].to_i > 8
  return 0 if move[1][1].to_i < 1 or move[1][1].to_i > 8
  
  case movingPiece[1]
  when 'K' # King
    # one square in each direction, and diagonally
    return 0 if startingColumnIndex - finishingColumnIndex < -1 and
                    startingColumnIndex - finishingColumnIndex > -1
    return 0 if move[0][1].to_i - move[1][1].to_i < -1 and
                    move[0][1].to_i - move[1][1].to_i > 1

    #can't move himself to check (where he can be captured)
    # TODO: validate if a board with current King's move put himself in check
    puts "KING NOT FULLY IMPLEMENTED (move is one square but not verified if put himself in check)"
    return 2
    
  when 'Q' # Queen
    # any one straight direction
    # as far as possible as long as she doesn't move through other pieces
    return 0 if !move[0][0].eql?move[1][0] and # column is different
                !move[0][1].eql?move[1][1] and # line is different
                !(startingColumnIndex - finishingColumnIndex).abs.eql? (move[0][1].to_i - move[1][1].to_i).abs # not valid diagonal
    
    # Check for jumps
    nextMove = move[0].dup
    columnDirection = 0
    lineDirection = 0
    if move[0][0].eql?move[1][0]
      # Moving inside the column
      lineDirection = (move[0][1].to_i - move[1][1].to_i) > 0 ? -1 : 1
    elsif move[0][1].eql?move[1][1]
      # Moving inside the line
      columnDirection = (startingColumnIndex - finishingColumnIndex) > 0 ? -1 : 1
    else
      # Moving diagonally
      columnDirection = (startingColumnIndex - finishingColumnIndex) > 0 ? -1 : 1
      lineDirection = (move[0][1].to_i - move[1][1].to_i) > 0 ? -1 : 1
    end
    
    while !nextMove.eql?move[1] do
      # DRY
      nextMoveColumnIndex = board.columnIndex(nextMove[0])
      nextMove[0] = board.columnToken(nextMoveColumnIndex + columnDirection)
      nextMove[1] = (nextMove[1].to_i + lineDirection).to_s
      return 0 if !board.element(nextMove).eql?"--" and !nextMove.eql?move[1]
    end

  when 'R' # Rook
    # as far as it wants but only forward, backward, and to the sides
    return 0 if !move[0][0].eql?move[1][0] and !move[0][1].eql?move[1][1]
    
    # Check for jumps
    nextMove = move[0].dup
    columnDirection = 0
    lineDirection = 0
    if move[0][0].eql?move[1][0]
      # Moving inside the column
      lineDirection = (move[0][1].to_i - move[1][1].to_i) > 0 ? -1 : 1
    else
      # Moving inside the line
      columnDirection = (startingColumnIndex - finishingColumnIndex) > 0 ? -1 : 1
    end
    
    while !nextMove.eql?move[1] do
      nextMoveColumnIndex = board.columnIndex(nextMove[0])
      nextMove[0] = board.columnToken(nextMoveColumnIndex + columnDirection)
      nextMove[1] = (nextMove[1].to_i + lineDirection).to_s
      return 0 if !board.element(nextMove).eql?"--" and !nextMove.eql?move[1]
    end
  when 'B' # Bishop
    # as far as it wants but only diagonally
    # each bishop starts in one color and have to stay in that color
    forward = move[0][0].eql?move[1][0]
    return 0 if forward
    
    # not a valid diagonal
    return 0 if !(startingColumnIndex - finishingColumnIndex).abs.eql? (move[0][1].to_i - move[1][1].to_i).abs

    # Walk from move[0] to move[1] and check if it is empty
    # DRY
    nextMove = move[0].dup
    columnDirection = (startingColumnIndex - finishingColumnIndex) > 0 ? -1 : 1
    lineDirection = (move[0][1].to_i - move[1][1].to_i) > 0 ? -1 : 1
    
    while !nextMove.eql?move[1] do
      # DRY
      nextMoveColumnIndex = board.columnIndex(nextMove[0])
      nextMove[0] = board.columnToken(nextMoveColumnIndex + columnDirection)
      nextMove[1] = (nextMove[1].to_i + lineDirection).to_s
      return 0 if !board.element(nextMove).eql?"--" and !nextMove.eql?move[1]
    end
  when 'N' # Knight
    # move in L: two squares in one direction than turn 90 degrees to move one more square
    columnDirection = (startingColumnIndex - finishingColumnIndex) > 0 ? -1 : 1
    lineDirection = (move[0][1].to_i - move[1][1].to_i) > 0 ? -1 : 1

    # Check if it doesn't go outside the board walking 2 squares in the column and 1 square
    # in the line
    if (startingColumnIndex + columnDirection*2) > 0 and
       (startingColumnIndex + columnDirection*2) <= 7 
      # Walk 2 squares in the column direction
      columnDestination = "--"
      columnDestination[0] = board.columnToken(startingColumnIndex + columnDirection*2)
      # Walk 1 square in the line direction
      columnDestination[1] = (move[0][1].to_i + lineDirection).to_s
      return 1 if columnDestination.eql?move[1]
    end

    # Check if it doesn't go outside the board walking 2 squares in the line and 1 square
    # in the column
    if (move[0][1].to_i + lineDirection*2) > 0 and
       (move[0][1].to_i + lineDirection*2) <= 7
       columnDestination = "--"
       columnDestination[0] = board.columnToken(startingColumnIndex + columnDirection)
       columnDestination[1] = (move[0][1].to_i + lineDirection*2).to_s
       return 1 if columnDestination.eql?move[1]
    end

    return 0
  when 'P' # Pawn
    forward = move[0][0].eql?move[1][0]
    if forward
      totalSquares = (move[0][1].to_i - move[1][1].to_i).abs
      return 0 if totalSquares > 2
      if totalSquares.eql?2
        # can move forward 2 squares if it is the first move
        case movingPiece
        when 'wP'
          return 0 if !move[0][1].eql?"2"
        when 'bP'
          return 0 if !move[0][1].eql?"7"
        end
      end
    else
      #can move diagonally to capture
      return 0 if destinationPiece.eql?"--"
    end

  else
    8.times puts "INVALID PIECE"
    return 0
  end
  
  1
end

board = Board.new(ARGV[0])
#board.print

moves = Moves.new(ARGV[1])
#moves.print

moveCount = 1
moves.moves.each do |move|
  #puts "Validating move: #{move.to_s}"
  moveStatus = validMove board, move
  case moveStatus
  when 0
    puts "ILLEGAL"
  when 1
    puts "LEGAL"
    #else
    #puts "NOT-IMPLEMENTED"
  end

  moveCount += 1
end
