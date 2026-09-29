// ──────────────────────────────────────────────────────────────
// practice-paper.typ — reusable one-page exam template
// Monotone, no header/footer, auto-shrinks to fit a single page.
//
// Usage:
//   #import "practice-paper.typ": *
//   #paper(id: "G9 MATH · SETS · PAPER 02")[
//     #sec("A — Multiple Choice · 1 mark each")
//     #mc(1)[prompt][a][b][c][d]
//     #sec("B — Short Answer · 2 marks each")
//     #sa(10, lines: 2)[prompt]
//   ]
//   (run `typst compile` — content that overflows a page is scaled down
//    automatically so the result is always exactly one page)
//
// For the answer key, use #paper(id: "…", key: true)[…] or just reuse this
// file and put the key content in the body.
// ──────────────────────────────────────────────────────────────

#set page("a4", margin: 0pt)
#set text(font: "New Computer Modern", size: 8.5pt)
#set par(leading: 0.55em, justify: false)

#let GREY = luma(140)

// Auto-fit: measure the body at the target frame size, then rescale so it
// never exceeds the frame. factor >= 1 leaves the body untouched.
#let _fit-frame(body, frame-w, frame-h) = layout(size => {
  let m = measure(body, width: frame-w, height: auto)
  let factor = calc.min(frame-w / m.width, frame-h / m.height, 1.0)
  scale(x: 100% * factor, y: 100% * factor, body)
})

// A one-page paper: paper id line + body, forced onto a single A4 page.
#let paper(id: "", key: false, body) = {
  let inner = pad(x: 8mm, y: 7mm)[
    #text(size: 7.2pt)[#id]
    #box(width: 100%, height: 0.5pt, stroke: 0.5pt + black)
    #v(2.5pt)
    #body
  ]
  page("a4", margin: 0pt)[
    #_fit-frame(inner, 210mm - 14mm, 297mm - 12mm)
  ]
}

// Section heading within the body.
#let sec(name) = text(size: 8.8pt, weight: "bold")[#name] + v(2pt)

// Multiple-choice item: bold number + prompt, options on one wrapped line.
#let mc(n, prompt, oa, ob, oc, od) = block(below: 2pt, above: 0pt, width: 100%)[
  #text(weight: "bold")[#n.] #prompt \
  #v(0.5pt)
  #text(size: 10.5pt)[(a) #oa  (b) #ob  (c) #oc  (d) #od]
]

// Short-answer / problem item with answer lines of a given count.
#let sa(n, prompt, lines: 1) = block(below: 2pt, above: 0pt, width: 100%)[
  #text(weight: "bold")[#n.] #prompt
  #v(1pt)
  #for _ in range(lines) { box( height: 7pt, stroke: 0.4pt + GREY); linebreak() }
]

// Two-column paired grid for questions. Pass items in pairs; they are placed
// side by side so both halves of the page stay filled.
#let pairgrid(..items) = grid(columns: 2, column-gutter: 10pt, row-gutter: 2pt, ..items)