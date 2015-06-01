require "ar_pagination/helpers/sort"

module ArPagination::OffsetPagination
  class Page

    def initialize(scope, options = {})
      @scope = scope
      @limit = Integer(options[:limit] || options[:count] || 50)
      @offset = Integer(options[:offset] || 0)
      @sort = options[:sort]
    end

    def data
      @scope = ArPagination::Helpers::Sort.new(@scope).sort(@sort)

      @scope.offset(@offset).limit(@limit)
    end

    def params_for(direction)
      case direction
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
