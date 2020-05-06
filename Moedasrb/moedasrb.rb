# frozen_string_literal: true

# moedasrb.rb
# Github:@WeDias

# MIT License

# Copyright (c) 2020 Wesley Ribeiro Dias

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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

if __FILE__ == $PROGRAM_NAME
  dolar = Moedas.new('dolar')
  euro = Moedas.new('euro')
  puts "Dolar #{dolar.precof}\nEuro #{euro.precof}"
end
