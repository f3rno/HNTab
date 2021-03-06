window.HNTab = angular.module "HNTab", []

window.HNTab.filter "truncate", ->
  (text, length, end) ->

    length = 32 if isNaN length
    end = "..." unless end

    if text.length <= length or text.length - end.length < length
      text
    else
      "#{text[0..length - end.length].trim()}#{end}"

window.HNTab.controller "main", ($scope, $http) ->

  colors = [
    "#2ecc71"
    "#3498db"
    "#9b59b6"
    "#f1c40f"
    "#e67e22"
    "#e74c3c"
  ]

  # We need to pass an index so we get a deterministic color for each item, to
  # not trigger an infinite digest loop oO
  $scope.generateBackground = (item, index) ->
    if item.image
      "url(#{item.image})"
    else
      colors[index % 6]

  $scope.areCommentsHovered = (item) -> item.comments_hovered
  $scope.setHNHighlight = (item, h) -> item.comments_hovered = h

  $scope.goto = (location, e) ->
    window.location = location

    e.preventDefault()
    false

  $scope.goApps = ->
    _gaq.push ["_trackEvent", "Meta", "Back to Apps"]
    chrome.tabs.update url: "chrome://apps"

  $http.get("http://178.79.137.17:5656/api/v1/news")
  .success (content) ->
    content[i].comments_hovered = false for i in [0...content.length]
    $scope.content = content
