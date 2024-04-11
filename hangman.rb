# frozen_string_literal: true

require 'yaml'

module Hangman
  # module for saving, loading
  module State
    def save(state)
      update_state(state)
      puts 'Save game and quit playing? (y/n)'
      ans = gets.downcase.chomp
      return unless ans == 'y'

      File.open('save.yml', 'w') { |file| YAML.dump(state, file) }
      abort 'Game saved.'
    end

    def load
      puts 'Load saved game? (y/n)'
      ans = gets.downcase.chomp[0]
      return unless ans == 'y'

      @state = YAML.load_file('save.yml', aliases: true, permitted_classes: [Hangman::Game])
      @answer = @state[0]
      @answer_mask = state[1]
      @incorrect_guesses = state[2]
      @turns = state[3]
      puts @turns
      puts state[3]
      update_game
    end

    def update_game
      @state = [@answer, @answer_mask, @incorrect_guesses, @turns]
      puts @answer_mask.join
      puts "Incorrect guesses: #{incorrect_guesses.join}"
    end

    def update_state(state)
      state[0] = @answer
      state[1] = @answer_mask
      state[2] = @incorrect_guesses
      state[3] = @turns
    end
  end

  # main game
  class Game
    include State
    MAX_TURNS = 12
    attr_accessor :dict, :turns, :guess, :incorrect_guesses, :answer, :answer_mask, :state

    def initialize
      @dict = File.read('google-10000-english-no-swears.txt').split.select do |word|
        (word.length >= 5) && (word.length <= 12)
      end
      @incorrect_guesses = []
      if File.exist?('save.yml')
        self.load
      else
        create_secret
        @turns = 0
      end
      @state = [@answer, @answer_mask, @incorrect_guesses, @turns]
      puts "Let's play Hangman!"
      puts "You have #{MAX_TURNS} tries to guess the word."
    end

    def play(state)
      update_state(state)
      while @turns <= MAX_TURNS
        puts "#{MAX_TURNS - @turns} turns left."
        save(state)
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
            @turns += 1
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
      @turns += 1
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
        puts "There is a #{gss}"
        @answer.each_index do |i|
          if @answer[i] == gss
            @answer_mask[i] = gss
            puts @answer_mask.join
            true
          end
        end
      else
        @incorrect_guesses.push(gss)
        false
      end
    end

    def check_word?(word)
      word == @answer.join
    end

    def lose?
      @turns == MAX_TURNS
    end
  end
end

game = Hangman::Game.new

game.play(game.state)
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
