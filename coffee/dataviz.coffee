dataViz = null

timeout = (callback) ->
  setTimeout ->
    callback()
  , 1
requestAnimationFrame = window.requestAnimationFrame ? timeout

class @DataViz
  @LINE = "line"
  @SCATTER = "scatter"
  
  constructor: ->
    @el = $("#data-viz")
    @canvas = @el[0]
    @ctx = @canvas.getContext "2d"
    @w = @h = 0
    @cached = 0
    
    @el.parent().css
      "text-align": "left"
    
    @time = Date.now()
    @renderType = DataViz.SCATTER
    
    @side = @el.parents(".face")
    @side.on "showSide", =>
      @animating = true
      @render()
    @side.on "hideSide", =>
      @animating = false
    
    $(window).on "resize orientation", =>
      @resize()
    @resize()
  
  resize: =>
    face = @el.parents(".face")
    w = face.width()
    h = face.height()
    console.log "Resize: #{w}x#{h}"
    if w != @w or h != @h
      @cached = 0
      @w = w
      @h = h
      @el.css
        width: @w
        height: @h
      @el.attr
        width: @w
        height: @h
      @render()
  
  render: =>
    @time = Date.now()
    
    TTL = switch @renderType
      when DataViz.LINE
        1000/60
      when DataViz.SCATTER
        1000/24
      else
        1000/30
    
    @redraw() unless @cached > @time - TTL
    requestAnimationFrame @render if @animating
  
  color: (name, alpha = 1) =>
    colors =
      white: "255, 255, 255"
      gray: "155, 155, 155"
      blue: "0, 0, 255"
      red: "230, 0, 0"
      green: "0, 155, 0"
      black: "0, 0, 0"
    color = colors[name] ? colors.black
    "rgba(#{color}, #{alpha})"
  
  redraw: =>
    @ctx.clearRect 0, 0, @w, @h
    
    h = @h * 0.7
    y = @h - h - h*0.1
    
    @ctx.fillStyle = @color "white", 0.8
    @ctx.fillRect 0, y, @w, h
    
    duration = 2000
    currentRenderType = (Math.round @time / duration) % 2
    
    types = [DataViz.LINE, DataViz.SCATTER]
    
    @renderType = types[currentRenderType]
    
    generateNoise = (bucket) ->
      bound = 1000
      noise = (bucket*Math.pow(Math.PI*bound, 4)) % bound
      noise -= bound/2
      noise /= bound/2
      noise
    
    pointSets = []
    sets = 3
    for set in [0..sets]
      pointSets[set] = []
      offset = set * 10000
      for i in [0..@w]
        bucket = i + Math.round @time/24
        pointSets[set].push switch @renderType
          when DataViz.LINE
            noiseStrength = 0.1
            noiseStrength *= 0.6 + 0.4 * Math.sin bucket*0.2
            noise = generateNoise bucket
            
            wave = 0.5 + (set / sets) * 0.5 * Math.sin offset + bucket * 0.05 * (sets-set+1)
            (noise * noiseStrength + wave * (1-noiseStrength))
          when DataViz.SCATTER
            noiseStrength = 0.8
            noiseStrength *= 0.6 + 0.4 * Math.sin bucket*0.2
            
            noise = generateNoise bucket
            wave = Math.sin bucket*0.05
            0.5 + 0.5 * (noise * noiseStrength + wave * (1-noiseStrength))
          else
            0
    
    switch @renderType
      when DataViz.LINE
        @ctx.lineWidth = 1
        colors = ["gray", "blue", "red", "green"]
        _.each pointSets, (pointSet, index) =>
          @ctx.strokeStyle = @color colors[index], 0.8
          @ctx.beginPath()
          @ctx.moveTo 0, y+pointSet[0]*h
          pointSet.shift()
          _.each pointSet, (point, k) =>
            @ctx.lineTo @w*k/pointSet.length, y+point*h
          @ctx.stroke()
      when DataViz.SCATTER
        color = @color "black", 0.1
        @ctx.fillStyle = color
        size = 3
        _.each pointSets, (pointSet, index) =>
          @ctx.strokeStyle = color
          pointSet.shift()
          _.each pointSet, (point, k) =>
            @ctx.fillRect (@w+size)*k/pointSet.length-size, y+point*h, size, size
    
    @cached = @time


