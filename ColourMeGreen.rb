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

  def send_attribute(signal_key)
    print "\033[#{@KEY_TO_ATTRIBUTE[signal_key]}"
  end

  def send_movement(signal_key, amount)
    print "\033[#{amount > 0 ? amount : ''}#{@KEY_TO_MOVEMENT[signal_key]}"
  end
end
