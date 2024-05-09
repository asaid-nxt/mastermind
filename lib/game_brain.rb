# frozen_string_literal: true

# GameBrain class
class GameBrain
  attr_reader :selected_colors_indicator, :remaining_guesses, :game_mode, :colors_code, :computer_colors

  INDEX = [0, 1, 2, 3].freeze
  COLORS = %w[red blue green yellow grey purple black white].freeze

  def initialize
    @colors_code = []
    @selected_colors_indicator = Array.new(4) { '' }
    @remaining_guesses = 7
    @game_mode = ''
    @computer_colors = COLORS.sample(4)
    @first_turn = true
    @selected_indexes = []
    @selected_colors = []
    @right_color_wrong_position = {}
  end

  def generate_code
    @colors_code = COLORS.sample(4)
  end

  def valid_input?(input, user_colors)
    COLORS.include?(input) && !user_colors.include?(input)
  end

  # updating colors indicator
  def check_selected_colors(picked_colors)
    (0...4).each do |i|
      if @colors_code.include?(picked_colors[i])
        @selected_colors_indicator[i] = '*'
        @selected_colors_indicator[i] = '**' if picked_colors[i] == @colors_code[i]
      else
        @selected_colors_indicator[i] = ''
      end
    end
    @remaining_guesses -= 1
  end

  def player_won?
    @selected_colors_indicator.all? { |v| v == '**' }
  end

  def game_over?
    @remaining_guesses.zero?
  end

  # Computer playing strategy
  def computer_input
    return @computer_colors if @first_turn

    right_color_right_position
    right_colors
    wrong_colors
    add_new_colors
    @computer_colors
  end

  # check if selected color is the right color and in the right position
  def right_color_right_position
    index = INDEX - @selected_indexes
    index.each do |i|
      if @colors_code[i] == @computer_colors[i]
        @selected_indexes << i
        @selected_colors << @computer_colors[i]
        if @right_color_wrong_position.include?(@computer_colors[i])
          @right_color_wrong_position.delete(@computer_colors[i])
        end
      end
    end
  end

  # check if selected color in color code
  def right_colors
    index = INDEX - @selected_indexes
    index.each do |i|
      if @colors_code.include?(@computer_colors[i])
        @selected_colors << @computer_colors[i]
        @right_color_wrong_position[@computer_colors[i]] = i
      end
    end
  end

  # detecting wrong selected colors
  def wrong_colors
    index = INDEX - @selected_indexes
    index.each do |i|
      unless @colors_code.include?(@computer_colors[i])
        @selected_colors << @computer_colors[i]
      end
    end
  end

  # adding new colors and changing position for right colors but wrong positions
  def add_new_colors
    index = INDEX - @selected_indexes

    # handling right colors but wrong position
    unless @right_color_wrong_position == {}
      reserved_indexes = []
      @right_color_wrong_position.each do |k, v|
        i = (index - reserved_indexes - [v]).sample
        i = v if i.nil?
        @computer_colors[i] = k
        reserved_indexes << i
      end
      index -= reserved_indexes
    end

    # handling wrong colors
    colors = COLORS - @selected_colors
    index.each do |i|
      random_color = colors.sample
      while @computer_colors.include?(random_color) && @selected_colors.size < 5
        random_color = colors.sample
      end
      @computer_colors[i] = random_color
    end
  end

end
