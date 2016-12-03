# -*- encoding : utf-8 -*-
require 'colorize'
require 'readline'
require_relative '../../src/config/locale'
require_relative '../../src/Jogo'
require_relative 'CommandParser'
require_relative 'ModoNovoJogo'

jogo = Jogo.new
parser = CommandParser.new
modo = ModoNovoJogo.new jogo # Modo inicial

modo.clear

puts "".colorize :color => :light_cyan, :mode => :bold
puts " ______     __     ______   __  __     ______     ______     __    __     ______  ".colorize :color => :light_cyan, :mode => :bold
puts "/\\  ___\\   /\\ \\   /\\__  _\\ /\\ \\_\\ \\   /\\  ___\\   /\\  __ \\   /\\ \"-./  \\   /\\  ___\\   ".colorize :color => :light_cyan, :mode => :bold
puts "\\ \\ \\____  \\ \\ \\  \\/_/\\ \\/ \\ \\____ \\  \\ \\ \\__ \\  \\ \\  __ \\  \\ \\ \\-./\\ \\  \\ \\  __\\   ".colorize :color => :light_cyan, :mode => :bold
puts " \\ \\_____\\  \\ \\_\\    \\ \\_\\  \\/\\_____\\  \\ \\_____\\  \\ \\_\\ \\_\\  \\ \\_\\ \\ \\_\\  \\ \\_____\\ ".colorize :color => :light_cyan, :mode => :bold
puts "  \\/_____/   \\/_/     \\/_/   \\/_____/   \\/_____/   \\/_/\\/_/   \\/_/  \\/_/   \\/_____/ ".colorize :color => :light_cyan, :mode => :bold
puts "".colorize :color => :light_cyan, :mode => :bold
puts "".colorize :color => :light_cyan, :mode => :bold

puts t :welcome

# Caracter impresso após uma chamada de auto completar
Readline.completion_append_character = ' '

while modo.ativo do
  # Atribui o processo de auto completar ao interpretador de comandos
  Readline.completion_proc = modo.completion_proc

  # Lê um novo comando do input padrão, salvando no histórico de comandos
  input = Readline.readline(modo.prefixo, true)
  # Interpreta a string digitada
  command_hash = parser.parse(input)

  # Submete o comando ao modo de jogo atual, recebendo a instância do próximo
  # modo de jogo (pode ser o mesmo ou um novo)
  modo = modo.submeter_comando command_hash
end
