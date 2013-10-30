# Slideshow.
#
# The slideshow html SHOULD be as this:
#
#
#
#
class Slideshow
  slide = (modifier) ->
    @$slides.animate
      left: "#{modifier}=#{@slideshow_width()}"
    ,
      start: => @start_callback()
      done:  => @done_callback()

  constructor: (@$slideshow) ->
    @slideshow_width = -> @$slideshow.width()
    @$slides         = @$slideshow.find '.slides'
    @slides_length   = @$slides.find('.slide').length

    @sliding_key     = 'sliding'

    @start_callback  = -> @$slideshow.data @sliding_key, true
    @done_callback   = -> @$slideshow.data @sliding_key, false

    @$slideshow.find( '.slider.left'  ).on 'click', @slideLeft
    @$slideshow.find( '.slider.right' ).on 'click', @slideRight

  slideLeft: =>
    return false if @$slideshow.data @sliding_key

    left = @$slides.position().left

    return false if left >= 0

    slide.call @, '+'

  slideRight: =>
    return false if @$slideshow.data @sliding_key

    left      = @$slides.position().left
    last_left = -( (@slides_length - 1) * @slideshow_width() )

    return false if left <= last_left

    slide.call @, '-'

window.Slideshow = Slideshow