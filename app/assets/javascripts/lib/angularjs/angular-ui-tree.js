/**
 * @license Angular UI Tree v2.1.5
 * (c) 2010-2014. https://github.com/JimLiu/angular-ui-tree
 * License: MIT
 */
! function() {
    "use strict";
    angular.module("ui.tree", []).constant("treeConfig", {
        treeClass: "angular-ui-tree",
        emptyTreeClass: "angular-ui-tree-empty",
        hiddenClass: "angular-ui-tree-hidden",
        nodesClass: "angular-ui-tree-nodes",
        nodeClass: "angular-ui-tree-node",
        handleClass: "angular-ui-tree-handle",
        placeHolderClass: "angular-ui-tree-placeholder",
        dragClass: "angular-ui-tree-drag",
        dragThreshold: 3,
        levelThreshold: 30
    })
}(),
function() {
    "use strict";
    angular.module("ui.tree").factory("$uiTreeHelper", ["$document", "$window", function($document, $window) {
        return {
            nodesData: {},
            setNodeAttribute: function(scope, attrName, val) {
                if (!scope.$modelValue) return null;
                var data = this.nodesData[scope.$modelValue.$$hashKey];
                data || (data = {}, this.nodesData[scope.$modelValue.$$hashKey] = data), data[attrName] = val
            },
            getNodeAttribute: function(scope, attrName) {
                if (!scope.$modelValue) return null;
                var data = this.nodesData[scope.$modelValue.$$hashKey];
                return data ? data[attrName] : null
            },
            nodrag: function(targetElm) {
                return "undefined" != typeof targetElm.attr("data-nodrag")
            },
            eventObj: function(e) {
                var obj = e;
                return void 0 !== e.targetTouches ? obj = e.targetTouches.item(0) : void 0 !== e.originalEvent && void 0 !== e.originalEvent.targetTouches && (obj = e.originalEvent.targetTouches.item(0)), obj
            },
            dragInfo: function(node) {
                return {
                    source: node,
                    sourceInfo: {
                        nodeScope: node,
                        index: node.index(),
                        nodesScope: node.$parentNodesScope
                    },
                    index: node.index(),
                    siblings: node.siblings().slice(0),
                    parent: node.$parentNodesScope,
                    moveTo: function(parent, siblings, index) {
                        this.parent = parent, this.siblings = siblings.slice(0);
                        var i = this.siblings.indexOf(this.source);
                        i > -1 && (this.siblings.splice(i, 1), this.source.index() < index && index--), this.siblings.splice(index, 0, this.source), this.index = index
                    },
                    parentNode: function() {
                        return this.parent.$nodeScope
                    },
                    prev: function() {
                        return this.index > 0 ? this.siblings[this.index - 1] : null
                    },
                    next: function() {
                        return this.index < this.siblings.length - 1 ? this.siblings[this.index + 1] : null
                    },
                    isDirty: function() {
                        return this.source.$parentNodesScope != this.parent || this.source.index() != this.index
                    },
                    eventArgs: function(elements, pos) {
                        return {
                            source: this.sourceInfo,
                            dest: {
                                index: this.index,
                                nodesScope: this.parent
                            },
                            elements: elements,
                            pos: pos
                        }
                    },
                    apply: function() {
                        var nodeData = this.source.$modelValue;
                        this.source.remove(), this.parent.insertNode(this.index, nodeData)
                    }
                }
            },
            height: function(element) {
                return element.prop("scrollHeight")
            },
            width: function(element) {
                return element.prop("scrollWidth")
            },
            offset: function(element) {
                var boundingClientRect = element[0].getBoundingClientRect();
                return {
                    width: element.prop("offsetWidth"),
                    height: element.prop("offsetHeight"),
                    top: boundingClientRect.top + ($window.pageYOffset || $document[0].body.scrollTop || $document[0].documentElement.scrollTop),
                    left: boundingClientRect.left + ($window.pageXOffset || $document[0].body.scrollLeft || $document[0].documentElement.scrollLeft)
                }
            },
            positionStarted: function(e, target) {
                var pos = {};
                return pos.offsetX = e.pageX - this.offset(target).left, pos.offsetY = e.pageY - this.offset(target).top, pos.startX = pos.lastX = e.pageX, pos.startY = pos.lastY = e.pageY, pos.nowX = pos.nowY = pos.distX = pos.distY = pos.dirAx = 0, pos.dirX = pos.dirY = pos.lastDirX = pos.lastDirY = pos.distAxX = pos.distAxY = 0, pos
            },
            positionMoved: function(e, pos, firstMoving) {
                pos.lastX = pos.nowX, pos.lastY = pos.nowY, pos.nowX = e.pageX, pos.nowY = e.pageY, pos.distX = pos.nowX - pos.lastX, pos.distY = pos.nowY - pos.lastY, pos.lastDirX = pos.dirX, pos.lastDirY = pos.dirY, pos.dirX = 0 === pos.distX ? 0 : pos.distX > 0 ? 1 : -1, pos.dirY = 0 === pos.distY ? 0 : pos.distY > 0 ? 1 : -1;
                var newAx = Math.abs(pos.distX) > Math.abs(pos.distY) ? 1 : 0;
                return firstMoving ? (pos.dirAx = newAx, void(pos.moving = !0)) : (pos.dirAx !== newAx ? (pos.distAxX = 0, pos.distAxY = 0) : (pos.distAxX += Math.abs(pos.distX), 0 !== pos.dirX && pos.dirX !== pos.lastDirX && (pos.distAxX = 0), pos.distAxY += Math.abs(pos.distY), 0 !== pos.dirY && pos.dirY !== pos.lastDirY && (pos.distAxY = 0)), void(pos.dirAx = newAx))
            }
        }
    }])
}(),
function() {
    "use strict";
    angular.module("ui.tree").controller("TreeController", ["$scope", "$element", "$attrs", "treeConfig", function($scope, $element) {
        this.scope = $scope, $scope.$element = $element, $scope.$nodesScope = null, $scope.$type = "uiTree", $scope.$emptyElm = null, $scope.$callbacks = null, $scope.dragEnabled = !0, $scope.emptyPlaceHolderEnabled = !0, $scope.maxDepth = 0, $scope.dragDelay = 0, $scope.isEmpty = function() {
            return $scope.$nodesScope && $scope.$nodesScope.$modelValue && 0 === $scope.$nodesScope.$modelValue.length
        }, $scope.place = function(placeElm) {
            $scope.$nodesScope.$element.append(placeElm), $scope.$emptyElm.remove()
        }, $scope.resetEmptyElement = function() {
            0 === $scope.$nodesScope.$modelValue.length && $scope.emptyPlaceHolderEnabled ? $element.append($scope.$emptyElm) : $scope.$emptyElm.remove()
        };
        var collapseOrExpand = function(scope, collapsed) {
            for (var nodes = scope.childNodes(), i = 0; i < nodes.length; i++) {
                collapsed ? nodes[i].collapse() : nodes[i].expand();
                var subScope = nodes[i].$childNodesScope;
                subScope && collapseOrExpand(subScope, collapsed)
            }
        };
        $scope.collapseAll = function() {
            collapseOrExpand($scope.$nodesScope, !0)
        }, $scope.expandAll = function() {
            collapseOrExpand($scope.$nodesScope, !1)
        }
    }])
}(),
function() {
    "use strict";
    angular.module("ui.tree").controller("TreeNodesController", ["$scope", "$element", "treeConfig", function($scope, $element) {
        this.scope = $scope, $scope.$element = $element, $scope.$modelValue = null, $scope.$nodeScope = null, $scope.$treeScope = null, $scope.$type = "uiTreeNodes", $scope.$nodesMap = {}, $scope.nodrop = !1, $scope.maxDepth = 0, $scope.initSubNode = function(subNode) {
            return subNode.$modelValue ? void($scope.$nodesMap[subNode.$modelValue.$$hashKey] = subNode) : null
        }, $scope.destroySubNode = function(subNode) {
            return subNode.$modelValue ? void($scope.$nodesMap[subNode.$modelValue.$$hashKey] = null) : null
        }, $scope.accept = function(sourceNode, destIndex) {
            return $scope.$treeScope.$callbacks.accept(sourceNode, $scope, destIndex)
        }, $scope.beforeDrag = function(sourceNode) {
            return $scope.$treeScope.$callbacks.beforeDrag(sourceNode)
        }, $scope.isParent = function(node) {
            return node.$parentNodesScope == $scope
        }, $scope.hasChild = function() {
            return $scope.$modelValue.length > 0
        }, $scope.safeApply = function(fn) {
            var phase = this.$root.$$phase;
            "$apply" == phase || "$digest" == phase ? fn && "function" == typeof fn && fn() : this.$apply(fn)
        }, $scope.removeNode = function(node) {
            var index = $scope.$modelValue.indexOf(node.$modelValue);
            return index > -1 ? ($scope.safeApply(function() {
                $scope.$modelValue.splice(index, 1)[0]
            }), node) : null
        }, $scope.insertNode = function(index, nodeData) {
            $scope.safeApply(function() {
                $scope.$modelValue.splice(index, 0, nodeData)
            })
        }, $scope.childNodes = function() {
            var nodes = [];
            if ($scope.$modelValue)
                for (var i = 0; i < $scope.$modelValue.length; i++) nodes.push($scope.$nodesMap[$scope.$modelValue[i].$$hashKey]);
            return nodes
        }, $scope.depth = function() {
            return $scope.$nodeScope ? $scope.$nodeScope.depth() : 0
        }, $scope.outOfDepth = function(sourceNode) {
            var maxDepth = $scope.maxDepth || $scope.$treeScope.maxDepth;
            return maxDepth > 0 ? $scope.depth() + sourceNode.maxSubDepth() + 1 > maxDepth : !1
        }
    }])
}(),
function() {
    "use strict";
    angular.module("ui.tree").controller("TreeNodeController", ["$scope", "$element", "$attrs", "treeConfig", function($scope, $element) {
        this.scope = $scope, $scope.$element = $element, $scope.$modelValue = null, $scope.$parentNodeScope = null, $scope.$childNodesScope = null, $scope.$parentNodesScope = null, $scope.$treeScope = null, $scope.$handleScope = null, $scope.$type = "uiTreeNode", $scope.$$apply = !1, $scope.collapsed = !1, $scope.init = function(controllersArr) {
            var treeNodesCtrl = controllersArr[0];
            $scope.$treeScope = controllersArr[1] ? controllersArr[1].scope : null, $scope.$parentNodeScope = treeNodesCtrl.scope.$nodeScope, $scope.$modelValue = treeNodesCtrl.scope.$modelValue[$scope.$index], $scope.$parentNodesScope = treeNodesCtrl.scope, treeNodesCtrl.scope.initSubNode($scope), $element.on("$destroy", function() {
                treeNodesCtrl.scope.destroySubNode($scope)
            })
        }, $scope.index = function() {
            return $scope.$parentNodesScope.$modelValue.indexOf($scope.$modelValue)
        }, $scope.dragEnabled = function() {
            return !($scope.$treeScope && !$scope.$treeScope.dragEnabled)
        }, $scope.isSibling = function(targetNode) {
            return $scope.$parentNodesScope == targetNode.$parentNodesScope
        }, $scope.isChild = function(targetNode) {
            var nodes = $scope.childNodes();
            return nodes && nodes.indexOf(targetNode) > -1
        }, $scope.prev = function() {
            var index = $scope.index();
            return index > 0 ? $scope.siblings()[index - 1] : null
        }, $scope.siblings = function() {
            return $scope.$parentNodesScope.childNodes()
        }, $scope.childNodesCount = function() {
            return $scope.childNodes() ? $scope.childNodes().length : 0
        }, $scope.hasChild = function() {
            return $scope.childNodesCount() > 0
        }, $scope.childNodes = function() {
            return $scope.$childNodesScope && $scope.$childNodesScope.$modelValue ? $scope.$childNodesScope.childNodes() : null
        }, $scope.accept = function(sourceNode, destIndex) {
            return $scope.$childNodesScope && $scope.$childNodesScope.$modelValue && $scope.$childNodesScope.accept(sourceNode, destIndex)
        }, $scope.removeNode = function() {
            var node = $scope.remove();
            return $scope.$callbacks.removed(node), node
        }, $scope.remove = function() {
            return $scope.$parentNodesScope.removeNode($scope)
        }, $scope.toggle = function() {
            $scope.collapsed = !$scope.collapsed
        }, $scope.collapse = function() {
            $scope.collapsed = !0
        }, $scope.expand = function() {
            $scope.collapsed = !1
        }, $scope.depth = function() {
            var parentNode = $scope.$parentNodeScope;
            return parentNode ? parentNode.depth() + 1 : 1
        };
        var subDepth = 0,
            countSubDepth = function(scope) {
                for (var count = 0, nodes = scope.childNodes(), i = 0; i < nodes.length; i++) {
                    var childNodes = nodes[i].$childNodesScope;
                    childNodes && (count = 1, countSubDepth(childNodes))
                }
                subDepth += count
            };
        $scope.maxSubDepth = function() {
            return subDepth = 0, $scope.$childNodesScope && countSubDepth($scope.$childNodesScope), subDepth
        }
    }])
}(),
function() {
    "use strict";
    angular.module("ui.tree").controller("TreeHandleController", ["$scope", "$element", "$attrs", "treeConfig", function($scope, $element) {
        this.scope = $scope, $scope.$element = $element, $scope.$nodeScope = null, $scope.$type = "uiTreeHandle"
    }])
}(),
function() {
    "use strict";
    angular.module("ui.tree").directive("uiTree", ["treeConfig", "$window", function(treeConfig, $window) {
        return {
            restrict: "A",
            scope: !0,
            controller: "TreeController",
            link: function(scope, element, attrs) {
                var callbacks = {
                        accept: null,
                        beforeDrag: null
                    },
                    config = {};
                angular.extend(config, treeConfig), config.treeClass && element.addClass(config.treeClass), scope.$emptyElm = angular.element($window.document.createElement("div")), config.emptyTreeClass && scope.$emptyElm.addClass(config.emptyTreeClass), scope.$watch("$nodesScope.$modelValue.length", function() {
                    scope.$nodesScope.$modelValue && scope.resetEmptyElement()
                }, !0), scope.$watch(attrs.dragEnabled, function(val) {
                    "boolean" == typeof val && (scope.dragEnabled = val)
                }), scope.$watch(attrs.emptyPlaceHolderEnabled, function(val) {
                    "boolean" == typeof val && (scope.emptyPlaceHolderEnabled = val)
                }), scope.$watch(attrs.maxDepth, function(val) {
                    "number" == typeof val && (scope.maxDepth = val)
                }), scope.$watch(attrs.dragDelay, function(val) {
                    "number" == typeof val && (scope.dragDelay = val)
                }), callbacks.accept = function(sourceNodeScope, destNodesScope) {
                    return destNodesScope.nodrop || destNodesScope.outOfDepth(sourceNodeScope) ? !1 : !0
                }, callbacks.beforeDrag = function() {
                    return !0
                }, callbacks.removed = function() {}, callbacks.dropped = function() {}, callbacks.dragStart = function() {}, callbacks.dragMove = function() {}, callbacks.dragStop = function() {}, callbacks.beforeDrop = function() {}, scope.$watch(attrs.uiTree, function(newVal) {
                    angular.forEach(newVal, function(value, key) {
                        callbacks[key] && "function" == typeof value && (callbacks[key] = value)
                    }), scope.$callbacks = callbacks
                }, !0)
            }
        }
    }])
}(),
function() {
    "use strict";
    angular.module("ui.tree").directive("uiTreeNodes", ["treeConfig", "$window", function(treeConfig) {
        return {
            require: ["ngModel", "?^uiTreeNode", "^uiTree"],
            restrict: "A",
            scope: !0,
            controller: "TreeNodesController",
            link: function(scope, element, attrs, controllersArr) {
                var config = {};
                angular.extend(config, treeConfig), config.nodesClass && element.addClass(config.nodesClass);
                var ngModel = controllersArr[0],
                    treeNodeCtrl = controllersArr[1],
                    treeCtrl = controllersArr[2];
                treeNodeCtrl ? (treeNodeCtrl.scope.$childNodesScope = scope, scope.$nodeScope = treeNodeCtrl.scope) : treeCtrl.scope.$nodesScope = scope, scope.$treeScope = treeCtrl.scope, ngModel && (ngModel.$render = function() {
                    ngModel.$modelValue && angular.isArray(ngModel.$modelValue) || (scope.$modelValue = []), scope.$modelValue = ngModel.$modelValue
                }), scope.$watch(attrs.maxDepth, function(val) {
                    "number" == typeof val && (scope.maxDepth = val)
                }), scope.$watch(function() {
                    return attrs.nodrop
                }, function(newVal) {
                    "undefined" != typeof newVal && (scope.nodrop = !0)
                }, !0), attrs.$observe("horizontal", function(val) {
                    scope.horizontal = "undefined" != typeof val
                })
            }
        }
    }])
}(),
function() {
    "use strict";
    angular.module("ui.tree").directive("uiTreeNode", ["treeConfig", "$uiTreeHelper", "$window", "$document", "$timeout", function(treeConfig, $uiTreeHelper, $window, $document, $timeout) {
        return {
            require: ["^uiTreeNodes", "^uiTree"],
            restrict: "A",
            controller: "TreeNodeController",
            link: function(scope, element, attrs, controllersArr) {
                var config = {};
                angular.extend(config, treeConfig), config.nodeClass && element.addClass(config.nodeClass), scope.init(controllersArr), scope.collapsed = !!$uiTreeHelper.getNodeAttribute(scope, "collapsed"), scope.$watch(attrs.collapsed, function(val) {
                    "boolean" == typeof val && (scope.collapsed = val)
                }), scope.$watch("collapsed", function(val) {
                    $uiTreeHelper.setNodeAttribute(scope, "collapsed", val), attrs.$set("collapsed", val)
                });
                var firstMoving, dragInfo, pos, placeElm, hiddenPlaceElm, dragElm, elements, document_height, document_width, hasTouch = "ontouchstart" in window,
                    treeScope = null,
                    dragDelaying = !0,
                    dragStarted = !1,
                    dragTimer = null,
                    body = document.body,
                    html = document.documentElement,
                    dragStart = function(e) {
                        if ((hasTouch || 2 != e.button && 3 != e.which) && !(e.uiTreeDragging || e.originalEvent && e.originalEvent.uiTreeDragging)) {
                            var eventElm = angular.element(e.target),
                                eventScope = eventElm.scope();
                            if (eventScope && eventScope.$type && !("uiTreeNode" != eventScope.$type && "uiTreeHandle" != eventScope.$type || "uiTreeNode" == eventScope.$type && eventScope.$handleScope)) {
                                var eventElmTagName = eventElm.prop("tagName").toLowerCase();
                                if ("input" != eventElmTagName && "textarea" != eventElmTagName && "button" != eventElmTagName && "select" != eventElmTagName) {
                                    for (; eventElm && eventElm[0] && eventElm[0] != element;) {
                                        if ($uiTreeHelper.nodrag(eventElm)) return;
                                        eventElm = eventElm.parent()
                                    }
                                    if (scope.beforeDrag(scope)) {
                                        e.uiTreeDragging = !0, e.originalEvent && (e.originalEvent.uiTreeDragging = !0), e.preventDefault();
                                        var eventObj = $uiTreeHelper.eventObj(e);
                                        firstMoving = !0, dragInfo = $uiTreeHelper.dragInfo(scope);
                                        var tagName = scope.$element.prop("tagName");
                                        if ("tr" === tagName.toLowerCase()) {
                                            placeElm = angular.element($window.document.createElement(tagName));
                                            var tdElm = angular.element($window.document.createElement("td")).addClass(config.placeHolderClass);
                                            placeElm.append(tdElm)
                                        } else placeElm = angular.element($window.document.createElement(tagName)).addClass(config.placeHolderClass);
                                        hiddenPlaceElm = angular.element($window.document.createElement(tagName)), config.hiddenClass && hiddenPlaceElm.addClass(config.hiddenClass), pos = $uiTreeHelper.positionStarted(eventObj, scope.$element), placeElm.css("height", $uiTreeHelper.height(scope.$element) + "px"), placeElm.css("width", $uiTreeHelper.width(scope.$element) + "px"), dragElm = angular.element($window.document.createElement(scope.$parentNodesScope.$element.prop("tagName"))).addClass(scope.$parentNodesScope.$element.attr("class")).addClass(config.dragClass), dragElm.css("width", $uiTreeHelper.width(scope.$element) + "px"), dragElm.css("z-index", 9999);
                                        var hStyle = (scope.$element[0].querySelector(".angular-ui-tree-handle") || scope.$element[0]).currentStyle;
                                        hStyle && (document.body.setAttribute("ui-tree-cursor", $document.find("body").css("cursor") || ""), $document.find("body").css({
                                            cursor: hStyle.cursor + "!important"
                                        })), scope.$element.after(placeElm), scope.$element.after(hiddenPlaceElm), dragElm.append(scope.$element), $document.find("body").append(dragElm), dragElm.css({
                                            left: eventObj.pageX - pos.offsetX + "px",
                                            top: eventObj.pageY - pos.offsetY + "px"
                                        }), elements = {
                                            placeholder: placeElm,
                                            dragging: dragElm
                                        }, angular.element($document).bind("touchend", dragEndEvent), angular.element($document).bind("touchcancel", dragEndEvent), angular.element($document).bind("touchmove", dragMoveEvent), angular.element($document).bind("mouseup", dragEndEvent), angular.element($document).bind("mousemove", dragMoveEvent), angular.element($document).bind("mouseleave", dragCancelEvent), document_height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight), document_width = Math.max(body.scrollWidth, body.offsetWidth, html.clientWidth, html.scrollWidth, html.offsetWidth)
                                    }
                                }
                            }
                        }
                    },
                    dragMove = function(e) {
                        if (!dragStarted) return void(dragDelaying || (dragStarted = !0, scope.$apply(function() {
                            scope.$callbacks.dragStart(dragInfo.eventArgs(elements, pos))
                        })));
                        var prev, leftElmPos, topElmPos, eventObj = $uiTreeHelper.eventObj(e);
                        if (dragElm) {
                            e.preventDefault(), $window.getSelection ? $window.getSelection().removeAllRanges() : $window.document.selection && $window.document.selection.empty(), leftElmPos = eventObj.pageX - pos.offsetX, topElmPos = eventObj.pageY - pos.offsetY, 0 > leftElmPos && (leftElmPos = 0), 0 > topElmPos && (topElmPos = 0), topElmPos + 10 > document_height && (topElmPos = document_height - 10), leftElmPos + 10 > document_width && (leftElmPos = document_width - 10), dragElm.css({
                                left: leftElmPos + "px",
                                top: topElmPos + "px"
                            });
                            var top_scroll = window.pageYOffset || $window.document.documentElement.scrollTop,
                                bottom_scroll = top_scroll + (window.innerHeight || $window.document.clientHeight || $window.document.clientHeight);
                            if (bottom_scroll < eventObj.pageY && document_height >= bottom_scroll && window.scrollBy(0, 10), top_scroll > eventObj.pageY && window.scrollBy(0, -10), $uiTreeHelper.positionMoved(e, pos, firstMoving), firstMoving) return void(firstMoving = !1);
                            if (pos.dirAx && pos.distAxX >= config.levelThreshold && (pos.distAxX = 0, pos.distX > 0 && (prev = dragInfo.prev(), prev && !prev.collapsed && prev.accept(scope, prev.childNodesCount()) && (prev.$childNodesScope.$element.append(placeElm), dragInfo.moveTo(prev.$childNodesScope, prev.childNodes(), prev.childNodesCount()))), pos.distX < 0)) {
                                var next = dragInfo.next();
                                if (!next) {
                                    var target = dragInfo.parentNode();
                                    target && target.$parentNodesScope.accept(scope, target.index() + 1) && (target.$element.after(placeElm), dragInfo.moveTo(target.$parentNodesScope, target.siblings(), target.index() + 1))
                                }
                            }
                            var displayElm, targetX = ($uiTreeHelper.offset(dragElm).left - $uiTreeHelper.offset(placeElm).left >= config.threshold, eventObj.pageX - $window.document.body.scrollLeft),
                                targetY = eventObj.pageY - (window.pageYOffset || $window.document.documentElement.scrollTop);
                            angular.isFunction(dragElm.hide) ? dragElm.hide() : (displayElm = dragElm[0].style.display, dragElm[0].style.display = "none"), $window.document.elementFromPoint(targetX, targetY);
                            var targetElm = angular.element($window.document.elementFromPoint(targetX, targetY));
                            if (angular.isFunction(dragElm.show) ? dragElm.show() : dragElm[0].style.display = displayElm, !pos.dirAx) {
                                var targetBefore, targetNode;
                                targetNode = targetElm.scope();
                                var isEmpty = !1;
                                if (!targetNode) return;
                                if ("uiTree" == targetNode.$type && targetNode.dragEnabled && (isEmpty = targetNode.isEmpty()), "uiTreeHandle" == targetNode.$type && (targetNode = targetNode.$nodeScope), "uiTreeNode" != targetNode.$type && !isEmpty) return;
                                if (treeScope && placeElm.parent()[0] != treeScope.$element[0] && (treeScope.resetEmptyElement(), treeScope = null), isEmpty) treeScope = targetNode, targetNode.$nodesScope.accept(scope, 0) && (targetNode.place(placeElm), dragInfo.moveTo(targetNode.$nodesScope, targetNode.$nodesScope.childNodes(), 0));
                                else if (targetNode.dragEnabled()) {
                                    targetElm = targetNode.$element;
                                    var targetOffset = $uiTreeHelper.offset(targetElm);
                                    targetBefore = targetNode.horizontal ? eventObj.pageX < targetOffset.left + $uiTreeHelper.width(targetElm) / 2 : eventObj.pageY < targetOffset.top + $uiTreeHelper.height(targetElm) / 2, targetNode.$parentNodesScope.accept(scope, targetNode.index()) ? targetBefore ? (targetElm[0].parentNode.insertBefore(placeElm[0], targetElm[0]), dragInfo.moveTo(targetNode.$parentNodesScope, targetNode.siblings(), targetNode.index())) : (targetElm.after(placeElm), dragInfo.moveTo(targetNode.$parentNodesScope, targetNode.siblings(), targetNode.index() + 1)) : !targetBefore && targetNode.accept(scope, targetNode.childNodesCount()) && (targetNode.$childNodesScope.$element.append(placeElm), dragInfo.moveTo(targetNode.$childNodesScope, targetNode.childNodes(), targetNode.childNodesCount()))
                                }
                            }
                            scope.$apply(function() {
                                scope.$callbacks.dragMove(dragInfo.eventArgs(elements, pos))
                            })
                        }
                    },
                    dragEnd = function(e) {
                        e.preventDefault(), dragElm && (scope.$treeScope.$apply(function() {
                            scope.$callbacks.beforeDrop(dragInfo.eventArgs(elements, pos))
                        }), hiddenPlaceElm.replaceWith(scope.$element), placeElm.remove(), dragElm.remove(), dragElm = null, scope.$$apply ? (dragInfo.apply(), scope.$treeScope.$apply(function() {
                            scope.$callbacks.dropped(dragInfo.eventArgs(elements, pos))
                        })) : bindDrag(), scope.$treeScope.$apply(function() {
                            scope.$callbacks.dragStop(dragInfo.eventArgs(elements, pos))
                        }), scope.$$apply = !1, dragInfo = null);
                        var oldCur = document.body.getAttribute("ui-tree-cursor");
                        null !== oldCur && ($document.find("body").css({
                            cursor: oldCur
                        }), document.body.removeAttribute("ui-tree-cursor")), angular.element($document).unbind("touchend", dragEndEvent), angular.element($document).unbind("touchcancel", dragEndEvent), angular.element($document).unbind("touchmove", dragMoveEvent), angular.element($document).unbind("mouseup", dragEndEvent), angular.element($document).unbind("mousemove", dragMoveEvent), angular.element($window.document.body).unbind("mouseleave", dragCancelEvent)
                    },
                    dragStartEvent = function(e) {
                        scope.dragEnabled() && dragStart(e)
                    },
                    dragMoveEvent = function(e) {
                        dragMove(e)
                    },
                    dragEndEvent = function(e) {
                        scope.$$apply = !0, dragEnd(e)
                    },
                    dragCancelEvent = function(e) {
                        dragEnd(e)
                    },
                    bindDrag = function() {
                        element.bind("touchstart mousedown", function(e) {
                            dragDelaying = !0, dragStarted = !1, dragStartEvent(e), dragTimer = $timeout(function() {
                                dragDelaying = !1
                            }, scope.dragDelay)
                        }), element.bind("touchend touchcancel mouseup", function() {
                            $timeout.cancel(dragTimer)
                        })
                    };
                bindDrag(), angular.element($window.document.body).bind("keydown", function(e) {
                    27 == e.keyCode && (scope.$$apply = !1, dragEnd(e))
                })
            }
        }
    }])
}(),
function() {
    "use strict";
    angular.module("ui.tree").directive("uiTreeHandle", ["treeConfig", "$window", function(treeConfig) {
        return {
            require: "^uiTreeNode",
            restrict: "A",
            scope: !0,
            controller: "TreeHandleController",
            link: function(scope, element, attrs, treeNodeCtrl) {
                var config = {};
                angular.extend(config, treeConfig), config.handleClass && element.addClass(config.handleClass), scope != treeNodeCtrl.scope && (scope.$nodeScope = treeNodeCtrl.scope, treeNodeCtrl.scope.$handleScope = scope)
            }
        }
    }])
}();
