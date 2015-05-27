module OffsetPagination
  class Page

    def initialize(scope, options = {})
      @scope = scope
      @limit = Integer(options[:limit] || options[:count] || 50)
      @offset = Integer(options[:offset] || 0)
    end

    def data
      @scope.offset(@offset).limit(@limit)
    end

    def params_for(dir)
      case dir
      when :first
        { offset: 0, count: @limit }
      when :next
        { offset: @limit + @offset, count: @limit }
      when :prev
        @limit > @offset ? { offset: @limit - @offset, count: @limit } : {}
      end
    end

  end
end
