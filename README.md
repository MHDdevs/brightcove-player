# Brightcove Player Gem

Adding player for models with brigtcove_id fields.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'brightcove-player', git: 'git@github.com:MHDdevs/brightcove-player.git'
```

Add initializer:

```ruby
  BrightcovePlayer.configure do |player|
    player.table_name = 'ooyala_videos'
    player.stat_model = 'video_stat'
    player.stat_method = :create
    player.airbrake = { id: ENV['AIRBRAKE_ID'],
                        key: ENV['AIRBRAKE_KEY'] }

    player.account_id = ENV['BRIGHTCOVE_ACCOUNT_ID']
    player.player_id  = ENV['BRIGHTCOVE_PLAYER_ID']
    player.client_id = ENV['BRIGHTCOVE_CLIENT_ID']
    player.client_secret = ENV['BRIGHTCOVE_CLIENT_SECRET']
  end
```
  - `player.table_name` - table name for storing ooyala video-data
    mhd - 'ooyala_videos',
    pro - 'videos',
    default 'videos'
  - `player.stat_model` - model, that stores stat data (playhead seconds, etc.)
    mhd - 'video_stat',
    pro - 'lesson_stat'
    default - 'lesson_stat'
  - `player.stat_method` - type of request. MHD creates stat object, while PRO update it.
    mhd - :create,
    pro - :patch
    default - :patch

Currently supported only 4.13.5 version

Include required files:

  - in application.scss `@import "brightcove-player";`
  - in application.js `//= require brightcove-player`
  - Include 3d party files via helper `brightcove_player_include_tags`

## Usage

### Model

This gem is adding ooyala video player and video relation for models.

First, include lib file to models.
```ruby
extend BrightcovePlayer::Brightcoveable
```
For all models add this line in file `ApplicationRecord < ActiveRecord::Base`
Or, just add it in particular models.

To connect player lib with model add
```ruby
brightcoveable :column_with_brightcove_id_name
```
Parameter is optional, by default player looks for `brightcove_video_id` column.

It's possible to add more than one video to model. Just be sure, that they have
different params.

To get video object use method `:video`,
or `:video_for_column_with_ooyala_id_name` if using with patameter.

### Multilanguage support

If `:column_with_brightcove_id_name` is globalized, then `brightcoveable :column_with_brightcove_id_name`
should be plased after `translates` method.

Gem adds `:video(locale=nil)` method and
`video_locale` methods, where locales are from avaliable locales.
If you have custom column name, then methods will be named
`video_for_column_with_brightcove_id_name_locale`


### View

Now you can add player layout with this helper:
```ruby
render_player @collection, as: :brightcove_preview_id, class: 'btn btn-default btn-take'
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
      <video class="js-video" id="handler_collection_1"...
      </video>
    </div>
  </div>
</div>
<a data-player-id="player_ooyala_preview_id_collection_1" class="play-toggle btn btn-default btn-take" href="#">play video</a>
```

First argument - `@collection` - class instance, with `brightcoveable` method.
Second argument - hash with parameters.


It is pissible to separate button and player container in view.
use
```=render_player_wrapper @video``` for container
and ```=render_player_button @video``` for button

Currently avaliable params are:
- as: 'column_with_brightcove_id_name' - method name, returns brightcove_id;
- playhead_seconds: 42 - video starts from this second. If this key set, sending statisitic to `lesson_stat_path()`.
  If no this key set, video appears to be preview.
- class: 'btn' - html classes for link wrapper.

Passing block.

```ruby
=render_player @collection, as: :brightcove_preview_id, class: 'btn btn-default btn-take' do
  span.glyphicon.glyphicon-play-circle
  = _('Watch preview')
```
Passed block will be placed inside link.
```html
...
<a data-player-id="player_brightcove_preview_id_collection_1" class="play-toggle btn btn-default btn-take" href="#">
<span class="glyphicon glyphicon-play-circle"></span>
Watch preview
</a>
```

### rails_admin support

This gem add's video table to rails admin interface
Video has brightcove_id.
Parents column has links to objects, that use this video.

## OoyalaPlayer::Video

## TODO

- Add gem requirements
- Deal with N+1 tags relation
- Add worker to update tags
- Add tests
- Write generator for initializer and migration

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

