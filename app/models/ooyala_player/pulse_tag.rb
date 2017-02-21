module OoyalaPlayer
  class PulseTag < ApplicationRecord
    self.primary_key = :ooyala_id

    def update_tags
      OoyalaTagsFetcher.perform_async(ooyala_id)
    end
  end
end
