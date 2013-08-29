c = Hash.new

(0..7).each do |row|
  (0..7).each do |col|
    c[[row,col]] = nil
  end
end

p c
