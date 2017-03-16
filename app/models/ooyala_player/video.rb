module OoyalaPlayer
  class Video < ApplicationRecord
    include OoyalaPlayer::VideosAdmin
    self.primary_key = :ooyala_id

    has_many :collections, class_name: Collection::Translation, foreign_key: 'ooyala_preview_id'
    has_many :lessons, class_name: Lesson::Translation, foreign_key: 'ooyala_video_id'

    def update_tags
      OoyalaTagsFetcher.perform_async(ooyala_id)
    end

    def update_tags!
      api = Ooyala::API.new(ENV['OOYALA_API_KEY'], ENV['OOYALA_SECRET_KEY'])
      begin
        asset_labels = api.get("assets/#{ooyala_id}/labels")
      rescue Exception => e
        return e
      end
      update tags: asset_labels['items'].map { |item| item['name'] }.join(',')
    end

    def parents
      settings = Setting.where(value: ooyala_id)
      (settings + (collections + lessons).map(&:globalized_model))
    end
  end
end
