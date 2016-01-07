/**
 * doc https://github.com/m-e-conroy/angular-dialog-service
 * angular-dialog-service - A service to handle common dialog types in a web application.  Built on top of Angular-Bootstrap's modal
 * @version v5.2.7
 * @author Michael Conroy, michael.e.conroy@gmail.com
 * @license MIT, http://www.opensource.org/licenses/MIT
 */
! function() {
    "use strict";
    var a = angular.module("translate.sub", []);
    a.provider("$translate", [function() {
        var a = [],
            n = "en-US";
        this.translations = function(e, s) {
            angular.isDefined(e) && angular.isDefined(s) && (a[e] = angular.copy(s), n = e)
        }, this.$get = [function() {
            return {
                instant: function(e) {
                    return angular.isDefined(e) && angular.isDefined(a[n][e]) ? a[n][e] : ""
                }
            }
        }]
    }]), a.filter("translate", ["$translate", function(a) {
        return function(n) {
            return a.instant(n)
        }
    }]);
    var n;
    try {
        angular.module("pascalprecht.translate"), n = angular.module("dialogs.controllers", ["ui.bootstrap.modal", "pascalprecht.translate"])
    } catch (e) {
        n = angular.module("dialogs.controllers", ["ui.bootstrap.modal", "translate.sub"])
    }
    n.controller("errorDialogCtrl", ["$scope", "$modalInstance", "$translate", "data", function(a, n, e, s) {
        a.header = angular.isDefined(s.header) ? s.header : e.instant("DIALOGS_ERROR"), a.msg = angular.isDefined(s.msg) ? s.msg : e.instant("DIALOGS_ERROR_MSG"), a.icon = angular.isDefined(s.fa) && angular.equals(s.fa, !0) ? "fa fa-warning" : "glyphicon glyphicon-warning-sign", a.close = function() {
            n.close(), a.$destroy()
        }
    }]), n.controller("waitDialogCtrl", ["$scope", "$modalInstance", "$translate", "$timeout", "data", function(a, n, e, s, t) {
        a.header = angular.isDefined(t.header) ? t.header : e.instant("DIALOGS_PLEASE_WAIT_ELIPS"), a.msg = angular.isDefined(t.msg) ? t.msg : e.instant("DIALOGS_PLEASE_WAIT_MSG"), a.progress = angular.isDefined(t.progress) ? t.progress : 100, a.icon = angular.isDefined(t.fa) && angular.equals(t.fa, !0) ? "fa fa-clock-o" : "glyphicon glyphicon-time", a.$on("dialogs.wait.complete", function() {
            s(function() {
                n.close(), a.$destroy()
            })
        }), a.$on("dialogs.wait.message", function(n, e) {
            a.msg = angular.isDefined(e.msg) ? e.msg : a.msg
        }), a.$on("dialogs.wait.progress", function(n, e) {
            a.msg = angular.isDefined(e.msg) ? e.msg : a.msg, a.progress = angular.isDefined(e.progress) ? e.progress : a.progress
        }), a.getProgress = function() {
            return {
                width: a.progress + "%"
            }
        }
    }]), n.controller("notifyDialogCtrl", ["$scope", "$modalInstance", "$translate", "data", function(a, n, e, s) {
        a.header = angular.isDefined(s.header) ? s.header : e.instant("DIALOGS_NOTIFICATION"), a.msg = angular.isDefined(s.msg) ? s.msg : e.instant("DIALOGS_NOTIFICATION_MSG"), a.icon = angular.isDefined(s.fa) && angular.equals(s.fa, !0) ? "fa fa-info" : "glyphicon glyphicon-info-sign", a.close = function() {
            n.close(), a.$destroy()
        }
    }]), n.controller("confirmDialogCtrl", ["$scope", "$modalInstance", "$translate", "data", function(a, n, e, s) {
        a.header = angular.isDefined(s.header) ? s.header : e.instant("DIALOGS_CONFIRMATION"), a.msg = angular.isDefined(s.msg) ? s.msg : e.instant("DIALOGS_CONFIRMATION_MSG"), a.icon = angular.isDefined(s.fa) && angular.equals(s.fa, !0) ? "fa fa-check" : "glyphicon glyphicon", a.no = function() {
            n.dismiss("no")
        }, a.yes = function() {
            n.close("yes")
        }
    }]), angular.module("dialogs.services", ["ui.bootstrap.modal", "dialogs.controllers"]).provider("dialogs", [function() {
        var a = !0,
            n = !0,
            e = "dialogs-default",
            s = !0,
            t = null,
            l = "lg",
            o = !1,
            r = function(s) {
                var t = {};
                return s = s || {}, t.kb = angular.isDefined(s.keyboard) ? s.keyboard : n, t.bd = angular.isDefined(s.backdrop) ? s.backdrop : a, t.ws = angular.isDefined(s.size) && (angular.equals(s.size, "sm") || angular.equals(s.size, "lg") || angular.equals(s.size, "md")) ? s.size : l, t.wc = angular.isDefined(s.windowClass) ? s.windowClass : e, t
            };
        this.useBackdrop = function(n) {
            angular.isDefined(n) && (a = n)
        }, this.useEscClose = function(a) {
            angular.isDefined(a) && (n = angular.equals(a, 0) || angular.equals(a, "false") || angular.equals(a, "no") || angular.equals(a, null) || angular.equals(a, !1) ? !1 : !0)
        }, this.useClass = function(a) {
            angular.isDefined(a) && (e = a)
        }, this.useCopy = function(a) {
            angular.isDefined(a) && (s = angular.equals(a, 0) || angular.equals(a, "false") || angular.equals(a, "no") || angular.equals(a, null) || angular.equals(a, !1) ? !1 : !0)
        }, this.setWindowTmpl = function(a) {
            angular.isDefined(a) && (t = a)
        }, this.setSize = function(a) {
            angular.isDefined(a) && (l = angular.equals(a, "sm") || angular.equals(a, "lg") || angular.equals(a, "md") ? a : l)
        }, this.useFontAwesome = function() {
            o = !0
        }, this.$get = ["$modal", function(a) {
            return {
                error: function(n, e, s) {
                    return s = r(s), a.open({
                        templateUrl: "/dialogs/error.html",
                        controller: "errorDialogCtrl",
                        backdrop: s.bd,
                        keyboard: s.kb,
                        windowClass: s.wc,
                        size: s.ws,
                        resolve: {
                            data: function() {
                                return {
                                    header: angular.copy(n),
                                    msg: angular.copy(e),
                                    fa: o
                                }
                            }
                        }
                    })
                },
                wait: function(n, e, s, t) {
                    return t = r(t), a.open({
                        templateUrl: "/dialogs/wait.html",
                        controller: "waitDialogCtrl",
                        backdrop: t.bd,
                        keyboard: t.kb,
                        windowClass: t.wc,
                        size: t.ws,
                        resolve: {
                            data: function() {
                                return {
                                    header: angular.copy(n),
                                    msg: angular.copy(e),
                                    progress: angular.copy(s),
                                    fa: o
                                }
                            }
                        }
                    })
                },
                notify: function(n, e, s) {
                    return s = r(s), a.open({
                        templateUrl: "/dialogs/notify.html",
                        controller: "notifyDialogCtrl",
                        backdrop: s.bd,
                        keyboard: s.kb,
                        windowClass: s.wc,
                        size: s.ws,
                        resolve: {
                            data: function() {
                                return {
                                    header: angular.copy(n),
                                    msg: angular.copy(e),
                                    fa: o
                                }
                            }
                        }
                    })
                },
                confirm: function(n, e, s) {
                    return s = r(s), a.open({
                        templateUrl: "/dialogs/confirm.html",
                        controller: "confirmDialogCtrl",
                        backdrop: s.bd,
                        keyboard: s.kb,
                        windowClass: s.wc,
                        size: s.ws,
                        resolve: {
                            data: function() {
                                return {
                                    header: angular.copy(n),
                                    msg: angular.copy(e),
                                    fa: o
                                }
                            }
                        }
                    })
                },
                create: function(n, e, t, l) {
                    var o = l && angular.isDefined(l.copy) ? l.copy : s;
                    return l = r(l), a.open({
                        templateUrl: n,
                        controller: e,
                        keyboard: l.kb,
                        backdrop: l.bd,
                        windowClass: l.wc,
                        size: l.ws,
                        resolve: {
                            data: function() {
                                return o ? angular.copy(t) : t
                            }
                        }
                    })
                }
            }
        }]
    }]), angular.module("dialogs.main", ["dialogs.services", "ngSanitize"]).config(["$translateProvider", "dialogsProvider", function(a, n) {
        try {
            angular.module("pascalprecht.translate")
        } catch (e) {
            a.translations("en-US", {
                DIALOGS_ERROR: "Error",
                DIALOGS_ERROR_MSG: "An unknown error has occurred.",
                DIALOGS_CLOSE: "Close",
                DIALOGS_PLEASE_WAIT: "Please Wait",
                DIALOGS_PLEASE_WAIT_ELIPS: "Please Wait...",
                DIALOGS_PLEASE_WAIT_MSG: "Waiting on operation to complete.",
                DIALOGS_PERCENT_COMPLETE: "% Complete",
                DIALOGS_NOTIFICATION: "Notification",
                DIALOGS_NOTIFICATION_MSG: "Unknown application notification.",
                DIALOGS_CONFIRMATION: "Confirmation",
                DIALOGS_CONFIRMATION_MSG: "Confirmation required.",
                DIALOGS_OK: "确定",
                DIALOGS_YES: "确定",
                DIALOGS_NO: "取消"
            })
        }
        try {
            var s = document.styleSheets;
            a: for (var t = s.length - 1; t >= 0; t--) {
                var l = null,
                    o = null;
                if (!s[t].disabled) {
                    if (null !== s[t].href && (l = s[t].match(/font\-*awesome/i)), angular.isArray(l)) {
                        n.useFontAwesome();
                        break
                    }
                    o = s[t].cssRules;
                    for (var r = o.length - 1; r >= 0; r--)
                        if (".fa" == o[r].selectorText.toLowerCase()) {
                            n.useFontAwesome();
                            break a
                        }
                }
            }
        } catch (e) {}
    }]).run(["$templateCache", "$interpolate", function(a, n) {
        var e = n.startSymbol(),
            s = n.endSymbol();
        a.put("/dialogs/error.html", '<div class="modal-header dialog-header-error"><button type="button" class="close" ng-click="close()">&times;</button><h4 class="modal-title text-danger"><span class="' + e + "icon" + s + '"></span> <span ng-bind-html="header"></span></h4></div><div class="modal-body text-danger" ng-bind-html="msg"></div><div class="modal-footer"><button type="button" class="btn btn-default" ng-click="close()">' + e + '"DIALOGS_CLOSE" | translate' + s + "</button></div>"), a.put("/dialogs/wait.html", '<div class="modal-header dialog-header-wait"><h4 class="modal-title"><span class="' + e + "icon" + s + '"></span> ' + e + "header" + s + '</h4></div><div class="modal-body"><p ng-bind-html="msg"></p><div class="progress progress-striped active"><div class="progress-bar progress-bar-info" ng-style="getProgress()"></div><span class="sr-only">' + e + "progress" + s + e + '"DIALOGS_PERCENT_COMPLETE" | translate' + s + "</span></div></div>"), a.put("/dialogs/notify.html", '<div class="modal-header dialog-header-notify"><button type="button" class="close" ng-click="close()" class="pull-right">&times;</button><h4 class="modal-title text-info"><span class="' + e + "icon" + s + '"></span> ' + e + "header" + s + '</h4></div><div class="modal-body text-info" ng-bind-html="msg"></div><div class="modal-footer"><button type="button" class="btn btn-primary" ng-click="close()">' + e + '"DIALOGS_OK" | translate' + s + "</button></div>"), a.put("/dialogs/confirm.html", '<div class="modal-header dialog-header-confirm"><button type="button" class="close" ng-click="no()">&times;</button><h4 class="modal-title"><span class="' + e + "icon" + s + '"></span> ' + e + "header" + s + '</h4></div><div class="modal-body" ng-bind-html="msg"></div><div class="modal-footer"><button type="button" class="btn btn-default btn-lg" ng-click="no()">' + e + '"DIALOGS_NO" | translate' + s + '</button><button type="button" class="btn btn-success btn-lg" ng-click="yes()">' + e + '"DIALOGS_YES" | translate' + s + "</button></div>")
    }])
}();
