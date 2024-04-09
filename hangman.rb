dict = File.read('google-10000-english-no-swears.txt').split.select do
  |word| (word.length >= 5) && (word.length <= 12)
end

