# frozen_string_literal: true

require_relative 'game'

game = Game.new('Mastermind')

game.start until game.game_over? || game.user_won?
