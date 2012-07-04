slideshow_init = ->
  fadeTimeSeconds = 1
  displayTimeSeconds = 4
  $slideshow = $('#slideshow')
  w = $slideshow.width()
  h = $slideshow.height()
  $.each $('#slideshow img'), (i, im) ->
    im.onload = ->
      @width /= Math.max @width / w, @height / h
  $("#slideshow > div:gt(0)").hide()
  setInterval ->
    $('#slideshow > div:first')
    .fadeOut(1000*fadeTimeSeconds)
    .next()
    .fadeIn(1000*fadeTimeSeconds)
    .end()
    .appendTo '#slideshow'
  ,  1000*displayTimeSeconds
$(document).ready ->
  slideshow_init()