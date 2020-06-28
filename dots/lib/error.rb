# frozen_string_literal: true

require_relative './constant'

module Error
  # Unknown Dotfile passed to Dots::Dots.install
  class UnknownDot < StandardError
  end

  # Name Invariant wasn't upheld
  #
  # Name MUST exist and not be empty
  class NameInvError < StandardError
    def initialize(path, hash)
      @path = path
      @hash = hash
      super('')
    end

    def to_s
      name = @hash[NAME]
      "name invariant broken for '#{name}'\n❌ '#{@path}' MUST exist"
    end
  end

  # Destination invariant wasn't upheld
  #
  # Destination must exist if it doesn't then prompt_instructions must exist and
  # not be empty
  class DestInvError < StandardError
    def initialize(hash)
      super('')
      @hash = hash
    end

    def to_s
      dest = @hash[DESTINATION]
      name = @hash[NAME]
      prompt = @hash[PROMPT_INSTRUCTIONS]
      "destination invariant broken for '#{name}'\n❌ #{dest} was nil and #{prompt} is also nil"
    end
  end

  # install_children invariant wasn't upheld
  #
  # install_children is optional, if it does exist
  # - dir MUST be a directory
  # - dir MUST have children
  class InstChildrInvError < StandardError
    def initialize(dir, hash)
      super('')
      @dir = dir
      @hash = hash
    end

    def to_s
      name = @hash[NAME]
      "install_children invariant broken for '#{name}'\n" + directory_msg + children_msg
    end

    private

    def directory_msg
      File.directory?(@dir) ? "✅ #{@dir} is a directory\n" : "❌ #{@dir} is NOT a directory\n"
    end

    def children_msg
      return '' unless File.directory?(@dir)

      dir = Dir.new(@dir)
      msg = if dir.children.empty?
          "❌ #{@dir} MUST have at least one child"
        else
          "✅ #{@dir} has #{dir.children.size} children"
        end
      dir.close
      msg
    end
  end

  # exclude invariant wasn't upheld
  #
  # exclude is optional, if it does exist
  # - dir MUST be a directory
  # - All of exclude MUST be in the directory dir
  class ExcludeInvError < StandardError
    def initialize(dir, hash)
      @dir = dir
      @hash = hash
      super('')
    end

    def to_s
      name = @hash[NAME]
      "exclude invariant broken for '#{name}'\n" + directory_msg + exclude_msg
    end

    private

    def directory_msg
      File.directory?(@dir) ? "✅ #{@dir} is a directory\n" : "❌ #{@dir} is NOT a directory\n"
    end

    def exclude_msg
      exclude = @hash['exclude']
      return '' unless File.directory?(@dir)

      exclude&.reduce('') do |msg, excl|
        path = File.join(@dir, excl)
        val = File.exist?(path) ? "✅ #{excl} exists\n" : "❌ #{excl} does NOT exist\n"
        msg + val
      end
    end
  end

  # doctor_command invariant
  #
  # doctor_command is optional, if it does exist
  # - doctor_command when invoked must return 0
  class DocCmdInvError < StandardError
    def initialize(hash)
      @hash = hash
      super('')
    end

    def to_s
      name = @hash[NAME]
      doc_cmd = @hash[DOCTOR_COMMAND]
      "doctor_command invariant broken for '#{name}'\n❌ Expected '$ #{doc_cmd}' to return 0"
    end
  end
end
