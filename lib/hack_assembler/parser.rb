require "hack_assembler"

module HackAssembler
  class Parser
    A_COMMAND = "A_COMMAND"
    C_COMMAND = "C_COMMAND"
    L_COMMAND = "L_COMMAND"

    attr_reader :next_line_number

    def initialize(asm_file)
      File.open(asm_file) do |f|
        @commands = remove_comment_and_space(f.readlines.map {|line| line.strip })
      end
      @current_command = nil
      @next_line_number = 0
    end

    def add_labels!(symbol_table)
      label_count = 0
      while has_more_commands?
        advance!

        if command_type == L_COMMAND
          label_count += 1
          symbol_table.add_entry(symbol, next_line_number - label_count)
        end
      end
    end

    def has_more_commands?
      !@commands[@next_line_number].nil?
    end

    def advance!
      raise "No new command exists" unless has_more_commands?

      @current_command = @commands[@next_line_number]
      @next_line_number += 1
    end

    def command_type
      case @current_command[0]
      when "@"; A_COMMAND
      when "("; L_COMMAND
      else C_COMMAND
      end
    end

    # @return [String]
    def symbol
      return unless symbol_enabled?

      case command_type
      when A_COMMAND
        @current_command.match(/@(.*)/).to_a[1]
      when L_COMMAND
        @current_command.match(/\((.*)\)/).to_a[1]
      else
        raise "only A or C command are allowed"
      end
    end

    def dest
      return unless command_type == C_COMMAND

      @current_command.match(/(.*)=.*/).to_a[1]
    end

    def comp
      return unless command_type == C_COMMAND

      @current_command.match(/.*=(.*)/).to_a[1] ||
        @current_command.match(/(.*);.*/).to_a[1]
    end

    def jump
      return unless command_type == C_COMMAND

      @current_command.match(/.*;(.*)/).to_a[1]
    end

    private

    def remove_comment_and_space(commands)
      commands.map do |c|
        c.sub!(/\s+/, "")
        c.sub!(/\/\/.*/, "")
        c.empty? ? nil : c
      end.compact
    end

    def symbol_enabled?
      [
        Parser::A_COMMAND,
        Parser::L_COMMAND,
      ].include?(command_type)
    end
  end
end
