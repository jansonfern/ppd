require 'sinatra'
require 'action_cable'
require 'eventmachine'
require 'json'

class ChatServer < Sinatra::Base
  set :server, :puma
  set :bind, '0.0.0.0'
  set :port, 3000

  # Canal de Chat com ActionCable
  class ChatChannel < ActionCable::Channel::Base
    def subscribed
      stream_from "chat_#{params[:room]}"
    end

    def unsubscribed
      # Lógica para quando o usuário se desconectar
    end

    def send_message(data)
      # Transmitir mensagem para todos na mesma sala
      ActionCable.server.broadcast("chat_#{params[:room]}", message: data['message'])
    end
  end

  # Configuração do ActionCable
  configure do
    ActionCable.server.config.allow_request_origin = '*'
    ActionCable.server = ActionCable::Server::Base.new
  end

  # Rota principal (Serve para testes)
  get '/' do
    'Servidor de Chat em Tempo Real'
  end
end

# Iniciando o servidor
run ChatServer.run!
