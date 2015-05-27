module OffsetPagination
  class Page

    def initialize(scope, options = {})
      @scope = scope
      @limit = Integer(options[:limit] || options[:count] || 50)
      @offset = Integer(options[:offset] || 0)
      @sort = options[:sort]
    end

    def data
      # sort
      order_hash = {}
      order_options = @sort.split(',') if @sort
      Array.wrap(order_options).each do |order_option|
        case order_option.first
        when '-'
          direction = :desc
        when '+'
          direction = :asc
        else
          next
        end
        sort_attr = order_option[1..-1]
        order_hash[sort_attr.to_sym] = direction
      end
      @scope = @scope.order(order_hash) unless order_hash.empty?

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
