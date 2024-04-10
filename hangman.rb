module Hangman
  class Game
    MAX_TURNS = 20
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
        @guess = get_guess
        if check_guess?(@guess)
          if check_word(@correct_guesses.join)
            puts "You win!"
            break
          end
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
      gets.chomp
    end

    def check_guess?(g)
      if @answer.any? {|c| c == g}
        @correct_guesses.push(g)
        @answer.each_index do |i|
          if @answer[i] == g
            self.answer_mask[i] = g
          end
        end
        true
      else
        @incorrect_guesses.push(g)
        false
      end
    end

    def check_word(w)
      w == @answer
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
Game.new().play
