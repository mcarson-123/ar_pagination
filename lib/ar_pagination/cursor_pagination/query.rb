module Pagination
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
    def fetch(cursor: -1, count: 50, **options)
      cursor, count = cursor.to_i, count.to_i
      window = count + 2 # Fetch extra two elements for concrete next/prev links

      if cursor >= 0
        page = @scope.where(@cursor_key => -Float::INFINITY..cursor).limit(window)
      else
        cursor = cursor == -1 ? 0 : cursor.abs
        page = @scope.where(@cursor_key => cursor..Float::INFINITY).limit(window)
      end

      # Ensure result set is in correct order
      page = page.order(@cursor_key => :desc)

      Page.new(page, cursor, count: count)
    end
  end
end
