# -*- encoding : utf-8 -*-
require_relative 'Modo'
require_relative 'ModoPartida'
# require_relative '../../src/persistencia/DAOUsuario'
# require_relative '../../src/persistencia/DAOLogBatalha'

class ModoNovoJogo < Modo

  def initialize(jogo)
    super jogo
    # @comandos = %w(help exit registrar login status iniciar vitorias)
    @comandos = %w(help exit add status start)
  end

  def prefixo
    l(Time.now).colorize(:blue) + ' ' + t('new-game') + ' ~> '
  end

  def add
      username = ask 'username: '
      user = Usuario.new username, '1234'
      @jogo.adicionar_usuario user
      success_msg t("user")+" #{user.username} "+t("user_added")
  end

  def registrar
    username = ask 'username: '
    senha = ask_encrypted 'senha: '
    senha_confirm = ask_encrypted 'confirmação de senha: '

    begin
      user = Usuario.register username, senha, senha_confirm
    rescue ArgumentError => e
      warning_msg e.to_s
      return
    end

    begin
      dao = DAOUsuario.new
      dao.create user.username, user.password
    rescue UsernameJaExistente => e
      warning_msg e.to_s
      return
    end

    success_msg t("user")+" #{username} "+t("user_registered")
  end

  def login
    username = ask 'username: '
    senha = ask_encrypted 'senha: '

    dao = DAOUsuario.new
    user = dao.read username, senha

    if !user then
      warning_msg "Usuário não existe ou a senha não confere"
      return
    end

    @jogo.adicionar_usuario user
    success_msg t("user")+" #{user.username} "+t("user_added")
  end

  def status
    if @jogo.jogadores.size == 0 then
      puts t("no_user")
      return
    end

    puts t("current_players")
    @jogo.jogadores.each do |jogador|
      puts "  ##{jogador.id} #{jogador.nome}"
    end
    puts ""
  end

  def start
    begin
      @jogo.iniciar
    rescue CitygameException => e
      error_msg e.to_s
      return
    end

    modo_partida = ModoPartida.new(@jogo)
    success_msg t("match_started")
    return modo_partida
  end

  def vitorias username
    dao = DAOLogBatalha.new
    batalhas = dao.read_batalhas_vencidas_por username

    return if batalhas.empty?

    puts  t("battle_won")+" #{username}"
    batalhas.each do |batalha|
      print "   #{batalha.turnos} turnos. Jogadores: "
      nomes = batalha.jogadores.map { |j| j.username }
      print nomes.join(', ')
      puts
    end
  end

end
