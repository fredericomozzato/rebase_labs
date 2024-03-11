module CustomErrors
  class InvalidHeadersError < StandardError
    def message
      'Cabeçalho fora das especificações'
    end
  end
end
