# frozen_string_literal: true

# ------------------------------------------------------------- #
#                                          moedasrb             #
#                                       Github:@WeDias          #
#                                    Licenca: MIT License       #
#                                Copyright c 2020 Wesley Dias   #
# ------------------------------------------------------------- #

# Fonte: https://dolarhoje.com/

require 'httparty'
require 'nokogiri'

# Main serve para obter o valor de moedas no site dolarhoje.com
class Moedas
  attr_reader :preco, :nome
  def initialize(nome = 'dolar')
    # initialize() Serve para buscar os dados de uma determinada moeda
    # :param nome: str, nome da moeda
    # :return: true se os dados foram coletados com sucesso
    @nome = nome.downcase
    link = if @nome == 'dolar'
             'https://dolarhoje.com/'
           else
             "https://dolarhoje.com/#{@nome}-hoje"
           end
    resposta = HTTParty.get(link).body
    resposta = Nokogiri::HTML.parse(resposta)
    @preco = resposta.css('input#nacional')[0]['value'].gsub(',', '.').to_f
  end

  def precof
    # precof() Serve para retornar o preco da moeda formatado
    # :return: str, preco formatado
    "R$ #{@preco.round(2)}"
  end

  def converter(valor = 1)
    # converter() Serve para retornar o preco da moeda
    # multiplicado por algum valor
    # :param valor: number, multiplicador
    # :return: number, preco multiplicado
    @preco * valor
  end

  def converterf(valor = 1)
    # converterf() Serve para retornar o preco da moeda multiplicado
    # por algum valor e formatado
    # :param valor: number, multiplicador
    # :return: str, preco multiplicado formatado
    "R$ #{(@preco * valor).round(2)}"
  end
end

dolar = Moedas.new('dolar')
euro = Moedas.new('euro')
puts "Dolar #{dolar.precof}\nEuro #{euro.precof}"
