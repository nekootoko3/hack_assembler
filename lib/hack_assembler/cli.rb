require "hack_assembler"
require "hack_assembler/parser"
require "hack_assembler/code"
require "hack_assembler/symbol_table"

module HackAssembler
  class Cli
    def self.start
      new.start
    end

    attr_reader :asm_file, :output_file

    def initialize
      @asm_file = ARGV[0]
      @output_file = ARGV[1]
    end

    def start
      raise ArgumentError, "Invalid file extension" unless File.extname(asm_file) == ".asm"

      parser = Parser.new(asm_file)
      symbol_table = SymbolTable.new(parser)
      while parser.has_more_commands?
        parser.advance!

        case parser.command_type
        when Parser::C_COMMAND
          output.puts(
            "111" +
            Code.comp(parser.comp) +
            Code.dest(parser.dest) +
            Code.jump(parser.jump)
          )
        when Parser::A_COMMAND
          if parser.symbol =~ /^[0-9]+$/
            output.puts("0" + sprintf("%015b", parser.symbol.to_i))
          else
            symbol_table.add_entry(parser.symbol) unless symbol_table.contains?(parser.symbol)
            output.puts("0" + sprintf("%015b", symbol_table.get_address(parser.symbol)))
          end
        when Parser::L_COMMAND
        else
          raise "Invalid command type #{parser.command_type}"
        end
      end
    ensure
      output.close
    end

    private

    def output
      return @output if defined?(@output)

      @output = output_file.nil? ? $stdout : File.open(output_file, "w+")
    end
  end
end
