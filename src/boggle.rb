require 'boggle_server'
BoggleServer::server_assure


# If there's a command-line argument use it as the Boggle board.
# Otherwise create a random Boggle board.
if ARGV.size >= 1
  board_string = ARGV[0]
else
  require 'boggle_board_generator'
  BoggleBoardGenerator.seed = rand(2 ** 32)
  random_board = BoggleBoardGenerator.new
  board_string = random_board.to_input_s
  puts "Random board is:"
  puts random_board
end

# convert the board string into nested arrays representing a 4-by-4
# Boggle board
board =
  board_string.split(//).map { |l| l == 'q' ? 'qu' : l }.enum_slice(4).to_a

t1 = Time.now

# solve the board
results = BoggleServer::server_solve(board)

t2 = Time.now

puts "\nResults:"
puts results

puts "\nStats:"
puts "Time to solve: %0.4f seconds" % (t2 - t1)
