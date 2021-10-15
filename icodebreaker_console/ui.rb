# frozen_string_literal: true

require './config'

class Ui
  include UiSupport

  def run
    puts I18n.t('game.introdaction_message')
    $stdin.getch
    system('clear')
    loop do
      puts I18n.t('game.menu')
      case UiSupport.user_input
      when I18n.t('command.start') then start
      when I18n.t('command.rules') then puts I18n.t('game.rules')
      when I18n.t('command.statistics') then UiSupport.statistics
      when I18n.t('command.exit') then abort I18n.t('game.goodbye_message')
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
    name = UiSupport.name_question
    if @codebreaker.validate_name(name)
      @codebreaker.name = name
    else
      puts I18n.t('game.name_length_error')
      name_enter
    end
  end

  def difficulty_enter
    difficulty = UiSupport.difficulty_question.to_sym
    if @codebreaker.validate_difficulty(difficulty)
      @codebreaker.difficulty = difficulty
    else
      puts I18n.t('game.difficulty_input_error')
      difficulty_enter
    end
  end

  def game
    loop { break if defeat? || process? }
    new_game
  end

  def process?
    case guess = UiSupport.process_question(@codebreaker)
    when I18n.t('command.exit') then exit
    when I18n.t('command.hint')
      hint
      false
    else attempt_guess(guess) end
  end

  def win
    puts @codebreaker.code.secret
    puts I18n.t('game.win')
    loop do
      case UiSupport.user_input
      when I18n.t('command.save') then IcodebreakerGem::Storage.save_storage(@codebreaker.game_data) && new_game
      when I18n.t('command.exit') then abort I18n.t('game.goodbye_message')
      else puts I18n.t('command.error_command') end
    end
  end

  def hint
    puts @codebreaker.hint
  end

  def attempt_guess(guess)
    if @codebreaker.validate_code(guess)

      puts @codebreaker.attempt(guess)
      return unless @codebreaker.result == :win

      win
    else
      puts I18n.t('game.guess_input_error')
      process?
    end
  end

  def defeat?
    return if @codebreaker.result != :lose

    system('clear')
    puts I18n.t('game.lose')
    puts @codebreaker.code.secret
    true
  end

  def new_game
    puts I18n.t('game.new_game')
    loop do
      case UiSupport.user_input
      when I18n.t('command.new') then start
      when I18n.t('command.exit') then abort I18n.t('game.goodbye_message')
      else puts I18n.t('command.error_command') end
    end
  end
end
