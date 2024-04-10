module Hangman
  class Game
    MAX_TURNS = 11
    attr_accessor :dict, :remaining_turns, :guess, :correct_guesses, :incorrect_guesses, :answer, :answer_mask
    def initialize
      @dict = File.read('google-10000-english-no-swears.txt').split.select do
        |word| (word.length >= 5) && (word.length <= 12)
      end
      @remaining_turns = MAX_TURNS
      @correct_guesses = []
      puts "Let's play Hangman!"
      puts "You have #{MAX_TURNS} tries to guess the word."
    end

    def play
      get_secret
      while @remaining_turns >= 0
        @guess = get_guess
        check_guess(@guess)
      end
    end

    def get_secret
      @answer = @dict.sample
      @answer_mask = Array.new(@answer.length){ |c| c = '_'}
      puts @answer_mask.join
    end

    def get_guess
      puts "Guess a letter"
      gets.chomp[0]
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
