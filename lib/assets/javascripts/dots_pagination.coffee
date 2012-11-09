# Pagination with dots.
#
# It must to be called in this way es.:
# 
#   new DotsPagination($('role[pages]'), 5)
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
# The pagination can take two callback functions, one for the previous and one for the next page.
class DotsPagination
  constructor: (@$pages, @pagesAmount, @prevPageCallback, @nextPageCallback) ->
    @$current = @$pages.find('[role=current]')

    @$pages.find(':not([role=current],[role=disabled])').on('mouseenter', @pageLinkMouseEnter).on('mouseleave', @pageLinkMouseLeave)
    @$current.prev(':not([role=disabled])').on('click', { direction: 'prev' }, @changePage)
    @$current.next(':not([role=disabled])').on('click', { direction: 'next' }, @changePage)

  pageLinkMouseEnter: (event) =>
    $(event.currentTarget).addClass 'current'
    @$current.addClass 'default'

  pageLinkMouseLeave: (event) =>
    $(event.currentTarget).removeClass 'current'
    @$current.removeClass 'default'

  changePage: (event) =>
    event.preventDefault()

    [ exCurrentDirection, nearLinkSelector, nearLinkFunction, insertNearLinkFunction, animateLeftSign, pageIncrement, pageLimit, callback ] =
      switch direction = event.data.direction
        when 'prev'
          [ 'next', ':first-child', direction, 'before', '', -1, 1,            @prevPageCallback ]
        when 'next'
          [ 'prev', ':last-child',  direction, 'after',  '-', 1, @pagesAmount, @nextPageCallback ]
        else 
          throw "unknown direction '#{direction}'"

    $this = $(event.currentTarget)
    page = $this.data('page')

    @$current
      .removeAttr('role') # removing current role is useless (it is used just at the beginning), we do it just for coherence
      .removeClass('current')
      .on('click', { direction: exCurrentDirection }, @changePage)
      .on('mouseenter', @pageLinkMouseEnter)
      .on('mouseleave', @pageLinkMouseLeave)
    @$current = $this

    $nearLink = 
      if $this.is nearLinkSelector
        if page == pageLimit
          $('<a href="#" role="disabled"></a>')
        else
          $('<a href="#"></a>')
            .data('page', page + pageIncrement)
            .on('click', { direction: direction }, @changePage)
            .on('mouseenter', @pageLinkMouseEnter)
            .on('mouseleave', @pageLinkMouseLeave)

    $this
      .attr('role', 'current') # adding current role is useless (it is used just at the beginning), we do it just for coherence
      .removeClass('default')
      .off('click', @changePage)
      .off('mouseenter', @pageLinkMouseEnter)
      .off('mouseleave', @pageLinkMouseLeave)

    if $nearLink
      $this[insertNearLinkFunction].call($this, $nearLink)
      @$pages.css(left: -$this.outerWidth(true)) if direction == 'prev'

    @$pages.animate(left: "+=#{animateLeftSign}#{$this.outerWidth(true)}", complete: callback(page))

window.DotsPagination = DotsPagination
