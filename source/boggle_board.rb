class BoggleBoard
  def initialize
    #how do we describe it
    #creating an array of 16 underscores
    @spaces = Array.new(16, "_")
  end
#what does it do
  def shake!
  end

  # Defining to_s on an object controls how the object is
  # represented as a string, e.g., when you pass it to puts
  def to_s
    # a new string for theoutput
    output_string = String.new
    #making a variable to mess with so i dont screw up my instance variable
    letter_array = @spaces

    4.times do
       output_string << letter_array.shift(4).join('') + "\n"
    end
    
    output_string

  end

end

board = BoggleBoard.new
puts board
