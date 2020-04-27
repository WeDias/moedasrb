# ------------------------------------------------------------- #
#                                          Moedasrb             #
#                                       Github:@WeDias          #
#                                    Licença: MIT License       #
#                                Copyright © 2020 Wesley Dias   #
# ------------------------------------------------------------- #

#Fonte: https://dolarhoje.com/

require "httparty"
require "nokogiri"

class Moeda
  attr_reader :preco, :nome
  def initialize(nome="dolar")
    # initialize() Serve para buscar os dados de uma determinada moeda
    # :param nome: str, nome da moeda
    # :return: true se os dados foram coletados com sucesso
    @nome = nome.downcase
    if @nome == "dolar"
      link = "https://dolarhoje.com/"
    else
      link = "https://dolarhoje.com/#{@nome}-hoje"
    end
    resposta = HTTParty.get(link).body
    resposta = Nokogiri::HTML.parse(resposta)
    @preco = resposta.css('input#nacional')[0]['value'].gsub(',', '.').to_f
    return true
  end

  def precof
    # precof() Serve para retornar o preco da moeda formatado
    # :return: str, preco formatado
    return "R$ #{"%.2f" % @preco}"
  end

  def converter(valor=1)
    # converter() Serve para retornar o preco da moeda multiplicado por algum valor
    # :param valor: number, multiplicador
    # :return: number, preco multiplicado
    return @preco * valor
  end

  def converterf(valor=1)
    # converterf() Serve para retornar o preco da moeda multiplicado por algum valor e formatado
    # :param valor: number, multiplicador
    # :return: str, preco multiplicado formatado
    return "R$ #{"%.2f" % (@preco * valor)}"
  end
end

dolar = Moeda.new("dolar")
euro = Moeda.new("euro")
puts "Dolar #{dolar.precof}\nEuro #{euro.precof}"
