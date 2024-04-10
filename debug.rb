require 'yaml'
# require 'pry-byebug'
module State
  def save
    puts 'Save game and quit playing? (y/n)'
    ans = gets.downcase.chomp
    return unless ans == 'y'

    File.open('save.yml', 'w') { |file| YAML.dump(@state, file) }
    abort 'Game saved.'
  end

  def load
    @state = YAML.load_file('save.yml')
    puts @state.inspect
    # puts (@state.each { |i| puts i })
    # remaining_turns = save[0].to_i
    # incorrect_guesses = save[1]
    # answer_mask = save[2]
    # answer = save[3]
  end
end

class Game
  include State
  attr_accessor :state

  def initialize
    remaining_turns = 6
    incorrect_guesses = %w[a b c]
    answer_mask = %w[_ o _]
    answer = %w[d o g]
    @state = [remaining_turns, incorrect_guesses, answer_mask, answer]
  end
end

game = Game.new
# binding.pry
# game.save
game.load
