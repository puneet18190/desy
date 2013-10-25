# Pagination with dots.
#
# It must to be called in this way es.:
# 
#   # Initializes a pagination on role[pages] elements with 5 pages
#   new DotsPagination($('role[pages]'), 5)
#
#   # Initializes a pagination on role[pages] elements with 5 pages and callbacks called when the page change starts
#   new DotsPagination($('role[pages]'), 5, { 'onStart': { 'prev': function(page_number) { console.log(page_number), 'next': function(page_number) { console.log(page_number) } } })
#
#   # Initializes a pagination on role[pages] elements with 5 pages and callbacks called when the page change is completed
#   new DotsPagination($('role[pages]'), 5, { 'onComplete': { 'prev': function(page_number) { console.log(page_number), 'next': function(page_number) { console.log(page_number) } } })
#
# where the first argument is the container of the pagination links,
# and the second is the total pages amount.
#
# The container MUST have at least 3 pagination link elements,
# of which one MUST correspond to the current page (role="current"), 
# while the others are the previous and the next page links.
# If the current page has not a previous and/or a next page link,
# this/these link/s should be disabled (role="disabled").
# All the links except for the disabled ones MUST contain a page data
# which correspond to the page represented by the links.
# The links MUST be contained in a role="pages" element.
#
# Container examples:
#
#   <!-- 3 or more pages, the n°2 is the current -->
#   <span role="pages">
#     <a href="#" data-page="1"></a><a href="#" role="current" data-page="2"></a><a href="#" data-page="3"></a>
#   </span>
#
#   <!-- 2 or more pages, the n°1 is the current. Note that the previous link is role="disabled" --> 
#   <span role="pages">
#     <a href="#" role="disabled"></a><a href="#" role="current" data-page="1"></a><a href="#" data-page="2"></a>
#   </span>
#
#   <!-- 2 or more pages, the last is the current -->
#   <span role="pages">
#     <a href="#" data-page="1"></a><a href="#" role="current" data-page="2"></a><a href="#" role="disabled"></a>
#   </span>
#
# The pagination can take options, which is an object that can contain:
#
#    'onStart': object which can contain 'prev': callback called when the page gets decremented, at the start
#                                        'next': callback called when the page gets incremented, at the start
#
#    'onComplete': object which can contain 'prev': callback called when the page gets decremented, at the complete
#                                           'next': callback called when the page gets incremented, at the complete
class DotsPagination
  constructor: (@$pages, @pagesAmount, options) ->
    @$current = @$pages.find('[role=current]')

    # @$pages.find(':not([role=current],[role=disabled])').on('mouseenter', @pageLinkMouseEnter).on('mouseleave', @pageLinkMouseLeave)
    @$current.prev(':not([role=disabled])').on('click', { direction: 'prev' }, @changePage)
    @$current.next(':not([role=disabled])').on('click', { direction: 'next' }, @changePage)

    options['onStart'] ||= {}
    @onStart = options['onStart']

    options['onComplete'] ||= {}
    @onComplete = options['onComplete']

  # pageLinkMouseEnter: (event) =>
  #   $(event.currentTarget).addClass 'current'
  #   @$current.addClass 'default'

  # pageLinkMouseLeave: (event) =>
  #   $(event.currentTarget).removeClass 'current'
  #   @$current.removeClass 'default'

  changePage: (event) =>
    event.preventDefault()

    [ exCurrentDirection, nearLinkSelector, nearLinkFunction, insertNearLinkFunction, animateLeftSign, pageIncrement, pageLimit, onStart, onComplete ] =
      switch direction = event.data.direction
        when 'prev'
          [ 'next', ':first-child', direction, 'before', '', -1, 1,            @onStart[direction], @onComplete[direction] ]
        when 'next'
          [ 'prev', ':last-child',  direction, 'after',  '-', 1, @pagesAmount, @onStart[direction], @onComplete[direction] ]
        else 
          throw "unknown direction '#{direction}'"

    $this = $(event.currentTarget)
    page = $this.data('page')

    @$current
      .removeAttr('role') # removing current role is useless (it is used just at the beginning), we do it just for coherence
      .removeClass('current')
      .on('click', { direction: exCurrentDirection }, @changePage)
      # .on('mouseenter', @pageLinkMouseEnter)
      # .on('mouseleave', @pageLinkMouseLeave)
    @$current = $this

    $nearLink = 
      if $this.is nearLinkSelector
        if page == pageLimit
          $('<a/>', role: "disabled")
        else
          $('<a/>')
            .data('page', page + pageIncrement)
            .on('click', { direction: direction }, @changePage)
            # .on('mouseenter', @pageLinkMouseEnter)
            # .on('mouseleave', @pageLinkMouseLeave)

    $this
      .attr('role', 'current') # adding current role is useless (it is used just at the beginning), we do it just for coherence
      .removeClass('default')
      .off('click', @changePage)
      # .off('mouseenter', @pageLinkMouseEnter)
      # .off('mouseleave', @pageLinkMouseLeave)

    if $nearLink
      $this[insertNearLinkFunction].call($this, $nearLink)
      @$pages.css(left: -$this.outerWidth(true)) if direction == 'prev'

    @$pages.animate(
      { left: "+=#{animateLeftSign}#{$this.outerWidth(true)}" }, 
      { complete: () -> onComplete(page) } if onComplete
    )

window.DotsPagination = DotsPagination
