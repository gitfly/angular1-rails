resizer = angular.module("resizer", [])

resizer.directive "resizer", ($document) ->
  ($scope, $element, $attrs) ->

    mousemove = (event) ->
      if $attrs.resizer is "vertical"
        
        # Handle vertical resizer
        x = event.pageX
        x = parseInt($attrs.resizerMax)  if $attrs.resizerMax and x > $attrs.resizerMax
        $element.css left: x + "px"
        $($attrs.resizerLeft).css width: x + "px"
        $($attrs.resizerRight).css left: (x + parseInt($attrs.resizerWidth)) + "px"
      else
        
        # Handle horizontal resizer
        y = window.innerHeight - event.pageY
        $element.css bottom: y + "px"
        $($attrs.resizerTop).css bottom: (y + parseInt($attrs.resizerHeight)) + "px"
        $($attrs.resizerBottom).css height: y + "px"
      return

    mouseup = ->
      $document.unbind "mousemove", mousemove
      $document.unbind "mouseup", mouseup
      return

    $element.on "mousedown", (event) ->
      event.preventDefault()
      $document.on "mousemove", mousemove
      $document.on "mouseup", mouseup
      return

    return
