module OoyalaPlayer
  class Player
    attr_accessor :video
    attr_accessor :params

    def initialize(video, params, user)
      @video = video
      @params = params
      @user = user
    end

    def init_handler_options
      {
        class: 'js-player-handler',
        id: generate_div_id,
        'data-content-id': video_id
      }
    end

    def generate_div_id
      r = "handler_#{@video.class.name.downcase}_#{@video.try(:id)||0}"
      r << '_preview' if @params[:as] == :ooyala_preview_id
      r
    end

    def video_id
      if @params[:as].present?
        @video.send(@params[:as])
      else
        @video.ooyala_video_id
      end
    end

    # Code from Ooyala API documentation:
    # http://support.ooyala.com/developers/documentation/reference/player_v3_dev_xdsample.html
    def signed_embed_code_url(video_embed_code=nil)
      video_embed_code ||= video_id
      params_hash = {}

      uri = URI.parse(generate_ooyala_url(video_embed_code))

      uri.query.split('&').map { |pair| pair.split('=', 2) }.each do |key, value|
        params_hash[CGI.unescape(key).to_sym] = (value && CGI.unescape(value)) if key && !key.empty? && value
      end

      "#{uri}&signature=#{generate_signature(uri.path, params_hash)}"
    end

    def ooyala_pcode
      OoyalaPlayer.ooyala_api_key.split('.').first
    end

    def block_id
      r = 'player_'
      r << "#{@params[:as]}_" if @params[:as].present?
      r << "#{@video.class.name.downcase}_#{@video.try(:id)||0}"
    end

    private

    def generate_ooyala_url(video_embed_code)
      url = "https://player.ooyala.com/sas/embed_token/#{OoyalaPlayer.ooyala_api_key.split('.').first}/#{video_embed_code}?"
      url << "account_id=#{@user.id}&" if @user.present?
      url << "api_key=#{OoyalaPlayer.ooyala_api_key}&"
      url << "expires=#{24.hours.from_now.to_i}"
      # "&override_syndication_group=override_all_synd_groups"
      url
    end

    def generate_signature(path, params)
      Ooyala::API.new(OoyalaPlayer.ooyala_api_key, OoyalaPlayer.ooyala_secret_key).generate_signature('GET', path, params)
    end
  end
end
