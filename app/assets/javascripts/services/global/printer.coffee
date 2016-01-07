app = window.app

app.factory 'Printer', [
  '$rootScope'
  '$compile'
  '$http'
  '$timeout'
  '$q'
  ($rootScope, $compile, $http, $timeout, $q) ->

    printHtml = (html) ->
      deferred = $q.defer()
      hiddenFrame = $('<iframe style="display: none"></iframe>').appendTo('body')[0]

      hiddenFrame.contentWindow.printAndRemove = ->
        hiddenFrame.contentWindow.print()
        $(hiddenFrame).remove()
        return

      htmlContent = '<!doctype html>' + '<html>' + '<body onload="printAndRemove();">' + html + '</body>' + '</html>'
      doc = hiddenFrame.contentWindow.document.open('text/html', 'replace')
      doc.write htmlContent
      deferred.resolve()
      doc.close()
      deferred.promise

    openNewWindow = (html) ->
      newWindow = window.open('printTest.html')
      newWindow.addEventListener 'load', (->
        $(newWindow.document.body).html html
        return
      ), false
      return

    print = (templateUrl, data) ->
      $http.get(templateUrl).success (template) ->
        printScope = $rootScope.$new()
        angular.extend printScope, data
        element = $compile($('<div>' + template + '</div>'))(printScope)

        waitForRenderAndPrint = ->
          if printScope.$$phase or $http.pendingRequests.length
            $timeout waitForRenderAndPrint
          else
            # Replace printHtml with openNewWindow for debugging
            printHtml element.html()
            printScope.$destroy()
          return

        waitForRenderAndPrint()
        return
      return

    printFromScope = (templateUrl, scope) ->
      $rootScope.isBeingPrinted = true
      $http.get(templateUrl).success (template) ->
        printScope = scope
        element = $compile($('<div>' + template + '</div>'))(printScope)

        waitForRenderAndPrint = ->
          if printScope.$$phase or $http.pendingRequests.length
            $timeout waitForRenderAndPrint
          else
            printHtml(element.html()).then ->
              $rootScope.isBeingPrinted = false
              return
          return

        waitForRenderAndPrint()
        return
      return

    {
      print: print
      printHtml: printHtml
      printFromScope: printFromScope
    }
]
