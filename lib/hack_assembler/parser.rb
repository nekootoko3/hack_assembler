require "hack_assembler"
require "hack_assembler/command_type"

module HackAssembler
  class Parser
    attr_reader :next_line_number

    def initialize(input_file)
      File.open(input_file) do |f|
        @commands = remove_comment_and_space(f.readlines.map {|line| line.strip })
      end
      @current_command = nil
      @next_line_number = 0
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
      when "@"; CommandType::A_COMMAND
      when "("; CommandType::L_COMMAND
      else CommandType::C_COMMAND
      end
    end

    # @return [String]
    def symbol
      return unless symbol_enabled?

      case command_type
      when CommandType::A_COMMAND
        @current_command.match(/@(.*)/).to_a[1]
      when CommandType::L_COMMAND
        @current_command.match(/\((.*)\)/).to_a[1]
      else
        raise "only A or C command are allowed"
      end
    end

    def dest
      return unless command_type == CommandType::C_COMMAND

      @current_command.match(/(.*)=.*/).to_a[1]
    end

    def comp
      return unless command_type == CommandType::C_COMMAND

      @current_command.match(/.*=(.*)/).to_a[1] ||
        @current_command.match(/(.*);.*/).to_a[1]
    end

    def jump
      return unless command_type == CommandType::C_COMMAND

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
        CommandType::A_COMMAND,
        CommandType::L_COMMAND,
      ].include?(command_type)
    end
  end
end
