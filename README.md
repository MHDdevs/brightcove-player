# Ooyala Player Gem

Adding player for models with ootala_id fields.

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
    player.forward_url = 'https://www.mhdpro.com'
  end
```

Currently supported only 4.11.13 version

Include required files:

  - in application.scss `@import "ooyala_player";`
  - in application.js `//= require ooyala_player`
  - Include 3d party files via helper `ooyala_player_include_tags`

## Usage

### Model

This gem is adding ooyala video player and pulse_tags relation for models.

First, include lib file to models.
```ruby
extend OoyalaPlayer::Ooyalable
```
For all models add this line in file `ApplicationRecord < ActiveRecord::Base`
Or, just add it in particular models.

To connect player lib with model add
```ruby
ooyalable :column_with_ooyala_id_name
```
Parameter is optional, by default player looks for `ooyala_video_id` column.

It's possible to add more than one video to model. Just be sure, that they have
different params.

To get pulse tags use method `:pulse_tags`,
or `:pulse_tags_for_column_with_ooyala_id_name` if using with patameter.

### View

Now you can add player layout with this helper:
```ruby
render_player @collection, as: :ooyala_preview_id, class: 'btn btn-default btn-take'
```

This will generate to html:
```html
<div class="video-overlay" id="player_ooyala_preview_id_collection_1">
  <div class="ooyala-wrapper">
    <button class="btn btn-info close-button uppercase">
      <span>Close</span>
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

First argument - `@collection` - class instance, with `ooyalable` method.
Second argument - hash with parameters.

Currently avaliable params are:
- as: 'column_with_ooyala_id_name' - method name, returns ooyala_id;
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

- Add I18n support
- Add gem requirements
- Deal with N+1 tags relation
- Add worker to update tags
- Add tests
- Write generator for initializer and migration

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

