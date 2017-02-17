module PlayerHelper
  p '--------------------------------------------------------------------------'
  p 'Helper'

  @video
  @params

  def ooyala_player_include_tags
    javascript_include_tag("#{src_location}/core.min.js",
                       "#{src_location}/video-plugin/main_html5.min.js",
                       "#{src_location}/skin-plugin/html5-skin.min.js",
                       "#{src_location}/video-plugin/bit_wrapper.min.js",
                       "#{src_location}/ad-plugin/pulse.min.js") +
    stylesheet_link_tag("#{src_location}/skin-plugin/html5-skin.min.css")
  end

  def src_location
    "https://player.ooyala.com/static/v4/stable/#{Player.version}"
  end

  def render_player video=nil, params={}, &block

    capture do
      concat render partial: 'player/partial', locals: {video: video, params: params}
      concat content_tag :span,  block_given? ? capture(&block) : 'play video', data: { player_id: player_block_id(video, params) }, class: 'play-toggle'
    end
    # render partial: 'player/partial', locals: { video: video }
  end


  def player_handler(video, params = {}) # playhead_seconds: 0, preview: false)
    return '' unless video

    options = set_player_handler_options(video, params)

    content_tag :div, '', options
  end

  def set_player_handler_options(video, params)
    options = init_player_handler_options(video, params)
    options['data-signed-embed-code'] = signed_embed_code_url(video_id(video, params))
    options['data-player-version'] = Player.version
    options['data-pcode'] = ooyala_pcode
    options['data-player-id'] = Player.id
    options['data-pulse-tags'] = video.pulse_tags.tags if video.pulse_tags.present?
    if params[:playhead_seconds].present?
      options['data-content-initial-time'] = params[:playhead_seconds].to_i
      options['data-content-stats-url'] = lesson_stat_path(video)
    end
    options
  end

  def init_player_handler_options(video, params)
    {
      class: 'js-player-handler',
      id: generate_div_id(video, params),
      'data-content-id': video_id(video, params)
    }
  end

  def generate_div_id(video, params)
    params[:as] == :preview ? "#{dom_id(video)}-preview" : dom_id(video)
  end

  def video_id(video, params)
    p '2-----------------------------------------------------------------------'
    p @video
    p @params
    if params[:as].present?
      video.send("ooyala_#{params[:as]}_id")
    else
      video.ooyala_video_id
    end
  end

  # Code from Ooyala API documentation:
  # http://support.ooyala.com/developers/documentation/reference/player_v3_dev_xdsample.html
  def signed_embed_code_url(video_embed_code)
    params_hash = {}

    uri = URI.parse(generate_ooyala_url(video_embed_code))

    uri.query.split('&').map { |pair| pair.split('=', 2) }.each do |key, value|
      params_hash[CGI.unescape(key).to_sym] = (value && CGI.unescape(value)) if key && !key.empty? && value
    end

    "#{uri}&signature=#{generate_signature(uri.path, params_hash)}"
  end

  def ooyala_pcode
    ENV['OOYALA_API_KEY'].split('.').first
  end

  def player_block_id video, params
    p video
    r = 'player-'
    r << "#{params[:as]}-" if params[:as].present?
    r << "dom_id(video)"
  end

  private

  def generate_ooyala_url(video_embed_code)
    url = "https://player.ooyala.com/sas/embed_token/#{Player.ooyala_api_key.split('.').first}/#{video_embed_code}?"
    url << "account_id=#{current_user.id}&" if current_user.present?
    url << "api_key=#{Player.ooyala_api_key}&"
    url << "expires=#{24.hours.from_now.to_i}"
    # "&override_syndication_group=override_all_synd_groups"
    url
  end

  def generate_signature(path, params)
    Ooyala::API.new(Player.ooyala_api_key, Player.ooyala_secret_key).generate_signature('GET', path, params)
  end
end
