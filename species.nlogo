globals [
  tot-ticks
  wor-len

  c-count
  im
  c-max

  next-indi
]

patches-own [
  payoff
  if-grown
]

to setup
  clear-all
  set next-indi false
  set tot-ticks round(T / interval_length)
  set wor-len round(sqrt(0.0001 * T ^ 4.76))
  resize-world 0 (wor-len - 1) 0 (wor-len - 1)

  set c-count 0
  set c-max 0.5 * wor-len * wor-len
  set im round (15 * 0.0001 * T ^ 4.76)

  ask patches [
    set pcolor white
    ;set label payoff

  ]

  ;ask patch 40 40 [
    ;set pcolor blue
 ; ]
  if-else (initialstate = "seperated") [
    ;;T=40
    if (T = 40) [
      ask patch 30 30 [
        set pcolor blue
      ]
    ]

    ;; T=50
    if (T = 50) [
      ask patch 70 90 [
        set pcolor blue
      ]
      ask patch 20 50 [
        set pcolor blue
      ]
      ask patch 80 30 [
        set pcolor blue
      ]
    ]

    ;; T=60
    if (T = 60) [
      ask patch 30 85 [
        set pcolor blue
      ]
      ask patch 58 34 [
        set pcolor blue
      ]
      ask patch 54 146 [
        set pcolor blue
      ]
      ask patch 85 85 [
        set pcolor blue
      ]
      ask patch 114 136 [
        set pcolor blue
      ]
      ask patch 142 85 [
        set pcolor blue
      ]
      ask patch 114 28 [
        set pcolor blue
      ]
    ]


  ][

    ;;T=40
    if (T = 40) [
      ask patch 30 30 [
        set pcolor blue
      ]
    ]

    ;; T=50
    if (T = 50) [
      ask patch 50 50 [
        set pcolor blue
      ]
      ask patch 51 50 [
        set pcolor blue
      ]
      ask patch 50 51 [
        set pcolor blue
      ]
    ]

    ;; T=60
    if (T = 60) [
      ask patch 80 80 [
        set pcolor blue
      ]
      ask patch 80 81 [
        set pcolor blue
      ]
      ask patch 81 80 [
        set pcolor blue
      ]
      ask patch 81 81 [
        set pcolor blue
      ]
      ask patch 81 82 [
        set pcolor blue
      ]
      ask patch 80 79 [
        set pcolor blue
      ]
      ask patch 79 80 [
        set pcolor blue
      ]
    ]


  ]


  reset-ticks
end

to go
  if (ticks >= tot-ticks or c-count > c-max) [
    print ticks * interval_length
    ;print c-count
    ;print c-max
    set next-indi true
    stop]

  ask patches with [pcolor = white] [
    if (random-float 1 < 0.0000001) [set pcolor blue]
  ]

  ask patches [calculate-payoff]

  ask patches [update]

  set c-count count patches with [pcolor = blue]
  set im (im - c-count)

  tick
end

to calculate-payoff
  let c-nei count neighbors with [pcolor = blue]
  let h-nei count neighbors with [pcolor != blue]
  let my-cc c-c
  let my-ch c-h
  let my-hc h-c
  let my-hh h-h
  let my-punish 0.5

  if-else (pcolor = blue)
  [set payoff c-nei * my-cc + h-nei * my-ch - my-punish]
  [set payoff c-nei * my-hc + h-nei * my-hh]
end

to update

  ;----------
  let min-nei min-one-of patches in-radius 1.5 [payoff]
  let nei-of-this-min [neighbors] of min-nei
  let max-nei-of-this-min max-one-of nei-of-this-min [payoff]
  if ([pcolor] of min-nei != [pcolor] of max-nei-of-this-min) [
    ask min-nei [
      set pcolor [pcolor] of max-nei-of-this-min
    ]
    ;; not simu, if simu, comment out the following two lines
    ;ask min-nei [calculate-payoff]
    ;ask [neighbors] of min-nei [calculate-payoff]

  ]
  ;-----------------
  let nei neighbors
  ;let max-nei max-one-of nei [payoff]
  ;if (pcolor != [pcolor] of max-nei) [
   ; set pcolor [pcolor] of max-nei
  ;]
end

to setupPop
  let i 0
  print "-------pop start-------"
  while [i < 100] [
    setup
    while [next-indi = false] [go]

    set i i + 1
  ]
  print "-------pop end-------"
end
