# # class BoggleBoard
# #
# #   def initialize
# #     @spaces = Array.new(16,"_")
# #     @alphabet =('A'..'Z'). to_a
# #   end
# #
# #   def shake!
# #     #take spaces
# #     #replace them with random letters
# #     #spit it into our board#call the shake method
# #     @spaces.map! do | space |
# #     space = @alphabet.shuffle.take(1)
# #     end
# #
# #   end
# #
# #  # Defining to_s on an object controls how the object is
# #   # represented as a string, e.g., when you pass it to puts
# #   def to_s
# #     # output_string = String.new
# #     # letter_array = @spaces
# #     #
# #     #
# #     # 4.times do
# #     #   output_string << letter_array.shift(4).join('') + "\n"
# #     # end
# #     # puts output_string
# #   end
# # end
# #
# # board = BoggleBoard.new
# # puts board.to_s
# # puts board.shake!
#
#
# #Define a class called Board
# class Board
#   def initialize(state)
#     @xmax = state.size
#     @ymax = state[0].size
#
#     state.each do |row|
#       raise "Board rows are of varying lengths" if row.size != @ymax
#     end
#
#     @state = state
#   end
#
#   def [](a, b)
#     @state[a][b]
#   end
#
#   def each()
#     for x in 0...@xmax
#       for y in 0...@ymax
#         yield x, y
#       end
#     end
#   end
#
#   def neighbor_iter(x, y)
#     temp = @state[x][y]
#     @state[x][y] = nil
#
#     xrange = ([x-1, 0].max)..([x+1, @xmax-1].min)
#     yrange = ([y-1, 0].max)..([y+1, @ymax-1].min)
#
#     for i in xrange
#       for j in yrange
#         yield i, j if @state[i][j]
#       end
#     end
#
#     @state[x][y] = temp
#   end
# end

class BoggleSolver

  # Represents a letter blocks on the Boggle board.  Generally a
  # letter block will be a single letter (e.g., "a").  However, it can
  # handle letter blocks that can contain sequences (e.g., "qu").  It
  # knows who is neighboring letters are.  It also knows whether it's
  # been used (consumed) yet or not.  Can return a list of all
  # neighboring letters that are not yet used.
  class Letter
    attr_reader :letter, :neighbors
    attr_accessor :used


    def initialize(letter)
      @letter = letter
      @neighbors = Set.new
      @used = false
    end


    # Adds a neighbor to the given letter.
    def add_neighbor(other_letter)
      @neighbors << other_letter
    end


    # Returns an array of neighboring letters that are not yet used.
    def unused_neighbors
      @neighbors.reject { |n| n.used }
    end
  end


  # Represents a Boggle board as a two-dimensional array of Letters.
  # The letters themselves keep track of the structure of the board
  # (i.e., which letters neighbor which other letters), although the
  # initialize method of this class sets up those links.
  class Board

    # Creates a board from a two-dimensional array of letters.  Note,
    # a letter can actually be a letter sequence (e.g., "qu").
    def initialize(contents)
      @size = contents.size
      raise "non-rectangular" unless @size == contents.first.size

      @letters = contents.map do |row|
        row.map { |letter| Letter.new(letter) }
      end

      # set up neighbors
      @letters.each_with_index do |row, row_index|
        row.each_with_index do |letter, col_index|
          (-1..1).each do |row_offset|
            r = row_index + row_offset
            next unless (0...@size) === r
            (-1..1).each do |col_offset|
              next if row_offset == 0 && col_offset == 0
              c = col_index + col_offset
              next unless (0...@size) === c
              letter.add_neighbor @letters[r][c]
            end
          end
        end
      end
    end


    # Processes each letter on the board with the block provided.
    def process
      @letters.flatten.each { |l| yield l }
    end
  end


  # Loads a dictionary and solves multiple boards using that dictionary.
  class Solver

    # Provide a dictioary file used to solve the Boggle boards.
    def initialize(dictionary_file)
      @dictionary = Trie.from_dictionary dictionary_file
    end


    # Solves the board passed in, returning an array of words, sorted
    # from longest to shortest.
    def solve(board_config)
      board = Board.new(board_config)
      results = Set.new
      board.process do |l|
        find_words(l, "", @dictionary, results)
      end
      results.to_a.sort_by { |w| [-w.size, w] }
    end


    protected


    # Recursively try to find words by adding this letter to word,
    # looking for it in our dictionary trie, and adding found words to
    # results.
    def find_words(letter, word, dict, results)
      letter.used = true  # open block by making letter used

      word = word + letter.letter  # make new word w/ letter

      # march down dictionary trie; note: because one die contains a
      # side w/ "qu", we use generalize to allow a die to contain any
      # number of letters and march through *all* of them using a loop
      0.upto(letter.letter.size - 1) do |index|
        dict = dict.subtrie(letter.letter[index, 1])
      end

      # if there are any possible words once we get here...
      if dict.any?
        # if this specific word so far is in the dictionary
        # add it to the results
        results << word if word.size >= 3 && dict.include?(word)

        # try to extend with all unused neighboring letters
        letter.unused_neighbors.each do |l|
          find_words(l, word, dict, results)
        end
      end

      letter.used = false  # close block by making letter available
    end
  end  # class Solver
end  # module BoggleSolver
