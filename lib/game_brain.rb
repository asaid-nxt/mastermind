# frozen_string_literal: true

# GameBrain class
class GameBrain
  attr_reader :user_result, :remaining_guesses

  COLORS = %w[red blue green yellow grey purple black white].freeze

  def initialize
    @colors_code = COLORS.sample(4)
    @user_result = Array.new(4) { '' }
    @remaining_guesses = 14
  end

  def valid_input?(input, user_colors)
    COLORS.include?(input) && !user_colors.include?(input)
  end

  def check_user_colors(user_colors)
    (0...4).each do |i|
      if @colors_code.include?(user_colors[i])
        @user_result[i] = '*'
        @user_result[i] = '**' if user_colors[i] == @colors_code[i]
      else
        @user_result[i] = ''
      end
    end
    @remaining_guesses -= 1
  end

  def user_won?
    @user_result.all? { |v| v == '**' }
  end

  def game_over?
    @remaining_guesses.zero?
  end

end
