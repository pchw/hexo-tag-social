util = require 'hexo-util'
htmlTag = util.html_tag
rUrl = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[.\!\/\\w]*))?)/
rMeta = /["']?([^"']+)?["']?\s*["']?([^"']+)?["']?/
jade = require 'jade'

class HatenaBookmark
  TYPES:
    SMALL: "simple"
    LARGE: "standard"
  DISPLAY_TYPES:
    VISIBLE: "balloon"
    UNVISIBLE: "noballoon"
    VERTICAL: "vertical-balloon"
  LANGS:
    JA: "ja"
    EN: "en"
  constructor: ({@type, @display_type, @lang, @title, @url})->
    @type = @TYPES.LARGE unless @type
    
    # 表示形式が指定されてない時は縦表示
    unless @display_type
      @layout = @display_type = @DISPLAY_TYPES.VERTICAL 

    # 縦表示以外はTYPEとDISPLAY_TYPEからlayoutを決定
    if @display_type isnt @DISPLAY_TYPES.VERTICAL 
      @layout = "#{@type}-#{@display_type}"
    
    @lang = @LANGS.JA unless @lang

  getHtmlCode: ->
    fn = jade.compileFile "#{__dirname}/templates/hatena_bookmark_button.jade", {}
    fn
      display_type: @display_type
      layout: @layout
      lang: @lang
      type: @type


class TweetButton
  TYPES:
    SHARE: 1
    FOLLOW: 2
    HASHTAGS: 3
    TWEET: 4
  COUNT_TYPES:
    NONE: 'none'
    HORIZONTAL: 'horizontal'
    VERTICAL: 'vertical'

  constructor: ({@type, @username, @recommend_username, @hashtag, @size, @count, @lang, @via})->
    @type = @TYPES.SHARE unless @type
    @lang = 'en'
    @count = @COUNT_TYPES.VERTICAL unless @count

  getHtmlCode: ->
    fn = jade.compileFile "#{__dirname}/templates/tweet_button.jade", {}
    fn
      count: @count
      lang: @lang

class FacebookButton
  LAYOUTS:
    STANDARD: 1
    BOX_COUNT: 'box_count'
    BUTTON_COUNT: 3
    BUTTON: 4
  ACTIONS:
    LIKE: 'like'
    RECOMEND: 'recommended'
  constructor: ({@layout, @action, @is_show_faces})->
    @layout = @LAYOUTS.BOX_COUNT unless @layout
    @action = @ACTIONS.LIKE unless @action

  getHtmlCode: ->
    fn = jade.compileFile "#{__dirname}/templates/facebook_like_button.jade", {}
    fn
      layout: @layout
      action: @action

class PocketButton
  constructor: ->

  getHtmlCode: ->
    fn = jade.compileFile "#{__dirname}/templates/pocket_button.jade", {}
    do fn

hexo.extend.tag.register 'social', (args, content)->
  hb = new HatenaBookmark({})
  tw = new TweetButton({})
  fb = new FacebookButton({})
  pt = new PocketButton({})

  fn = jade.compileFile "#{__dirname}/templates/layout.jade", {}
  fn
    hb: do hb.getHtmlCode
    tw: do tw.getHtmlCode
    fb: do fb.getHtmlCode
    pt: do pt.getHtmlCode

