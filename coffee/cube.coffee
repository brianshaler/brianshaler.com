class @Cube
  @angles =
    front: 0
    left: 90
    back: 180
    right: 270
  
  constructor: (sel) ->
    @el = $ sel
    @angle = 0
    @spinner = new SpinCube -360
    @spinTo @angle
  
  setSpinTo: (angle) =>
    @angle = angle
    @spinner.fromAngle = @spinner.toAngle = angle
    @el.css
      transform: "rotateY(#{@angle}deg)"
  
  spinTo: (@angle = 0) =>
    $(".face.selected", @el).removeClass "selected"
    
    @getNearestSide()
    
    animationName = @spinner.spinTo @angle
    document.documentElement.clientHeight
    @el.css
      transition: "none"
      animation: "#{animationName} 1s"
      transform: "rotateY(#{@angle}deg)"
  
  normalizeAngle: (angle = @angle) =>
    normalizedAngle = angle
    while normalizedAngle < 0
      normalizedAngle += 360
    normalizedAngle = normalizedAngle % 360
  
  getNearestSide: (angle = @angle) =>
    angle = @normalizeAngle angle
    mapped = _.map(Cube.angles, (a, k) -> angle: a, side: k)
    sorted = _.sortBy mapped, (a) -> _.min [Math.abs(a.angle-angle), Math.abs(a.angle-(angle-360))]
    sorted[0].side
