module BrightcovePlayer
  class Player
    attr_accessor :object_with_video
    attr_accessor :video
    attr_accessor :params

    def initialize(object_with_video, params, user)
      @object_with_video = object_with_video
      @params = params
      @video = if @params[:as].present?
          @object_with_video.send("video_for_#{@params[:as]}")
        else
          @object_with_video.video
        end
      @user = user
    end

    def init_handler_options
      {
        class: 'js-player-handler',
        id: generate_div_id,
        'data-content-id': @video.id
      }
    end

    def init_brightcove_handler_options
      {
        class: 'video-js vjs-16-9',
        id: generate_div_id,
        'data-id': generate_div_id,
        'data-video-id': @video.id,
        'data-account': BrightcovePlayer.account_id,
        'data-player': BrightcovePlayer.player_id,
        'data-embed': BrightcovePlayer.embed,
        'data-application_id': true,
        playsinline: true,
        controls: true,
      }
    end

    def generate_div_id
      r = "handler_#{@object_with_video.class.name.downcase}_#{@object_with_video.try(:id)||0}"
      r << '_preview' if @params[:as] == :brightcove_preview_id
      r
    end

    # Code from Ooyala API documentation:
    # http://support.ooyala.com/developers/documentation/reference/player_v3_dev_xdsample.html
    def signed_embed_code_url(video_embed_code=nil)
      video_embed_code ||= @video.id
      params_hash = {}

      uri = URI.parse(generate_ooyala_url(video_embed_code))

      uri.query.split('&').map { |pair| pair.split('=', 2) }.each do |key, value|
        params_hash[CGI.unescape(key).to_sym] = (value && CGI.unescape(value)) if key && !key.empty? && value
      end

      "#{uri}&signature=#{generate_signature(uri.path, params_hash)}"
    end

    def ooyala_pcode
      BrightcovePlayer.ooyala_api_key.split('.').first
    end

    def block_id
      r = 'player_'
      r << "#{@params[:as]}_" if @params[:as].present?
      r << "#{@object_with_video.class.name.downcase}_#{@object_with_video.try(:id)||0}"
    end

    def pulse_tags
      @video.tags
    end

    def meta
      @video.meta || {}
    end

    private

    def generate_ooyala_url(video_embed_code)
      url = "https://player.ooyala.com/sas/embed_token/#{BrightcovePlayer.ooyala_api_key.split('.').first}/#{video_embed_code}?"
      url << "account_id=#{@user.id}&" if @user.present?
      url << "api_key=#{BrightcovePlayer.ooyala_api_key}&"
      url << "expires=#{24.hours.from_now.to_i}"
      # "&override_syndication_group=override_all_synd_groups"
      url
    end

    def generate_signature(path, params)
      Ooyala::API.new(BrightcovePlayer.ooyala_api_key, BrightcovePlayer.ooyala_secret_key).generate_signature('GET', path, params)
    end
  end
end
