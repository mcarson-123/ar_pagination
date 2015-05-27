module RespondWithPage
  extend ActiveSupport::Concern

  private

  def respond_with_page(page)
    render json: {
      data:  serialize_page(page),
      links: {
        first: build_url_for(page, :first),
        last:  nil, # @note find efficient way if needed
        next:  build_url_for(page, :next),
        prev:  build_url_for(page, :prev)
      }
    }
  end

  def serialize_page(page)
    ActiveModel::ArraySerializer.new(page.data, url_options: url_options, scope: current_user)
  end

  def query_options
    params.slice(:count, :offset, :cursor)
  end

  def build_url_for(page, direction)
    url_params = page.params_for(direction)
    url_for(url_params.reverse_merge(params)) if url_params[:cursor]
  end
end
