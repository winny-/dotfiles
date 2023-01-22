(use-modules (ice-9 format))
(use-modules (ice-9 threads))

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

(define orig-format format)
(define (format s . args)
  (apply orig-format #f s args))

(define-syntax nofail
  (syntax-rules ()
    ((_ body ...)
     (catch #t
            (lambda () body ...)
            (lambda args
              (display (format "nofail caught: ~a\n" args))
              #f)))))


(define (trace what expr)
  (when DEBUG
    (display (format "TRACE ~a: ~a\n" what expr)))
  expr)

(define (bind-brightness-control big-increment big-decrement small-increment small-decrement)
  (define mutex (make-mutex))
  ;; Try to lock or give up right away.
  (define (with-critical func)
    (lambda ()
      (when (try-mutex mutex)
        (func)
        (unlock-mutex mutex))))
  (for-each
   (lambda (keys)
     (define down (car keys))
     (define up (cadr keys))
     (xbindkey-function up (with-critical big-increment))
     (xbindkey-function down (with-critical big-decrement))
     (xbindkey-function (cons 'Shift up) (with-critical small-increment))
     (xbindkey-function (cons 'Shift down) (with-critical small-decrement)))
   '(((XF86MonBrightnessDown) (XF86MonBrightnessUp))
     ((Mod4 F5) (Mod4 F6)))))

;; Quick and easy intel backlight adjustment. Does not call
;; external scripts so it's always fast.

;; Prerequisite: create /etc/udev/rules.d/99-intel_backlight.rules
;;
;; SUBSYSTEM=="backlight", ACTION=="add", RUN+="/bin/chgrp -R video /sys%p", RUN+="/bin/chmod -R g=u /sys%p"
;; SUBSYSTEM=="backlight", ACTION=="change", ENV{TRIGGER}!="none", RUN+="/bin/chgrp -R video /sys%p", RUN+="/bin/chmod -R g=u /sys%p"
;;
;; (And ensure your user is in the video group.)
;;
;; Or, use ddcontrol to control your monitor's brightness...
(define BACKLIGHT-BASE "/sys/class/backlight/intel_backlight")
(cond
 ((access? (path-join BACKLIGHT-BASE "brightness") W_OK)
  (display (format "Setting up keybinds for backlight class device.\n"))
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
    (bind-brightness-control
     (lambda () (increase-brightness (* BACKLIGHT-STEP 4)))
     (lambda () (decrease-brightness (* BACKLIGHT-STEP 4)))
     increase-brightness
     decrease-brightness)))
 (else
  (display (format "Setting up keybinds for DDC monitor brightness control.\n"))
  (let ()
    ;; XXX This works on stargate, dunno of other machines.
    (define (adjust-brightness amount)
      (nofail
       (system (format "ddccontrol -r 0x10 -W ~a dev:/dev/i2c-10" amount amount))))
    (bind-brightness-control
     (lambda () (adjust-brightness 10))
     (lambda () (adjust-brightness -10))
     (lambda () (adjust-brightness 1))
     (lambda () (adjust-brightness -1))))))

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
(xbindkey '(XF86AudioPlay) "playerctl play-pause")
(xbindkey '(XF86AudioNext) "playerctl next")
(xbindkey '(XF86AudioPrev) "playerctl previous")
(xbindkey '(Mod4 F12) raise-volume-by-1)
(xbindkey '(Mod4 F11) lower-volume-by-1)
(xbindkey '(Mod4 Shift F12) raise-volume-a-lot)
(xbindkey '(Mod4 Shift F11) lower-volume-a-lot)
(xbindkey '(Mod4 Shift s) "rofi-screenshot")
(xbindkey '(Mod4 Mod1 Shift s) "rofi-screenshot -s")
(xbindkey '(Mod4 F10) mute)
(xbindkey '(Mod4 F8) "playerctl play-pause")
(xbindkey '(Mod4 F9) "playerctl next")
(xbindkey '(Mod4 F7) "playerctl previous")
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
