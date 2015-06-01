module ArPagination::Helpers
  class Sort

    def initialize(scope)
      @scope = scope
    end

    def sort(sort)
      order_hash = {}
      order_options = sort.split(',') if sort
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
      @scope
    end

  end
end
