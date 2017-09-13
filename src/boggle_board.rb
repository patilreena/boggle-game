# class BoggleBoard
#
#   def initialize
#     @spaces = Array.new(16,"_")
#     @alphabet =('A'..'Z'). to_a
#   end
#
#   def shake!
#     #take spaces
#     #replace them with random letters
#     #spit it into our board#call the shake method
#     @spaces.map! do | space |
#     space = @alphabet.shuffle.take(1)
#     end
#
#   end
#
#  # Defining to_s on an object controls how the object is
#   # represented as a string, e.g., when you pass it to puts
#   def to_s
#     # output_string = String.new
#     # letter_array = @spaces
#     #
#     #
#     # 4.times do
#     #   output_string << letter_array.shift(4).join('') + "\n"
#     # end
#     # puts output_string
#   end
# end
#
# board = BoggleBoard.new
# puts board.to_s
# puts board.shake!



class Board
  def initialize(state)
    @xmax = state.size
    @ymax = state[0].size

    state.each do |row|
      raise "Board rows are of varying lengths" if row.size != @ymax
    end

    @state = state
  end

  def [](a, b)
    @state[a][b]
  end

  def each()
    for x in 0...@xmax
      for y in 0...@ymax
        yield x, y
      end
    end
  end

  def neighbor_iter(x, y)
    temp = @state[x][y]
    @state[x][y] = nil

    xrange = ([x-1, 0].max)..([x+1, @xmax-1].min)
    yrange = ([y-1, 0].max)..([y+1, @ymax-1].min)

    for i in xrange
      for j in yrange
        yield i, j if @state[i][j]
      end
    end

    @state[x][y] = temp
  end
end
