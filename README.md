# Ooyala Player Gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ooyala_player', git: 'git@github.com:MHDdevs/ooyala-player.git'
```

Add initializer:

```ruby
  OoyalaPlayer.configure do |player|
    player.version = ENV['OOYALA_PLAYER_VERSION']
    player.id = ENV['OOYALA_PLAYER_ID']
    player.ooyala_api_key = ENV['OOYALA_API_KEY']
    player.ooyala_secret_key = ENV['OOYALA_SECRET_KEY']
  end
```
Include required files:
  - in application.scss `@import "ooyala_player";`
  - in application.js `//= require ooyala_player`
  - Include 3d party files via helper `ooyala_player_include_tags`

## Requirements

  Model must have field with ooyala_id.
  Model should belongs to PulseTag.

## Usage

This gem is adding ooyala video player.

Now you can add player layout with this helper:
```ruby
render_player @collection, as: :ooyala_preview_id, class: 'btn btn-default btn-take'
```

This will generate to html:
```html
<div class="video-overlay" id="player_ooyala_preview_id_collection_1">
  <div class="ooyala-wrapper">
    <button class="btn btn-info close-button uppercase">
      <span class="translation_missing" title="translation missing: en.videos.actions.close">Close</span>
      <i class="fa fa-close"></i>
    </button>
    <div class="js-ooyalaplayer-block ooyalaplayer-block">
      <div class="js-player-handler" id="handler_collection_1" data-content-id="..."
         data-signed-embed-code="..." data-player-version="4.11.13"
         data-pcode="..." data-player-id="...">
      </div>
    </div>
  </div>
</div>
<a data-player-id="player_ooyala_preview_id_collection_1" class="play-toggle btn btn-default btn-take" href="#">play video</a>
```

First argument - `@collection` - class instance, with `ooyala_video_id` method.
Second argument - hash with parameters.

Currently avaliable params are:
- as: 'some_new_field_with_ooyala_id' - method name, returns ooyala_id;
- playhead_seconds: 42 - video starts from this second. If this key set, sending statisitic to `lesson_stat_path()`.
  If no this key set, video appears to be preview.
- class: 'btn' - html classes for link wrapper.

Passing block.

```ruby
=render_player @collection, as: :ooyala_preview_id, class: 'btn btn-default btn-take' do
  span.glyphicon.glyphicon-play-circle
  = _('Watch preview')
```
Passed block will be placed inside link.
```html
...
<a data-player-id="player_ooyala_preview_id_collection_1" class="play-toggle btn btn-default btn-take" href="#">
<span class="glyphicon glyphicon-play-circle"></span>
Watch preview
</a>
```

## TODO

- Add PulseTag to this gem
- Write generator for initializer and migration
- Add tests
- Add oolayable method, for models

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

