# frozen_string_literal: true

require './config'
module UiSupport
  class << self
    def name_question
      user_input I18n.t('registration.name')
    end

    def difficulty_question
      user_input I18n.t('game.difficulty')
    end

    def process_question
      user_input I18n.t('game.process')
    end

    def new_game_question
      user_input I18n.t('game.new_game')
    end

    def guess_question
      user_input I18n.t('game.guess')
    end

    def save_result_question
      user_input I18n.t('game.save_result')
    end

    def user_input(custom_question = '')
      puts custom_question
      print '>'
      gets.chomp
    end

    def statistics
      puts Terminal::Table.new(
        headings: ['Name', 'Difficulty', 'Attempts Total', 'Attempts Used', 'Hints Total', 'Hints Used'],
        rows: IcodebreakerGem::Storage.sort_codebreakers
      )
    end
  end
end
