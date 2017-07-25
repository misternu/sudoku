require_relative 'sudoku'
require 'benchmark'

puts Benchmark.measure {
  puts File.readlines('sudoku_puzzles.txt')[0..-2].map { |line|
    SudokuBoard.new(line.chomp).solve!
  }
}
