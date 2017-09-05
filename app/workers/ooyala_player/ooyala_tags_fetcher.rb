module OoyalaPlayer
  class OoyalaTagsFetcher
    include Sidekiq::Worker

    def perform(ooyala_ids)
      Video.update_data(ooyala_ids)
    end
  end
end
