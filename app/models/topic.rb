class Topic < ActiveRecord::Base
  include Tire::Model::Search

  after_save :index_update
  after_destroy :index_remove

  index_name("#{Rails.env}-search-topics")
  mapping do
    indexes :id
    indexes :title, analyzer: :kuromoji
    indexes :body, analyzer: :kuromoji
  end

  # save後にindexを更新
  def index_update
    self.index.store self
  end

  # destroy後にindexから削除
  def index_remove
    self.index.remove self
  end

  # 検索
  def self.search(params)
    tire.search(load: true, :page => params[:page], per_page: params[:limit]) do
      query {
        boolean do
          should { string 'title:' + params[:keyword].gsub('"', '\\"'), default_operator: "AND" }
          should { string 'body:' + params[:keyword].gsub('"', '\\"'), default_operator: "AND" }
        end
      } if params[:keyword].present?
      sort do
        by params[:order], 'desc'
      end
    end
  end
end
