require 'pry-byebug'

module Hangman
  class Game
    MAX_TURNS = 30
    attr_accessor :dict, :remaining_turns, :guess, :correct_guesses, :incorrect_guesses, :answer, :answer_mask
    def initialize
      @dict = File.read('google-10000-english-no-swears.txt').split.select do
        |word| (word.length >= 5) && (word.length <= 12)
      end
      @remaining_turns = MAX_TURNS
      @correct_guesses = []
      @incorrect_guesses = []
      puts "Let's play Hangman!"
      puts "You have #{MAX_TURNS} tries to guess the word."
    end

    def play
      get_secret
      while @remaining_turns >= 0
        if check_word(@answer_mask)
          puts "You win!"
          break
        end
        @guess = get_guess
        if check_guess?(@guess)
          puts "Correct."
        elsif lose?
          puts "You lose. The answer was #{@answer.join}."
          break
        else
          puts 'Keep trying.'
        end
        update_game
      end
    end

    def get_secret
      @answer = @dict.sample
      @answer_mask = Array.new(@answer.length){ |c| c = '_'}
      puts @answer_mask.join
      @answer = @answer.chars
    end

    def get_guess
      @remaining_turns -= 1
      puts "Guess a letter"
      gets.downcase.chomp
    end

    def check_guess?(g)
      if @answer.any? {|c| c == g}
        @correct_guesses.push(g)
        puts "There is a #{g}"
        @answer.each_index do |i|
          if @answer[i] == g
            self.answer_mask[i] = g
            puts "#{@answer_mask.join}"
            true
          end
        end
      else
        @incorrect_guesses.push(g)
        false
      end
    end

    def check_word(w)
      w.join == @answer.join
    end

    def lose?
      @remaining_turns == 0
    end

    def update_game
      puts "#{@answer_mask.join}"
      puts "Incorrect guesses: #{incorrect_guesses.join}"
      puts "#{@remaining_turns} turns left."
    end
  end
end

include Hangman
game = Game.new()
game.play
# game.get_secret
# while game.remaining_turns >= 0
#   binding.pry
#   game.guess = game.get_guess
#   if game.check_guess?(game.guess)
#     if game.check_word(game.correct_guesses)
#       puts "You win!"
#       break
#     end
#   elsif game.lose?
#     puts "You lose. The answer was #{game.answer.join}."
#     break
#   else
#     puts 'Keep trying.'
#   end
#   game.update_game
# end
