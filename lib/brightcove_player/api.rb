module BrightcovePlayer
  class Api
    VIDEO_DATA_ENDPOINT = 'https://analytics.api.brightcove.com/v1/data'

    def token
      response = RestClient.post 'https://oauth.brightcove.com/v4/access_token',
        client_id: BrightcovePlayer.client_id,
        client_secret: BrightcovePlayer.client_secret,
        grant_type: 'client_credentials'

      token = JSON.parse(response)["access_token"]
    end

    def video_stat
      raw_video_stat.inject(Hash.new){|i, h| i[h['video']] = h['video_view']; i}
    end

    def raw_video_stat(offset=0, limit=500)
      r = RestClient.get VIDEO_DATA_ENDPOINT,
        {
          params: {
            accounts: BrightcovePlayer.account_id,
            limit: limit,
            offset: offset,
            dimensions: 'video'
          },
          Authorization: "Bearer #{token}",
          Accept: 'application/json'
        }

      r = JSON.parse(r)

      # this is last page
      return r['items'] if r['item_count'] < offset + limit

      # keep loading next pages
      r['items'] + raw_video_stat(offset+limit)

    rescue RestClient::Unauthorized
      {}
    end

  end
end
