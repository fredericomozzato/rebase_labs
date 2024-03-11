module CustomErrors
  class InvalidCsvHeader < StandardError
    def message
      'Cabeçalho fora das especificações'
    end
  end

  class InvalidFileExtension < StandardError
    def message
      'Arquivo não é CSV'
    end
  end
end
