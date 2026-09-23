; extends

; Predicate registered in theme.lua. Arrays do not increase object depth.
((pair key: (string) @poimandres.json.key.1)
  (#poimandres-json-depth? @poimandres.json.key.1 "1")
  (#set! priority 130))

((pair key: (string) @poimandres.json.key.2)
  (#poimandres-json-depth? @poimandres.json.key.2 "2")
  (#set! priority 130))

((pair key: (string) @poimandres.json.key.3)
  (#poimandres-json-depth? @poimandres.json.key.3 "3")
  (#set! priority 130))

((pair key: (string) @poimandres.json.key.4)
  (#poimandres-json-depth? @poimandres.json.key.4 "4")
  (#set! priority 130))
