module Hangman
  class Game
    MAX_TURNS = 11
    attr_accessor :dict, :remaining_turns
    def initialize
      @dict = File.read('google-10000-english-no-swears.txt').split.select do
        |word| (word.length >= 5) && (word.length <= 12)
      end
      @remaining_turns = MAX_TURNS
    end

    def play

    end

    def get_guess

    end

    def check_guess(g)

    end

    def check_word(w)

    end

    def update_gameboard

    end
  end

    
end

include Hangman
Game.new().play
