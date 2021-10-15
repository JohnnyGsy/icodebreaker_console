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

    def process_question(codebreaker)
      user_input I18n.t('game.process', attempts: codebreaker.attempts_total - codebreaker.attempts_used,
                                        hints: codebreaker.hints_total - codebreaker.hints_used)
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
      stats = IcodebreakerGem::Storage.sort_codebreakers
      rows = []
      stats.map.with_index do |codebreaker, index|
        rows << [index + 1, codebreaker[:name], codebreaker[:difficulty], codebreaker[:attempts_total],
                 codebreaker[:attempts_used], codebreaker[:hints_total], codebreaker[:hints_used]]
      end
      puts Terminal::Table.new(
        headings: ['Rating', 'Name', 'Difficulty', 'Attempts Total', 'Attempts Used', 'Hints Total', 'Hints Used'],
        rows: rows
      )
    end
  end
end
