# frozen_string_literal: true

module CustomErrors
  class TestNotFound < StandardError
    def message
      'Teste não encontrado'
    end
  end

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
