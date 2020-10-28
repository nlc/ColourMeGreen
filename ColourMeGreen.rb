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

  # ["b", "3", "D", "10", "R", "5", "L", "U"]
  def parse_directionals(dir_commands)
    num = 1

    dir_commands.each_with_index do |dir_command, i|
      if i == 0 && dir_command.match(/[br]/)
        case dir_command
        when 'b'
          # Move to beginning of word TODO
        when 'r'
          # Move to beginning of line TODO
        end
      elsif dir_command.match?(/\d+/)
        # Set movement number
        num = dir_command.to_i
      elsif dir_command.match(/[UDRL]/)
        # Send the movement command
        send_movement(dir_command.to_sym, num)
        num = 1
      end
    end
  end

  # private

  def set_config(param, value)
    # TODO
    puts "fixme | set #{param} to #{value}"
  end

  def return_word
    # TODO
  end

  def return_line
    print "\r"
  end

  def send_attribute(signal_key)
    print "\033[#{@KEY_TO_ATTRIBUTE[signal_key]}"
  end

  def send_movement(signal_key, amount)
    print "\033[#{amount > 0 ? amount : ''}#{@KEY_TO_MOVEMENT[signal_key]}"
  end

  def send_location(x, y)
    print "\033[#{y};#{x}H"
  end

  # NOTE: Keeping track of what ASCII special chars we've used
  #       Ideally we won't use any more than once
  #        !@#$%^    -_+={}|:,
  #       ~      &*()
  def parse_command(str)
    str.gsub!(/[{}]/, '')
    str.split(/ *\| */).each do |subcommand|
      sigil = subcommand.chars[0]
      case sigil
      when '+' # push attribute
        push_attribute(subcommand[1..-1].strip.to_sym)
      when '-' # pop attribute
        num = subcommand[1..-1].strip
        pop_attribute(num.length.zero? ? 1 : num == '%' ? :all : num.to_i)
      when ':' # directional commands
        dir_commands = subcommand[1..-1].scan(/(^b|\d+|[UDRL])/).flatten
        parse_directionals(dir_commands)
      when '@' # location command
        coords = subcommand[1..-1].match(/\d+ *, *\d+/).to_s.split(/ *, */).map(&:to_i)
        send_location(*coords)
      else
      end
    end
  end

  #TODO
  def parse_non_command(str)
    print str
  end

  def parse_config_line(line)
    matches = line.gsub(/^ *!! */, '').match(/(\w+) *= *(\w+)/)
    if matches.length >= 3
      param, value = matches[1], matches[2]

      set_config(param, value)
    end
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
        parse_config_line(line.gsub(/ *#.*/, ''))
      else
        # regular line
        parse_regular_line(line)
      end
    end
  end
end
