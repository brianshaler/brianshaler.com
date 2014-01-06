TITLE = "title"
ABOUT = "about"

FRONT = "front"
LEFT = "left"
BACK = "back"
RIGHT = "right"

sides = [FRONT, LEFT, BACK, RIGHT]
elements = {}
showing = {}
_.each sides, (side) ->
  showing[side] = false
  elements[side] = $ "<div>"

show = (template, obj = {}) =>
  showing[template] = true
  @JST[template] obj

$(document).ready ->
  cube = new Cube ".cube"
  #cube.spinTo 90
  window.cube = cube
  
  overlay = $(".overlay")[0]
  
  _.each sides, (side) ->
    elements[side] = $(".#{side}", cube.el)
    elements[side].html show side
  
  
  capture = (e) ->
    e.preventDefault()
    false
  $(".btn-left").click (event) ->
    cube.spinTo cube.angle+90
    showSide cube.getNearestSide cube.angle
    capture event
  $(".btn-right").click (event) ->
    cube.spinTo cube.angle-90
    showSide cube.getNearestSide cube.angle
    capture event
  
  resizer = $ "<div>"
  $("body").append resizer
  
  currentSide = ""
  showSide = (side) ->
    return unless side != currentSide
    
    $(".face.showing").trigger("hideSide").removeClass("showing")
    elements[side].addClass("showing")
    elements[side].trigger "showSide"
    
    #elements[side].html show side unless showing[side] == true
  
  selectFace = ->
    side = cube.getNearestSide cube.angle
    face = $(".#{side}", cube.el)
    
    if face.hasClass "selected"
      $("body").addClass("fullscreen").removeClass("not-fullscreen")
      $(".btn-nav").show()
      $(".cube-container, .cube-holder, .overlay").removeClass("selected").addClass("unselected")
      face
        .removeClass("fullsize selected")
        .addClass("previous")
        .trigger("unselectSide")
    else
      $("body").removeClass("fullscreen").addClass("not-fullscreen")
      $(".btn-nav").hide()
      $(".previous").removeClass("previous")
      $(".cube-container, .cube-holder, .overlay").addClass("selected").removeClass("unselected")
      face
        .addClass("fullsize selected")
        .trigger("selectSide")
  
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
    event.gesture.preventDefault()
    dragging = true
    dragHistory = []
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
    deltaX = 180 * event.gesture.deltaX / window.innerWidth
    setSpinTo startAngle + deltaX
    dragHistory.unshift {time: Date.now(), x: deltaX}
    dragHistory.slice 0, 10
    capture event
  Hammer(overlay).on "dragend", (event) ->
    event.gesture.preventDefault()
    dragging = false
    time = Date.now()
    velocityTime = 100
    dragHistory = _.filter dragHistory, (hist) -> hist.time > time-velocityTime
    cube.el.css
      "transition-duration": "0.5s"
    velocity = if dragHistory.length > 0
      time = dragHistory[dragHistory.length-1].time - dragHistory[0].time
      dist = dragHistory[dragHistory.length-1].x - dragHistory[0].x
      dist / (time/1000)
    else
      0
    angle = Math.round((startAngle + 180*event.gesture.deltaX/window.innerWidth + velocity*0.1)/90)*90
    cube.setSpinTo angle
    showSide cube.getNearestSide cube.angle
    capture event
  
  #Hammer(cube.el[0]).on "swiperight", (event) ->
  #  cube.spinTo cube.angle + 90
  #  capture event
  Hammer(overlay).on "tap", (event) ->
    $("body").removeClass("has-not-tapped").addClass("has-tapped")
    selectFace()
    capture event
  Hammer(cube.el[0]).on "tap", (event) ->
    window.tmp = $(event.target)
    tagName = $(event.target).prop("tagName")
    parentLink = $(event.target).parents("a")
    unless tagName?.toLowerCase?() == "a" or parentLink?.length > 0
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
  
  $("body").addClass("has-not-tapped")
  #$(".face").click faceClick

    

