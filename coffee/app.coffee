$(document).ready ->
  cube = new Cube ".cube"
  #cube.spinTo 90
  window.cube = cube
  
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
  
  faceClick = (e) ->
    side = cube.getNearestSide cube.angle
    face = $(".#{side}", cube.el)
    
    if face.hasClass "selected"
      face.removeClass("fullsize selected")
      $(".cube-container, .cube-holder").removeClass("selected");
    else
      face.addClass("fullsize selected")
      $(".cube-container, .cube-holder").addClass("selected");
  
  Hammer(cube.el[0]).on "swipeleft", (event) ->
    cube.spinTo cube.angle - 90
    capture event
  Hammer(cube.el[0]).on "swiperight", (event) ->
    cube.spinTo cube.angle + 90
    capture event
  $(".face", cube.el).each ->
    console.log @
    Hammer(@).on "tap", (e) ->
      console.log e, @
      faceClick(e)
  
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
