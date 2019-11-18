module PlayerHelper
  def brightcove_player_include_tags
    javascript_include_tag "//players.brightcove.net/#{BrightcovePlayer.account_id}/"+
      "#{BrightcovePlayer.player_id}_#{BrightcovePlayer.embed}/index.min.js"
  end

  def render_player video=nil, params={} , &block

    @player = BrightcovePlayer::Player.new video, params, nil

    capture do
      concat render partial: 'player/partial'
      concat link_to block_given? ? capture(&block) : 'play video','#', data: { player_id: @player.block_id },
        class: "play-toggle #{params[:class]}"
    end
    # render partial: 'player/partial', locals: { video: video }
  end

  def render_player_wrapper video=nil, params={}
    @player = BrightcovePlayer::Player.new video, params, nil

    capture do
      concat render partial: 'player/partial'
    end
  end

  def render_player_button video=nil, params={}, &block
    @player = BrightcovePlayer::Player.new video, params, nil

    capture do
      concat link_to block_given? ? capture(&block) : 'play video','#', data: { player_id: @player.block_id },
        class: "play-toggle #{params[:class]}"
    end
  end

  def handler player
    return '' unless player.object_with_video
    content_tag(:video,'', handler_options(player))
  end

  def handler_options player
    path = BrightcovePlayer.stat_model
    path += 's' if BrightcovePlayer.stat_method == :create
    path += '_path'

    options = player.init_brightcove_handler_options

    if player.params[:playhead_seconds].present?
      options['data-content-initial-time'] = player.params[:playhead_seconds].to_i
      options['data-content-stats-url'] = send(path, player.object_with_video)
    end
    if player.params[:playlist_id]
      options['data-mhd-playlist-id'] = player.params[:playlist_id].to_i
      options['data-page-video-ids'] = player.params[:page_video_ids].to_a
    end
    options
  end
end
