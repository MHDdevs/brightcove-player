module OoyalaPlayer
  class OoyalaTagsFetcher
    include Sidekiq::Worker

    def perform(ooyala_id)
      video = Video.find(ooyala_id)
      video.update_tags!
      video.update_meta!
      video.update_assets!
      logger.info "#{video.id} - #{video.tags}"
    end
  end
end