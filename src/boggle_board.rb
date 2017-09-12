class BoggleBoard

  def initialize
    @spaces = Array.new(16,"_")
    @alphabet =('A'..'Z'). to_a
  end

  def shake!
    #take spaces
    #replace them with random letters
    #spit it into our board#call the shake method
    @spaces.map! do | space |
    space = @alphabet.shuffle.take(1)
    end

  end

 # Defining to_s on an object controls how the object is
  # represented as a string, e.g., when you pass it to puts
  def to_s
    # output_string = String.new
    # letter_array = @spaces
    #
    # 4.times do
    #   output_string << letter_array.shift(4).join('') + "\n"
    # end
    # puts output_string
  end
end

board = BoggleBoard.new
puts board.to_s
puts board.shake!
