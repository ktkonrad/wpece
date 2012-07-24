$(document).ready ->

  # initializion bootstrap stuff
  $('#slideshow').carousel({interval: 3000})
  $('#amenities').modal({show: false})
  $('.tip').tooltip()

  #### old stuff
  ## login and signup stuff
  $login =  $('#login')
  $signup = $('#signup')

  # show login div on login button click
  $('#login_button').click ->
    $login.css 'left', Math.max(($(window).width() - $login.width())/2, 0) # center it
    $login.show()

  # show signup div on signup button click
  $('#signup_button').click ->
    $signup.css 'left', Math.max(($(window).width() - $signup.width())/2, 0) # center it
    $signup.show()

  # hide login div on login close click
  $('#login_close').click ->
    $login.hide()

  # hide signup div on signup close click
  $('#signup_close').click ->
    $signup.hide()