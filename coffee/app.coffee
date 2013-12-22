$(document).ready ->
  cube = new Cube ".cube"
  #cube.spinTo 90
  window.cube = cube
  
  overlay = $(".overlay")[0]
  console.log overlay
  
  $(".title").html show "title"
  $(".about").html show "about"
  
  
  capture = (e) ->
    e.preventDefault()
    false
  $(".btn-left").click (event) ->
    cube.spinTo cube.angle+90
    capture event
  $(".btn-right").click (event) ->
    cube.spinTo cube.angle-90
    capture event
  
  resizer = $ "<div>"
  $("body").append resizer
  
  selectFace = ->
    side = cube.getNearestSide cube.angle
    face = $(".#{side}", cube.el)
    
    if face.hasClass "selected"
      $(".btn-nav").show()
      face.removeClass("fullsize selected")
      $(".cube-container, .cube-holder, .overlay").removeClass("selected").addClass("unselected")
    else
      $(".btn-nav").hide()
      face.addClass("fullsize selected")
      $(".cube-container, .cube-holder, .overlay").addClass("selected").removeClass("unselected")
  
  setSpinTo = _.debounce (angle) ->
    cube.setSpinTo angle if dragging
  , 80, {
    leading: true
    trailing: false
    maxWait: 81
  }
  startAngle = 0
  dragHistory = []
  dragging = false
  Hammer(overlay).on "dragstart", (event) ->
    console.log "drag start!"
    event.gesture.preventDefault()
    dragging = true
    dragHistory = []
    #console.log event
    startAngle = cube.angle
    cube.spinner.clear()
    cube.el.css
      animation: "none"
      "transition-property": "all"
      "transition-duration": "0.3s"
      "transition-timing-function": "ease-out"
    capture event
  Hammer(overlay).on "drag", (event) ->
    event.gesture.preventDefault()
    event.gesture.stopPropagation()
    #console.log event
    deltaX = 180 * event.gesture.deltaX / window.innerWidth
    console.log "setSpinTo", startAngle + deltaX
    setSpinTo startAngle + deltaX
    dragHistory.unshift {time: Date.now(), x: deltaX}
    dragHistory.slice 0, 10
    capture event
  Hammer(overlay).on "dragend", (event) ->
    event.gesture.preventDefault()
    dragging = false
    time = Date.now()
    console.log event
    velocityTime = 100
    dragHistory = _.filter dragHistory, (hist) -> hist.time > time-velocityTime
    cube.el.css
      "transition-duration": "0.5s"
    console.log _.pluck dragHistory, "x"
    velocity = if dragHistory.length > 0
      sum = _.reduce dragHistory, (sum, obj) ->
        sum + obj.x
      , 0
      console.log "sum: #{sum}"
      1 / dragHistory.length * sum
    else
      0
    console.log "velocity: #{velocity}"
    angle = Math.round((startAngle + 180*event.gesture.deltaX/window.innerWidth + velocity*0.8)/90)*90
    console.log "end up at #{angle}"
    cube.setSpinTo angle
    capture event
  
  #Hammer(cube.el[0]).on "swiperight", (event) ->
  #  cube.spinTo cube.angle + 90
  #  capture event
  Hammer(overlay).on "tap", (event) ->
    selectFace()
    capture event
  Hammer(cube.el[0]).on "tap", (event) ->
    selectFace()
  
  resize = ->
    width = window.innerWidth - 1
    height = window.innerHeight - 1
    html = "<style type='text/css'>"
    html += ".fullsize {\n"
    html += "width: #{width}px !important;\n"
    html += "height: #{height}px !important;\n"
    html += "}\n"
    html += "</style>"
    resizer.html html
  resize()
  $(window).resize resize
  
  #$(".face").click faceClick

    

show = (template, obj = {}) => @JST[template] obj
