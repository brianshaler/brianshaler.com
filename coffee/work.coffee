JST = @JST

projects = []

projects.push
  img: "images/work/autostadt.jpg"
  title: "Autostadt Socialsphere"
  description: "The Socialsphere is an interactive installation at Volkswagen's Autostadt in Wolfsburg, Germany. It visualizes social media content about Volkswagen and movement in general."
projects.push
  img: "images/work/galaxy.jpg"
  title: "Galaxies of Data"
  description: "Galaxies is an abstract visualization showing thousands of points rendered in a video, simultaneously expressing individualism, scale, and broad trends."
projects.push
  img: "images/work/crowd.jpg"
  title: "Visualizing a Crowd"
  description: "Given log data containing visitor metadata and bid amount, the Crowd video visually conveyed how a client's dynamic ad target bidding system functioned."
projects.push
  img: "images/work/carvana.jpg"
  title: "Carvana"
  description: "Carvana is an online-only used car dealer, leveraging robust interactive exerpiences and high quality imagery to give complete transparency to prospective buyers."
projects.push
  img: "images/work/heatmap.jpg"
  title: "Heat Map"
  description: ""
projects.push
  img: "images/work/diggfriends.jpg"
  title: "Social Connectivity"
  description: ""
projects.push
  img: "images/work/superbowl.jpg"
  title: "Super Bowl"
  description: ""

$(document).ready ->
  imgUrls = _.pluck projects, "img"
  slideShow = new SlideShow "#work-slideshow", imgUrls
  
  thumbnails = $(".work-thumbnails")
  _.each projects, (project, i) ->
    link = $("<a>")
    link.attr
      href: "#"
      "data-id": i+1
    img = $("<img>")
    img.attr
      src: project.img
    
    link.append img
    thumbnails.append link
  
  $(".work-thumbnails a").click (e) ->
    el = $(e.currentTarget)
    id = parseInt el.attr("data-id")
    if id > 0
      id--
      e.preventDefault()
      overlay = new Overlay projects[id]
      console.log projects[id].title
      return false
    true

class Overlay
  constructor: (props) ->
    @el = $("<div>")
    @el.addClass "popup-overlay"
    @el.html JST.popup props
    
    $("body").append @el
    
    @el.click =>
      @close()
  
  close: =>
    @el.remove()
    @el = null
    
