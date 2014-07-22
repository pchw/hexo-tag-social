util = require("../../util")
htmlTag = util.html_tag
rUrl = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[.\!\/\\w]*))?)/
rMeta = /["']?([^"']+)?["']?\s*["']?([^"']+)?["']?/

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
  constructor: (@type, @display_type, @lang)->
    @type = @TYPES.LARGE unless @type
    
    # 表示形式が指定されてない時は縦表示
    @layout = @DISPLAY_TYPES.VERTICAL unless @display_type

    # 縦表示以外はTYPEとDISPLAY_TYPEからlayoutを決定
    if @display_type isnt @DISPLAY_TYPES.VERTICAL 
      @layout = "#{@type}-#{@display_type}"
    
    @lang = @LANGS.JA unless @langs

  getHtmlCode: ->
    """
    <a href="http://b.hatena.ne.jp/entry/#{@url}" 
       class="hatena-bookmark-button" 
      data-hatena-bookmark-title="#{@title}" 
      data-hatena-bookmark-layout="#{@display_type}"
      data-hatena-bookmark-lang="#{@lang}"
      title="このエントリーをはてなブックマークに追加">
      <img src="http://b.st-hatena.com/images/entry-button/button-only@2x.png"
           alt="このエントリーをはてなブックマークに追加"
           width="20"
           height="20"
           style="border: none;" />
    </a>
    <script type="text/javascript" 
            src="http://b.st-hatena.com/js/bookmark_button.js" 
            charset="utf-8" 
            async="async"></script>
    """

class TweetButton
  TYPES:
    SHARE: 1
    FOLLOW: 2
    HASHTAGS: 3
    TWEET: 4
  COUNT_TYPES:
    NONE: 1
    HORIZONTAL: 1
    VERTICAL: 2

  constructor: (@type, @username, @recommend_username, @hashtag, @size, @count, @lang)->
    @type = @TYPES.SHARE unless @type
    @lang = 'en'
    @count = @COUNT_TYPES.VERTICAL unless @count

class FacebookButton
  LAYOUTS:
    STANDARD: 1
    BOX_COUNT: 2
    BUTTON_COUNT: 3
    BUTTON: 4
  ACTIONS:
    LIKE: 1
    RECOMEND: 2
  constructor: (@layout, @action, @is_show_faces)->
    @layout = @LAYOUTS.BOX_COUNT unless @layout
    @action = @ACTIONS.LIKE unless @action

class FeedlyButton
  BUTTON_TYPES:
    FLAT_LARGE: 1
  constructor: (@type)->
    @type = @BUTTON_TYPES.FLAT_LARGE unless @type
    
  getHtmlCode: ->

###
Social Tag

Syntax:
{% social %}
###
# module.exports = (args, content) ->
#   classes = []
#   meta = ""
#   width = undefined
#   height = undefined
#   title = undefined
#   alt = undefined
#   src = undefined
  
#   # Find image URL and class name
#   i = 0
#   len = args.length

#   while i < len
#     item = args[i]
#     if rUrl.test(item)
#       src = item
#       break
#     else
#       if item[0] is "/"
#         src = item
#         break
#       else
#         classes.push item
#     i++
  
#   # Delete image URL and class name from arguments
#   args = args.slice(i + 1)
  
#   # Find image width and height
#   if args.length
#     unless /\D+/.test(args[0])
#       width = args.shift()
#       height = args.shift()  if args.length and not /\D+/.test(args[0])
#     meta = args.join(" ")
  
#   # Find image title and alt
#   if meta and rMeta.test(meta)
#     match = meta.match(rMeta)
#     title = match[1]
#     alt = match[2]
#   attrs =
#     src: src
#     class: classes.join(" ")
#     width: width
#     height: height
#     title: title
#     alt: alt

#   htmlTag "img", attrs


hexo.extend.tag.register 'social', (args, content)->
  hb = new HatenaBookmark
  return do hb.getHtmlCode

