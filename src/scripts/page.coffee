$(document).ready ->
  # show signin div on signin button click
  $('#signin_button').click ->
    console.log 'signin'
    $signin =  $('#signin')
    $signin.css 'left', Math.max(($(window).width() - $signin.width())/2, 0) # center it
    $signin.show()