require 'yaml'

class Game
  def initialize
    remaining_turns = 6
    incorrect_guesses = ["a", 'b', 'c']
    answer_mask = ["_", "o", "_"]
    answer = ["d", "o", "g"]
  end
  def self.save_game
    puts 'Save game and quit playing? (y/n)'
    ans = gets.downcase.chomp
    return unless ans == 'y'
  
    File.open('save.yml', 'w') {|file| file.write(self.to_yaml)}
    abort 'Game saved.'
  end
  
  # def load_game
  #   save = File.read('save.yml').split
  #   remaining_turns = save[0].to_i
  #   incorrect_guesses = save[1]
  #   answer_mask = save[2]
  #   answer = save[3]
  # end

end

Game.save_game