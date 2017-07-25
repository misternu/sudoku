class SudokuBoard
  NUMBERS = ["1","2","3","4","5","6","7","8","9"]
  EMPTY_ARRAY = []
  BOARD_RANGE = (0..80)
  ROWS = [[0, 1, 2, 3, 4, 5, 6, 7, 8], [9, 10, 11, 12, 13, 14, 15, 16, 17], [18, 19, 20, 21, 22, 23, 24, 25, 26], [27, 28, 29, 30, 31, 32, 33, 34, 35], [36, 37, 38, 39, 40, 41, 42, 43, 44], [45, 46, 47, 48, 49, 50, 51, 52, 53], [54, 55, 56, 57, 58, 59, 60, 61, 62], [63, 64, 65, 66, 67, 68, 69, 70, 71], [72, 73, 74, 75, 76, 77, 78, 79, 80]]
  COLS = [[0, 9, 18, 27, 36, 45, 54, 63, 72], [1, 10, 19, 28, 37, 46, 55, 64, 73], [2, 11, 20, 29, 38, 47, 56, 65, 74], [3, 12, 21, 30, 39, 48, 57, 66, 75], [4, 13, 22, 31, 40, 49, 58, 67, 76], [5, 14, 23, 32, 41, 50, 59, 68, 77], [6, 15, 24, 33, 42, 51, 60, 69, 78], [7, 16, 25, 34, 43, 52, 61, 70, 79], [8, 17, 26, 35, 44, 53, 62, 71, 80]]
  BOXES = [[0, 1, 2, 9, 10, 11, 18, 19, 20], [3, 4, 5, 12, 13, 14, 21, 22, 23], [6, 7, 8, 15, 16, 17, 24, 25, 26], [27, 28, 29, 36, 37, 38, 45, 46, 47], [30, 31, 32, 39, 40, 41, 48, 49, 50], [33, 34, 35, 42, 43, 44, 51, 52, 53], [54, 55, 56, 63, 64, 65, 72, 73, 74], [57, 58, 59, 66, 67, 68, 75, 76, 77], [60, 61, 62, 69, 70, 71, 78, 79, 80]]

  def initialize(board, poss = nil, empties = nil)
    @board = board
    @poss = poss
    @empties = empties
    compute_possibilities! if poss.nil?
    compute_empties! if empties.nil?
  end

  def compute_possibilities!
    @poss = Array.new(81) { NUMBERS.dup }
    BOARD_RANGE.each do |index|
      poss_elim!(index, @board[index]) unless @board[index] == "-"
    end
  end

  def solve!
    iterate! unless solved
    recurse! unless solved || invalid
    return @board if solved
    nil
  end

  def invalid
    @poss[@empties.first] == EMPTY_ARRAY
  end

  def solved
    @empties == EMPTY_ARRAY
  end

  def iterate!
    @empties.each do |i|
      if @poss[i].length == 1
        put_square(i, @poss[i].first)
        return iterate!
      end
    end
    sort_empties!
  end

  def recurse!
    best_index = @empties.first
    @poss[best_index].each do |possibility|
      new_sudoku = SudokuBoard.new(@board.dup, @poss.dup, @empties.dup)
      new_sudoku.put_square(best_index, possibility)
      sudoku = new_sudoku.solve!
      if sudoku
        @board = sudoku
        @empties = EMPTY_ARRAY
        return
      end
    end
  end

  def compute_empties!
    @empties = BOARD_RANGE.select { |i| @board[i] == "-" }
    sort_empties!
  end

  def sort_empties!
    @empties.sort_by! { |i| @poss[i].length }
  end

  def put_square(i, value)
    @board[i] = value
    poss_elim!(i, value)
    @empties -= [i]
  end

  def poss_elim!(i, square)
    ROWS[i/9].each { |j|
      @poss[j] = @poss[j].reject { |k| k == square } unless @poss[j].empty?
    }
    COLS[i%9].each { |j|
      @poss[j] = @poss[j].reject { |k| k == square } unless @poss[j].empty?
    }
    BOXES[(i/27*3) + (i%9/3)].each { |j|
      @poss[j] = @poss[j].reject { |k| k == square } unless @poss[j].empty?
    }
    @poss[i] = EMPTY_ARRAY
  end
end
