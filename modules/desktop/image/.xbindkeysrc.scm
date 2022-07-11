(define DEBUG #f)

(define (path-join . args) (string-join args "/"))
(define HOME (getenv "HOME"))
;;(define raise-volume "amixer -c 0 sset 'Master',0 2dB+")
;;(define lower-volume "amixer -c 0 sset 'Master',0 2dB-")
;;(define mute "amixer set Master toggle")
(define raise-volume-by-1 "ponymix increase 1")
(define lower-volume-by-1 "ponymix decrease 1")
(define raise-volume-a-lot "ponymix increase 5")
(define lower-volume-a-lot "ponymix decrease 5")
(define mute "ponymix toggle")

;; Quick and easy intel backlight adjustment. Does not call
;; external scripts so it's always fast.

;; Prerequisite: create /etc/udev/rules.d/99-intel_backlight.rules
;;
;; SUBSYSTEM=="backlight", ACTION=="add", RUN+="/bin/chgrp -R video /sys%p", RUN+="/bin/chmod -R g=u /sys%p"
;; SUBSYSTEM=="backlight", ACTION=="change", ENV{TRIGGER}!="none", RUN+="/bin/chgrp -R video /sys%p", RUN+="/bin/chmod -R g=u /sys%p"
;;
;; (And ensure your user is in the video group.)

(define-syntax nofail
  (syntax-rules ()
    ((_ body ...) (catch #t (lambda () body ...) (lambda _ #f)))))

(define (trace what expr)
  (when DEBUG
    (display (format "TRACE ~a: ~a\n" what expr)))
  expr)

(define BACKLIGHT-BASE "/sys/class/backlight/intel_backlight")
(when (access? (path-join BACKLIGHT-BASE "brightness") W_OK)
  (let ()
    (define BACKLIGHT-MAX (call-with-input-file (path-join BACKLIGHT-BASE "max_brightness") read))
    (define BACKLIGHT-STEP (quotient BACKLIGHT-MAX 35))
    (define (get-brightness)
      (trace "get-brightness" (call-with-input-file (path-join BACKLIGHT-BASE "brightness") read)))
    (define (write-brightness brightness)
      (trace "write-brigtness"
             (call-with-output-file (path-join BACKLIGHT-BASE "brightness")
               (lambda (op) (display brightness op)))))
    (define* (increase-brightness #:optional (step BACKLIGHT-STEP))
      (nofail
       (define brightness (get-brightness))
       (write-brightness (if (= 0 brightness)
                             1
                             (min BACKLIGHT-MAX
                                  (+ step brightness))))))
    (define* (decrease-brightness #:optional (step BACKLIGHT-STEP))
      (nofail
       (define brightness (get-brightness))
       ;; Takes the maximum of the step to decrease by AND either 1 (if
       ;; brightness was greater than 1) or 0 (if brightness was 1).
       (write-brightness (max (- brightness step)
                              (if (> brightness 1) 1 0)))))
    (xbindkey-function '(XF86MonBrightnessDown) (lambda () (decrease-brightness (* BACKLIGHT-STEP 4))))
    (xbindkey-function '(XF86MonBrightnessUp) (lambda ()  (increase-brightness (* BACKLIGHT-STEP 4))))
    (xbindkey-function '(Shift XF86MonBrightnessDown) decrease-brightness)
    (xbindkey-function '(Shift XF86MonBrightnessUp) increase-brightness)))

(xbindkey '(Mod4 k) "dunstctl close-all")
(xbindkey '(Mod4 Shift k) "dunstctl context")
(xbindkey '(Mod4 Mod1 k) "dunstctl history-popup")
(xbindkey '(XF86AudioRaiseVolume) raise-volume-by-1)
(xbindkey '(XF86AudioLowerVolume) lower-volume-by-1)
(xbindkey '(Shift XF86AudioRaiseVolume) raise-volume-a-lot)
(xbindkey '(Shift XF86AudioLowerVolume) lower-volume-a-lot)
(xbindkey '(XF86AudioMute) mute)
(xbindkey '(XF86AudioMicMute) "toggle-mute")
(xbindkey '(Mod4 Shift F12) "toggle-mute")
(define (mpvc . args)
  (string-append "mpvc -S "
                 (path-join HOME ".config/mpv/mpv.socket")
                 " "
                 (string-join args " ")))
(xbindkey '(XF86AudioPlay) (mpvc "toggle"))
(xbindkey '(XF86AudioNext) (mpvc "next"))
(xbindkey '(XF86AudioPrev) (mpvc "prev"))
(xbindkey '(Mod4 F12) raise-volume-by-1)
(xbindkey '(Mod4 F11) lower-volume-by-1)
(xbindkey '(Mod4 Shift F12) raise-volume-a-lot)
(xbindkey '(Mod4 Shift F11) lower-volume-a-lot)
(xbindkey '(Mod4 Shift s) "rofi-screenshot")
(xbindkey '(Mod4 Mod1 Shift s) "rofi-screenshot -s")
(xbindkey '(Mod4 F10) mute)
(xbindkey '(Mod4 F8) (mpvc "toggle"))
(xbindkey '(Mod4 F9) (mpvc "next"))
(xbindkey '(Mod4 F7) (mpvc "prev"))
;(xbindkey '(Mod4 c) "lock")
;(xbindkey '(Mod4 Mod1 Shift c) "nap")
(xbindkey '(Mod4 F1) "toggle-dvorak")
(xbindkey '(Mod4 grave) "raise-or-create-emacs")
(xbindkey '(Mod4 semicolon) "emacsclient -c")
(xbindkey '(Mod4 d) "dmoji")
(xbindkey '(Mod4 slash) "rofi-pass --last-used")
                                        ;(xbindkey '(Mod4 t) "gnome-terminal")
                                        ;(xbindkey '(XF86Sleep) (path-join HOME "bin/nap"))
;; (xbindkey '(Mod4 Shift q) "sh -c 'zenity --question --text \"Log off $USER?\" && pkill dwm'")
(xbindkey '(Mod4 F3) "rofi-pass")
(xbindkey '(Mod4 F2) "toggle-redshift")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bspwm bindings
(use-modules (ice-9 format))
(define-syntax xbindkey/group
  (syntax-rules ()
    ((_ common-binding common-command (differences differences* ...))
     (begin
       (let* ((different-binding (car differences))
              (binding (append common-binding
                               (if (list? different-binding)
                                   different-binding
                                   (list different-binding))))
              (different-command (cadr differences))
              (command (if (list? different-command)
                           different-command
                           (list different-command))))
         (xbindkey binding
                   (apply format common-command command))
         (xbindkey/group common-binding common-command
                         (differences* ...)))))
    ((_ common-binding common-command ()) #t)))

;; Reload xbindkeys config
(xbindkey '(Mod4 Shift backslash) "pkill -SIGHUP xbindkeys")
;; Spawn terminal
;(xbindkey '(Mod4 Return) "walacritty")
;; Run program
(xbindkey '(Mod4 u) "rofi -show run")
(xbindkey '(Mod4 w) "rofi -show window")

(xbindkey '(Mod4 F3) "toggle-touchpad")

(xbindkey '(Mod4 s) "banish-cursor")
