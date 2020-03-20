require "hack_assembler"
require "hack_assembler/parser"
require "hack_assembler/code"
require "hack_assembler/symbol_table"

class HackAssembler::Cli
  def self.start(args)
    input = args[0]
    output = args[1].nil? ? $stdout : File.open(args[1], "w+")

    raise "Invalid file extension" unless File.extname(input) == ".asm"

    parser = HackAssembler::Parser.new(input)
    symbol_table = generate_symbol_table(parser.dup)
    while parser.has_more_commands?
      parser.advance!

      case parser.command_type
      when HackAssembler::CommandType::C_COMMAND
        output.puts(
          "111" +
          HackAssembler::Code.comp(parser.comp) +
          HackAssembler::Code.dest(parser.dest) +
          HackAssembler::Code.jump(parser.jump)
        )
      when HackAssembler::CommandType::A_COMMAND
        if parser.symbol == /^[0-9]+$/
          output.puts("0" + sprintf("%015b", parser.symbol.to_i))
        else
          symbol_table.add_entry(parser.symbol) unless symbol_table.contains?(parser.symbol)
          output.puts("0" + sprintf("%015b", symbol_table.get_address(parser.symbol)))
        end
      when HackAssembler::CommandType::L_COMMAND
      else
        raise "Invalid command type #{parser.command_type}"
      end
    end
  end

  private

  def self.generate_symbol_table(parser)
    symbol_table = HackAssembler::SymbolTable.new

    while parser.has_more_commands?
      parser.advance!

      if parser.command_type == HackAssembler::CommandType::L_COMMAND
        symbol_table.add_entry(parser.symbol, parser.next_line_number)
      end
    end

    symbol_table
  end
end
