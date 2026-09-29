// ──────────────────────────────────────────────────────────────
// practice-mc.typ — reusable multi-page multiple-choice template
// Normal readable size (11pt), content may flow across any number
// of pages. Best for grade 11+ (multiple choice only).
//
// Usage:
//   #import "practice-mc.typ": *
//   #paper(id: "G11 MATH · RELATIONS & FUNCTIONS · SET 01")[
//     #sec("Unit 1 — Relations")
//     #mcq(1)[prompt][a][b][c][d]
//     #mcq(2)[prompt][a][b][c][d]
//   ]
//   (answer key: #paper(id: "… · ANSWER KEY")[mcq-table / mcq answers])
// ──────────────────────────────────────────────────────────────

#set page("a4", margin: (x: 14mm, y: 13mm))
#set text(font: "New Computer Modern", size: 11pt)
#set par(leading: 0.6em, justify: false)

#let GREY = luma(140)

// Paper wrapper for a multi-page test. No auto-shrink: content just
// continues to the next page. Numbers restart per page via #pagebreak().
#let paper(id: "", body) = text(size: 9.5pt)[#id] + v(3pt) + box(width: 100%, height: 0.6pt, stroke: 0.5pt + black) + v(4pt) + body

// Section heading.
#let sec(name) = text(size: 12pt, weight: "bold")[#name] + v(4pt)

// Multiple-choice item at readable size, options on wrapped line.
#let mcq(n, prompt, oa, ob, oc, od) = block(below: 7pt, above: 0pt, width: 100%)[
  #text(weight: "bold")[#n.] #prompt \
  #v(1.5pt)
  #text(size: 10.5pt)[(a) #oa    (b) #ob    (c) #oc    (d) #od]
]

// Two-column paired grid for questions.
#let pairgrid(..items) = grid(columns: 2, column-gutter: 14pt, row-gutter: 7pt, ..items)

// Answer table for the key: columns = (Q, Ans) pairs.
#let ans-table(pairs) = table(
  columns: (auto, auto, auto, auto, auto, auto),
  stroke: 0.35pt + luma(170),
  align: (right, center, center, center, center, center),
  inset: 3pt,
  table.header[Q][Ans][Q][Ans][Q][Ans],
  ..pairs.map(p => (text(str(p.at(0))), str(p.at(1)))).flatten(),
)