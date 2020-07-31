module HackAssembler
  class SymbolTable
    PREDEFINED_SYMBOL_TABLE = {
      "SP" => 0,
      "LCL" => 1,
      "ARG" => 2,
      "THIS" => 3,
      "THAT" => 4,
      "R0" => 0, "R1" => 1, "R2" => 2, "R3" => 3,
      "R4" => 4, "R5" => 5, "R6" => 6, "R7" => 7,
      "R8" => 8, "R9" => 9, "R10" => 10, "R11" => 11,
      "R12" => 12, "R13" => 13, "R14" => 14, "R15" => 15,
      "SCREEN" => 16384,
      "KBD" => 24576,
    }.freeze
    INITIAL_VARIABLE_ADDRESS = 16

    def initialize
      @symbol_table = PREDEFINED_SYMBOL_TABLE
      @current_address = INITIAL_VARIABLE_ADDRESS
    end

    def add_entry(symbol, address = @current_address)
      return if contains?(symbol)

      @symbol_table[symbol] = address
      @current_address += 1 if address == @current_address
    end

    def contains?(symbol)
      @symbol_table.has_key?(symbol)
    end

    def get_address(symbol)
      @symbol_table[symbol]
    end
  end
end
