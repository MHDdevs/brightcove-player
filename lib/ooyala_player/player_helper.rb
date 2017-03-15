module PlayerHelper
  def ooyala_player_include_tags
    javascript_include_tag("#{src_location}/core.min.js",
                       "#{src_location}/video-plugin/main_html5.min.js",
                       "#{src_location}/skin-plugin/html5-skin.min.js",
                       "#{src_location}/video-plugin/bit_wrapper.min.js",
                       "#{src_location}/ad-plugin/pulse.min.js") +
    stylesheet_link_tag("#{src_location}/skin-plugin/html5-skin.min.css")
  end

  def src_location
    "https://player.ooyala.com/static/v4/stable/#{OoyalaPlayer.version}"
  end

  def render_player video=nil, params={}, &block

    @player = OoyalaPlayer::Player.new video, params, current_user

    capture do
      concat render partial: 'player/partial'
      concat link_to block_given? ? capture(&block) : 'play video','#', data: { player_id: @player.block_id },
        class: "play-toggle #{params[:class]}"
    end
    # render partial: 'player/partial', locals: { video: video }
  end

  def render_player_wrapper video=nil, params={}
    @player = OoyalaPlayer::Player.new video, params, current_user

    capture do
      concat render partial: 'player/partial'
    end
  end

  def render_player_button video=nil, params={}, &block
    @player = OoyalaPlayer::Player.new video, params, current_user

    capture do
      concat link_to block_given? ? capture(&block) : 'play video','#', data: { player_id: @player.block_id },
        class: "play-toggle #{params[:class]}"
    end
  end

  def handler player
    return '' unless player.video
      content_tag :div, '', handler_options(player)
  end

  def handler_options player
    options = player.init_handler_options
    options['data-signed-embed-code'] = player.signed_embed_code_url
    options['data-player-version'] = OoyalaPlayer.version
    options['data-pcode'] = player.ooyala_pcode
    options['data-player-id'] = OoyalaPlayer.id
    options['data-pulse-tags'] = player.pulse_tags if player.pulse_tags.present?
    if player.params[:playhead_seconds].present?
      options['data-content-initial-time'] = player.params[:playhead_seconds].to_i
      options['data-content-stats-url'] = lesson_stat_path(player.video)
    end
    options
  end
end