module Pagination
  class Page

    attr_reader :count
    attr_accessor :first, :last

    # param [Array] window in current window
    # param [Fixnum] cursor previous cursor
    # option [Fixnum] count
    def initialize(window, cursor, count: 20)
      @window = window.to_a
      @cursor = cursor
      @count = count

      @prev_element = @window.shift if @window.first.try(:id) == @cursor
      @next_element = @window.pop while @window.length > @count
      @first = -1
    end

    def data
      # consume last element if at the end of the sequence
      if @window.length < @count
        data = @window + [@next_element]
        data.compact
      else
        @window
      end
    end

    def next
      if @window.length == @count && @next_element
        @window.last.id
      end
    end

    # TODO Add reverse order
    def prev
      # -@window.first.id if @prev_element
    end

    def params_for(dir)
      case dir
      when :first
        { cursor: first, count: @count }
      when :next
        { cursor: self.next, count: @count }
      when :prev
        { cursor: prev, count: @count }
      end
    end

  end
end
