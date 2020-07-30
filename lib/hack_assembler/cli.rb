require "hack_assembler"
require "hack_assembler/parser"
require "hack_assembler/code"
require "hack_assembler/symbol_table"

module HackAssembler
  class Cli
    def self.start(args)
      input = args[0]
      output = args[1].nil? ? $stdout : File.open(args[1], "w+")

      raise "Invalid file extension" unless File.extname(input) == ".asm"

      parser = Parser.new(input)
      symbol_table = generate_symbol_table(parser.dup)
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

    private

    def self.generate_symbol_table(parser)
      label_count = 0
      symbol_table = SymbolTable.new

      while parser.has_more_commands?
        parser.advance!

        if parser.command_type == CommandType::L_COMMAND
          label_count += 1
          symbol_table.add_entry(parser.symbol, parser.next_line_number - label_count)
        end
      end

      symbol_table
    end
  end
end
