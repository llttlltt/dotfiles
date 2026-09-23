; extends

; Original Poimandres JS/TS falsy and this/super colours.
; Higher than semantic tokens so a server cannot recolour these literals.
([(false) (null) (undefined)] @poimandres.falsy
  (#set! priority 130))

([(this) (super)] @poimandres.self
  (#set! priority 130))
