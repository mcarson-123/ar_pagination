module ArPagination::CursorPagination
  class Page

    attr_reader :count
    attr_accessor :first, :last

    # param [Array] window in current window
    # param [Fixnum] cursor previous cursor
    # option [Fixnum] count
    def initialize(window, cursor, cursor_key, count: 20)
      @window = window
      @cursor = cursor
      @cursor_key = cursor_key
      @count = count
    end

    def data
      @window[1..-2]
    end

    def next
      @window.last.nil? ? nil : @window.last.try(@cursor_key)
    end

    def prev
      @window.first.nil? ? nil : @window.first.try(@cursor_key)
    end

    def params_for(dir)
      case dir
      when :first
        { cursor: cursor, count: @count }
      when :next
        { cursor: self.next, count: @count }
      when :prev
        { cursor: self.prev, count: @count }
      end
    end

  end
end
