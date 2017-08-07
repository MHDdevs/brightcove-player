module OoyalaPlayer
  class Video < ActiveRecord::Base
    self.primary_key = :ooyala_id
    @@_parents = []

    validates :ooyala_id, uniqueness: true, presence: true

    def update_tags
      OoyalaPlayer::OoyalaTagsFetcher.perform_async(ooyala_id)
    end

    def ooyala_get(element, params={})
      api = Ooyala::API.new(ENV['OOYALA_API_KEY'], ENV['OOYALA_SECRET_KEY'])
      data = api.get("assets/#{ooyala_id}/#{element}", params)
    end

    def update_tags!
      asset_labels = ooyala_get("labels")
      update tags: asset_labels['items'].map { |item| item['name'] }.join(',')
    end

    def update_meta!
      update meta: ooyala_get("metadata")
    end

    def update_assets!
      update assets: ooyala_get("", include: 'primary_preview_image')
    end

    def meta_embedURL
      url = "https://player.ooyala.com/iframe.html?ec=#{ooyala_id}&"
      url << "pcode=#{ ENV['OOYALA_API_KEY'].split('.')[0]}&"
      url << "pbid=#{ ENV['OOYALA_PLAYER_ID']}"
      url
    end

    def meta_name
      parent = parents.sample
      ( meta['name'] if meta.present? ) || parent.try(:title) || parent.try(:name) || parent.class.name
    end

    def meta_description
      parent = parents.sample
      ( meta['description'] if meta.present? ) || parent.try(:description) || parent.class.name
    end

    def meta_thumbnailUrl
      assets.dig('primary_preview_image', 'url_ssl') if assets.present?
    end

    def meta_uploadDate
      assets.dig('created_at') if assets.present?
    end

    def meta_duration
      duration = assets && assets['duration']
      return nil if duration.nil?
      Duration.new(duration/1000).iso8601
    end

    def parents
      r = []
      @@_parents.each do |parent|
        klass = Object.const_get parent[:name]
        a = klass.where("#{ActiveRecord::Base.connection.quote_column_name parent[:column]} = ?", ooyala_id).to_a
        a = a.map(&:globalized_model) if parent[:name].include? 'Translation'
        r << a if a.present?
      end
      r.flatten
    end

    def self.add_with_videos(hash)
      @@_parents << hash unless hash.in? @@_parents
    end
  end
end
