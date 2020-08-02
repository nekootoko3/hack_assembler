require "hack_assembler"
require "hack_assembler/parser"
require "hack_assembler/code"
require "hack_assembler/symbol_table"

module HackAssembler
  class Cli
    def self.start
      new.start
    end

    attr_reader :asm_file, :output

    def initialize
      @asm_file = ARGV[0]
      @output = ARGV[1].nil? ? $stdout : File.open(ARGV[1], "w+")
    end

    def start
      raise ArgumentError, "Invalid file extension" unless File.extname(asm_file) == ".asm"

      parser = Parser.new(asm_file)
      symbol_table = SymbolTable.new(parser.dup)
      while parser.has_more_commands?
        parser.advance!

        case parser.command_type
        when CommandType::C_COMMAND
          output.puts(
            "111" +
            Code.comp(parser.comp) +
            Code.dest(parser.dest) +
            Code.jump(parser.jump)
          )
        when CommandType::A_COMMAND
          if parser.symbol =~ /^[0-9]+$/
            output.puts("0" + sprintf("%015b", parser.symbol.to_i))
          else
            symbol_table.add_entry(parser.symbol) unless symbol_table.contains?(parser.symbol)
            output.puts("0" + sprintf("%015b", symbol_table.get_address(parser.symbol)))
          end
        when CommandType::L_COMMAND
        else
          raise "Invalid command type #{parser.command_type}"
        end
      end
    ensure
      output.close
    end
  end
end
