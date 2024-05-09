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
    start
  end

  def start
    input = nil
    puts 'Do you want to be the Creator of the secret color or the Guesser? (c/g)'
    until input && %w[c g].include?(input)
      input = gets.chomp.downcase
      puts 'Invalid input, try again: ' if input != 'c' && input != 'g'
    end
    guesser if input == 'g'
    creator if input == 'c'
  end

  def creator
    @game_mode = 'creator'
    50.times { print '-' }
    puts
    print COLORS
    user_input
  end

  def guesser
    @game_mode = 'guesser'
    generate_code
  end

  def user_input
    puts "\nRemaining guesses #{remaining_guesses}.\n"
    print COLORS if @game_mode == 'guesser'
    puts
    user_colors = []
    puts "Please choose four colors."
    4.times do
      puts 'choose a color: '
      user_color = gets.chomp
      until valid_input?(user_color, user_colors)
        puts "Invalid input, please choose from the colors above and don\'t repeat colors.\nColor: "
        user_color = gets.chomp
      end
      user_colors << user_color
    end
    @colors_code = user_colors if @game_mode == 'creator'
    60.times { print '-' }
    user_colors
  end

  def show_result(player_colors)
    puts "\nRemaining guesses #{remaining_guesses}."
    print "Computer selected: #{player_colors}" if game_mode == 'creator'
    check_selected_colors(player_colors)
    puts if @game_mode == 'guesser'
    print "You selected: #{player_colors}" if game_mode == 'guesser'
    print @selected_colors_indicator
    puts
    puts "\n'*' => indicate that player hase selected a correct color but not in the correct position." if @first_turn
    puts "'**' => indicate that player hase selected the correct color in the correct position." if @first_turn
    @first_turn = false
    60.times { print '-' }
    result_message
  end

  def result_message
    puts "\n\nCongratulations! You won!" if player_won? && game_mode == 'guesser'
    puts "\n\nComputer won!" if player_won? && @game_mode == 'creator'
    puts "\n\nGame Over" if game_over? && game_mode == 'guesser'
    puts "\n\nGame Over, Computer Lost!" if game_over? && @game_mode == 'creator'
  end

end
