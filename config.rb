# frozen_string_literal: true

require 'icodebreaker_gem'
require 'terminal-table'
require 'i18n'
require './icodebreaker_console/ui_support'
require './icodebreaker_console/ui'

I18n.load_path << Dir[['config', 'locales', '**', '*.yml'].join('/')]
