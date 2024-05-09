# frozen_string_literal: true

require_relative 'game'

game = Game.new('Mastermind')

until game.game_over? || game.player_won?
  user_input = game.user_input if game.game_mode == 'guesser'
  game.show_result(user_input) if game.game_mode == 'guesser'
  game.show_result(game.computer_input) if game.game_mode == 'creator'
end
