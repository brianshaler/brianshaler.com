
class @SlideShow
  
  constructor: (@selector, urls) ->
    @el = $(@selector)
    @currentImage = 0
    @timeoutId = null
    @imgs = []
    @running = false
    @w = @h = 0
    
    unless urls?.length > 0
      throw Error("Must provide at least one image URL")
    
    _.each urls, (url) =>
      img = $("<img>")
      img.attr
        src: url
      img.addClass "hide"
      @el.append img
      @imgs.push img
    
    @show @currentImage, true
    
    @side = @el.parents(".face")
    @side.on "showSide unselectSide", =>
      console.log "showSide"
      @running = true
      unless @timeoutId
        @timeoutId = @start()
      @render()
    @side.on "hideSide selectSide", =>
      console.log "hideSide"
      @running = false
      if @timeoutId
        clearTimeout @timeoutId
        @timeoutId = null
    
    $(window).on "resize orientation", =>
      @resize()
    @resize()
  
  resize: =>
    face = @el.parents(".face")
    w = face.width()
    h = face.height()
    if w != @w or h != @h
      @w = w
      @h = h
      $("img", @el).css
        width: @w
        height: @h
      setTimeout =>
        @resize()
      , 1000/24
  
  start: =>
    return if @timeoutId or !@running
    @timeoutId = setTimeout =>
      nextImage = @currentImage+1
      nextImage = 0 if nextImage >= @imgs.length
      @show nextImage
    , 2400
  
  show: (imageId, force = false) =>
    return unless @running or force
    
    @timeoutId = null
    
    img = @imgs[@currentImage]
    img.addClass("hide").removeClass("show")
    @currentImage = imageId
    img = @imgs[@currentImage]
    img.addClass("show").removeClass("hide")
    
    return unless @running
    @start()

