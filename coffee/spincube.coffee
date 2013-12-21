class @SpinCube
  @vendors = [
    "-webkit-"
    "-moz-"
    "-ms-"
    "-o-"
    ""
  ]
  
  constructor: (initialAngle)->
    @div = $ "<div>"
    $("body").append @div
    @fromAngle = initialAngle
    @toAngle = initialAngle
    @render()
  
  render: =>
    animationName = "spin-to-#{@toAngle}"
    overshoot = @fromAngle + (@toAngle-@fromAngle)*1.05
    html = "<style type='text/css'>"
    _.each SpinCube.vendors, (vendor) =>
      html += "@#{vendor}keyframes #{animationName} {\n"
      html += "0% { #{vendor}transform: rotateY(#{@fromAngle}deg) }\n"
      html += "60% { #{vendor}transform: rotateY(#{overshoot}deg) }\n"
      html += "100% { #{vendor}transform: rotateY(#{@toAngle}deg) }\n"
      html += "}\n"
    html += "</style>"
    @div.html html
    animationName
  
  spinTo: (angle = 0) =>
    @fromAngle = @toAngle
    @toAngle = angle
    @render()
