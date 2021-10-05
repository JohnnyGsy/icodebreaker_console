# frozen_string_literal: true

require './config'

class Ui
  include UiSupport

  def run
    loop do
      puts I18n.t('game.menu')
      case UiSupport.user_input
      when I18n.t('command.start') then start
      when I18n.t('command.rules') then puts I18n.t('game.rules')
      when I18n.t('command.statistics') then UiSupport.statistics
      when I18n.t('command.exit') then exit
      else puts I18n.t('command.error_command') end
    end
  end

  def start
    @codebreaker = IcodebreakerGem::Game.new
    player_data
    game
  end

  def player_data
    name_enter
    difficulty_enter
  end

  def name_enter
    loop do
      name = UiSupport.name_question
      begin
        @codebreaker.validate_name(name)
        @codebreaker.name = name
        break
      rescue ArgumentError
        puts I18n.t('game.name_length_error')
      end
    end
  end

  def difficulty_enter
    loop do
      difficulty = UiSupport.difficulty_question.to_sym

      begin
        @codebreaker.validate_difficulty(difficulty)
        @codebreaker.difficulty = difficulty
        break
      rescue StandardError
        puts I18n.t('game.difficulty_input_error')
      end
    end
  end

  def game
    loop { break if defeat? || process? }
    new_game
  end

  def process?
    case guess = UiSupport.process_question
    when I18n.t('command.exit') then exit
    when I18n.t('command.hint')
      hint
      false
    else
      return false unless attempt_guess(guess).eql?('++++')

      win
      true
    end
  end

  def win
    puts I18n.t('game.win')
    if UiSupport.save_result_question == I18n.t('command.agree')
      IcodebreakerGem::Storage.save_storage(@codebreaker.game_data)
    end
  end

  def hint
    puts @codebreaker.hint
  end

  def attempt_guess(guess)
    entered_guess = guess
    loop do
      @codebreaker.validate_code(entered_guess)
      puts @codebreaker.attempt(guess)
      break
    rescue ArgumentError
      puts I18n.t('game.guess_input_error')
      entered_guess = UiSupport.guess_question
    end
  end

  def defeat?
    return false if @codebreaker.result != :lose

    puts @codebreaker.code
    true
  end

  def new_game
    start if UiSupport.new_game_question == I18n.t('command.agree')
  end
end
