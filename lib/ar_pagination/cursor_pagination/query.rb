module ArPagination::CursorPagination
  class Query

    # @param [ActiveRecord::Relation] scope inwhich to find current page
    # @option [Symbol] scope `:id` key to use for the cursor
    def initialize(scope, cursor_key = :id)
      @scope = scope
      @cursor_key = cursor_key
    end

    # Fetch record for given cursor
    #
    # @see https://dev.twitter.com/overview/api/cursoring
    # @option [Fixnum] cursor
    # @option [Fixnum] count
    # @return [Pagination::Page] dataset including next&prev cursors
    def fetch(cursor: -1, count: 50, sort: "")

      # 1. sort if required
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

      # 2. only need array of cursor keys from scope
      scope_keyed = @scope.pluck(@cursor_key)

      cursor = 0 if cursor == -1

      # check direction
      window =
        if cursor.to_s.first == "-"
          cursor = cursor.is_a?(Integer) ? cursor.abs : cursor.to_s[1..-1]
          backward(@scope, scope_keyed.index(cursor), count)
        else
          forward(@scope, scope_keyed.index(cursor), count)
        end

      Page.new(window, cursor, @cursor_key, count: count)
    end

    private

    def forward(scope, cursor_index, count)
      if cursor_index == 0
        if count < scope.size # Index at count elements is not the end
          return scope[cursor_index..count].unshift(nil)
        else
          return scope[cursor_index..(count-1)].unshift(nil).push(nil)
        end
      end

      if count >= (scope.size - cursor_index)
        return scope[(cursor_index - 1)..-1].push(nil)
      end

      return scope[(cursor_index - 1)..(count + 1)]
    end

    def backward(scope, cursor_index, count)
      if (cursor_index + 1) - count <= 0 # check the returned data elements will include the first element in scope
        if (cursor_index + 1) == scope.size # cursor is last element in array
          return scope[0..cursor_index].unshift(nil).push(nil)
        else
          return scope[0..(cursor_index+1)].unshift(nil)
        end
      end

      # Check if cursor element is the last element
      if (cursor_index + 1) == scope.size # cursor is last element in array
        return scope[(cursor_index - count)..cursor_index].push(nil)
      end

      return scope[(cursor_index - count)..cursor_index+1]
    end

  end
end
