# require_relative 'boggle_board'
#
# describe "Boggle Board - Release 0" do
#
#   let(:board) { BoggleBoard.new }
#
#   it "can be shaken" do
#     expect{board.shake!}.not_to raise_error
#   end
#
#   it 'has a printable representation of 4 underscores in each of 4 rows on separate lines BEFORE it is shaken' do
#     expect(board.to_s).to match(/^_{4}${4}/)
#   end
#
#   it 'has a printable representation of 4 letters in each of 4 rows on separate lines AFTER it is shaken' do
#     board.shake!
#     expect(board.to_s).to match(/^[A-Z]{4}${4}/)
#   end
#
#   it 'has the same state every time to_s is called' do
#     first_string = board.to_s
#     second_string = board.to_s
#     expect(first_string).to eq second_string
#   end
#
#   it 'has a different state after shake is called' do
#     first_string = board.to_s
#     board.shake!
#     second_string = board.to_s
#     expect(first_string).not_to eq second_string
#   end
#
#   it 'has 4 rows' do
#     expect(board.shake!.length).to eq(4)
#   end
#
#   it 'has 4 rows with 4 letters each' do
#     expect(board.shake!.all? {|row| row.length == 4}).to be_truthy
#   end
# end
#
# describe "Boggle Board - Release 1" do
#   pending "Write your own tests here"
# end
#
# describe "Boggle Board - Release 2" do
#   pending "Write your own tests here"
# end

def search(board, pos, dict, prefix)
  words = []

  if dict.is_word?
    words << prefix
  end

  board.neighbor_iter(*pos) do |x, y|
    if dict.keys.member? board[x, y]
      recur = search(board, [x, y], dict[board[x, y]], prefix+board[x, y])
      words.concat(recur)
    end
  end

  words
end


board = Board.new($<.readlines.map {|line| line.scan(/\w/)})

dict = Trie.new()
File.open('/usr/share/dict/words').each do |line|
  dict.addword(line.chomp.downcase)
end


results = []
board.each do |x, y|
  results.concat(search(board, [x, y], dict[board[x, y]], board[x, y]))
end

results.uniq!
results.sort! {|a, b| a.size - b.size}

puts results
