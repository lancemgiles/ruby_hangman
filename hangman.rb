# frozen_string_literal: true

module Hangman
  # main game
  class Game
    MAX_TURNS = 30
    attr_accessor :dict, :remaining_turns, :guess, :correct_guesses, :incorrect_guesses, :answer, :answer_mask

    def initialize
      @dict = File.read('google-10000-english-no-swears.txt').split.select do |word|
        (word.length >= 5) && (word.length <= 12)
      end
      @remaining_turns = MAX_TURNS
      @correct_guesses = []
      @incorrect_guesses = []
      puts "Let's play Hangman!"
      puts "You have #{MAX_TURNS + 1} tries to guess the word."
    end

    def play
      create_secret
      while @remaining_turns >= 0
        puts "#{@remaining_turns} turns left."
        if guess_word?
          @guess = gets.downcase.chomp
          if check_word?(@guess)
            puts 'You win!'
            break
          elsif lose?
            puts "You lose. The answer was #{@answer.join}."
            break
          else
            puts 'Wrong!'
            @remaining_turns -= 1
            update_game
          end
        else
          @guess = create_guess
          if check_guess?(@guess)
            puts 'Correct.'
            if check_word?(@answer_mask.join)
              puts 'You win!'
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
    end

    def create_secret
      @answer = @dict.sample
      @answer_mask = Array.new(@answer.length) { '_' }
      puts @answer_mask.join
      @answer = @answer.chars
    end

    def create_guess
      @remaining_turns -= 1
      puts 'Guess a letter'
      gets.downcase.chomp[0]
    end

    def guess_word?
      puts 'Do you want to guess the word? (y/n)'
      ans = gets.downcase.chomp[0]
      ans == 'y'
    end

    def check_guess?(gss)
      if @answer.any? { |c| c == gss }
        @correct_guesses.push(gss)
        puts "There is a #{gss}"
        @answer.each_index do |i|
          if @answer[i] == gss
            @answer_mask[i] = gss
            puts @answer_mask.join
            true
          end
        end
      else
        @incorrect_guesses.push(g)
        false
      end
    end

    def check_word?(word)
      word == @answer.join
    end

    def lose?
      @remaining_turns.zero?
    end

    def update_game
      puts @answer_mask.join
      puts "Incorrect guesses: #{incorrect_guesses.join}"
    end
  end
end

game = Hangman::Game.new
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
