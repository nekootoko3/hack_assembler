require "hack_assembler"

class HackAssembler::Cli
    input_file = args[0]
    output_file = args[1]
    parser = HackAssembler::Parser.new(input_file)
  end
end
