class TopicController < ApplicationController
  def index
    limit = params[:limit].presence || 3
    if limit.to_i == 0
      limit = 3
    elsif limit.to_i > 10
      limit = 10
    end

    current_page = params[:page].presence || 1
    if current_page.to_i == 0
      current_page = 1
    end
    keyword = params[:keyword].presence

    begin
      topics = Topic.search({
        keyword: keyword,
        order: :id,
        limit: limit,
        page: current_page,
      })
    rescue => e
      logger.error(e.message)
      logger.error(e.backtrace.join("\n"))
      return render json: { error: 500 }
    end

    paging = {
      total: topics.total_count,
      total_pages: topics.num_pages,
      per_page: limit,
      current_page: current_page,
    }

    render json: { topics: topics, paging: paging }
  end
end
