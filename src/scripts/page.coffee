$(document).ready ->
  ## login stuff
  $login =  $('#login')

  # show login div on login button click
  $('#login_button').click ->
    console.log 'login'
    $login.css 'left', Math.max(($(window).width() - $login.width())/2, 0) # center it
    $login.show()