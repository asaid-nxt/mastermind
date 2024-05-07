# frozen_string_literal: true

require_relative 'game_brain'
# Game class
class Game < GameBrain
  def initialize(game_name)
    super()
    @game_name = game_name
    welcome
  end

  def welcome
    puts "\n\nWelcome to #{@game_name}!"
    20.times { print '-' }
    puts
  end

  def start
    puts "\nYou have #{remaining_guesses} guesses.\n"
    print COLORS
    user_input
  end

  def user_input
    user_colors = []
    puts "\nPlease choose four colors."
    4.times do
      puts 'Color: '
      user_color = gets.chomp
      until valid_input?(user_color, user_colors)
        puts 'Invalid input, please choose from the colors above and don\'t repeat colors.\n Color: '
        user_color = gets.chomp
      end
      user_colors << user_color
    end
    show_result(user_colors)
  end

  def show_result(user_colors)
    check_user_colors(user_colors)
    puts
    print @colors_code
    puts
    print @user_result
    puts "\n'*' => indicate that you have selected a correct color but not the correct position."
    puts "'**' => indicate that you have selected the correct color in the correct position."
    60.times { print '-' }
    result_message
  end

  def result_message
    puts "\n\nCongratulations! You won!" if user_won?
    puts "\n\nGame Over" if game_over?
  end

end
