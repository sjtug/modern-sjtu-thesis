#import "../utils/header.typ": appendix-page-header
#import "../utils/heading.typ": appendix-first-heading, other-heading
#import "@preview/i-figured:0.2.4"
#import "../utils/equationx.typ": equationx-ref, equationx

#let appendix(
  doctype: "master",
  twoside: false,
  ziti: (:),
  body,
) = {
  show: appendix-page-header.with(doctype: doctype, twoside: twoside, ziti: ziti)
  show: appendix-first-heading.with(doctype: doctype, twoside: twoside, ziti: ziti)
  show: other-heading.with(appendix: true, ziti: ziti)

  show heading: i-figured.reset-counters.with(extra-kinds: ("image", "image-en", "table", "table-en", "algorithm"))
  show figure: i-figured.show-figure.with(extra-prefixes: (image: "img:", algorithm: "algo:"), numbering: if doctype
    == "bachelor" { "A-1" } else { "A.1" })
  set figure(outlined: false)

  show: equationx.with(numbering: if doctype == "bachelor" { "(A-1)" } else { "(A.1)" })
  show ref: it => {
    if it.element == none {
      return it
    }
    let eq = equationx-ref(it, default-numbering: if doctype == "bachelor" { "(A-1)" } else { "(A.1)" })
    if eq != none {
      return eq
    }
    it
  }

  show figure.where(kind: "subimage"): it => {
    if it.kind == "subimage" {
      let q = query(figure.where(outlined: true).before(it.location())).last()
      [
        #figure(
          it.body,
          caption: it.counter.display("(a)") + " " + it.caption.body,
          kind: it.kind + "_",
          supplement: it.supplement,
          outlined: it.outlined,
          numbering: "(a)",
          gap: 1em,
        )#label(str(q.label) + ":" + str(it.label))
      ]
    }
  }

  show figure.where(kind: "subimage-en"): it => {
    if it.kind == "subimage-en" {
      let q = query(figure.where(outlined: true).before(it.location())).last()
      [
        #figure(
          it.body,
          caption: if it.caption != none { it.counter.display("(a)") + " " + it.caption.body } else { none },
          kind: it.kind + "_",
          supplement: it.supplement,
          outlined: it.outlined,
          numbering: "(a)",
          gap: 1em,
        )
      ]
    }
  }

  body
}
