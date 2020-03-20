require "hack_assembler"
require "hack_assembler/parser"
require "hack_assembler/code"

class HackAssembler::Cli
  def self.start(args)
    input = args[0]
    output = args[1].nil? ? $stdout : File.open(args[1], "w+")

    parser = HackAssembler::Parser.new(input)
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
        output.puts("0" + sprintf("%015b", parser.symbol.to_i))
      when HackAssembler::CommandType::L_COMMAND
      else
        raise "Invalid command type #{parser.command_type}"
      end
    end
  end
end
