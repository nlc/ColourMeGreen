class ColourMeGreen
  attr_accessor :KEY_TO_ATTRIBUTE, :KEY_TO_MOVEMENT
  attr_accessor :attribute_stack

  def initialize
    @KEY_TO_ATTRIBUTE = {
      Reset: '0m',
      Bold: '1m',
      Faint: '2m',
      Underline: '4m',
      Blink: '5m',
      Reverse: '7m',
      Invisible: '8m',

      BLACK: '30m',
      RED: '31m',
      GREEN: '32m',
      YELLOW: '33m',
      BLUE: '34m',
      MAGENTA: '35m',
      CYAN: '36m',
      WHITE: '37m',

      black: '40m',
      red: '41m',
      green: '42m',
      yellow: '44m',
      blue: '44m',
      magenta: '45m',
      cyan: '46m',
      white: '47m'
    }

    @KEY_TO_MOVEMENT = {
      U: 'A',
      D: 'B',
      R: 'C',
      L: 'D'
    }

    @attribute_stack = []
  end

  def push_attribute(signal_key)
    @attribute_stack.push(signal_key)
    send_attribute(signal_key)
  end

  # FIXME: this is inefficient, replace with table of opposites
  def pop_attribute(num = 1)
    if num == :all
      @attribute_stack.clear
    else
      num.times do
        @attribute_stack.pop
      end
    end

    send_attribute(:Reset)
    @attribute_stack.each do |signal_key|
      send_attribute(signal_key)
    end
  end

  # private

  def send_attribute(signal_key)
    print "\033[#{@KEY_TO_ATTRIBUTE[signal_key]}"
  end

  def send_movement(signal_key, amount)
    print "\033[#{amount > 0 ? amount : ''}#{@KEY_TO_MOVEMENT[signal_key]}"
  end

  def parse_command(str)
    str.gsub!(/[{}]/, '')
    str.split(/ *\| */).each do |subcommand|
      sigil = subcommand.chars[0]
      case sigil
      when '+'
        # push attribute
        push_attribute(subcommand[1..-1].strip.to_sym)
      when '-'
        # pop attribute
        num = subcommand[1..-1].strip
        pop_attribute(num == '%' ? :all : num.to_i)
      else
      end
    end
  end

  #TODO
  def parse_non_command(str)
    print str
  end

  # TODO
  def parse_config_line(line)
    puts 'fixme'
  end

  def parse_regular_line(line)
    # Not sure if the following method of splitting is brilliant or disgusting
    pattern = /{[^}]*}/
    line_commands = line.scan(pattern)
    line_non_commands = line.split(pattern)

    [line_commands, line_non_commands].map(&:length).max.times do |i|
      line_command = line_commands[i]
      line_non_command = line_non_commands[i]

      parse_non_command(line_non_command) unless line_non_command.nil?
      parse_command(line_command) unless line_command.nil?
    end

    puts
  end

  def parse(source)
    source.split(/\n/).each_with_index do |line, i|
      case line
      when /^ *#/
        # comment line; do nothing
      when /^ *!!/
        # configuration line
        parse_config_line(line)
      else
        # regular line TODO
        parse_regular_line(line)
      end
    end
  end
end
