JST = @JST

photos = []

photos.push
  img: "http://instagr.am/p/hurigLScav/media/?size=l"
  title: "Grand Canyon, Arizona"
  description: "December 2013"

photos.push
  img: "http://instagr.am/p/ek2KG6ycb4/media/?size=l"
  title: "Zion National Park, Utah"
  description: "September 2013"

photos.push
  img: "http://instagr.am/p/edb4v6SceH/media/?size=l"
  title: "Oahu, Hawaii"
  description: "September 2013"

photos.push
  img: "http://instagr.am/p/d3N16KScdq/media/?size=l"
  title: "Beijing, China"
  description: "September 2013"

photos.push
  img: "http://instagr.am/p/dtG0ngScUp/media/?size=l"
  title: "Pyongyang, DPRK"
  description: "August 2013"

photos.push
  img: "http://instagr.am/p/aG-aHvyccJ/media/?size=l"
  title: "Wolfsburg, Germany"
  description: "June 2013"

photos.push
  img: "http://instagr.am/p/Zt3rADycXz/media/?size=l"
  title: "Grand Canyon, Arizona"
  description: "May 2013"

photos.push
  img: "http://instagr.am/p/YxLKcMScVz/media/?size=l"
  title: "Belize"
  description: "May 2013"

photos.push
  img: "http://instagr.am/p/X7k3l-ycfk/media/?size=l"
  title: "South Island, New Zealand"
  description: "April 2013"

photos.push
  img: "http://instagr.am/p/YEKI5FScbh/media/?size=l"
  title: "South Island, New Zealand"
  description: "April 2013"

photos.push
  img: "http://instagr.am/p/XQor29ycZ1/media/?size=l"
  title: "Sedona, Arizona"
  description: "March 2013"

photos.push
  img: "http://instagr.am/p/VkOzz5ScYz/media/?size=l"
  title: "British Virgin Islands"
  description: "February 2013"

photos.push
  img: "http://instagr.am/p/U_fet_ycfg/media/?size=l"
  title: "Amsterdam, Netherlands"
  description: "January 2013"

photos.push
  img: "http://instagr.am/p/U8SSLGScV-/media/?size=l"
  title: "Interlaken, Switzerland"
  description: "January 2013"


$(document).ready ->
  imgUrls = _.pluck photos, "img"
  slideShow = new SlideShow "#travel-slideshow", imgUrls
  
  thumbnails = $(".travel-thumbnails")
  _.each photos, (photo, i) ->
    link = $("<a>")
    link.attr
      href: "#"
      "data-id": i+1
    img = $("<img>")
    img.attr
      src: photo.img
    
    link.append img
    thumbnails.append link
  
  $(".travel-thumbnails a").click (e) ->
    el = $(e.currentTarget)
    id = parseInt el.attr("data-id")
    if id > 0
      id--
      e.preventDefault()
      overlay = new Overlay photos[id]
      console.log photos[id].title
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
    
