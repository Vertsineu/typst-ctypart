#import "@preview/outrageous:0.4.0"

#let font-size-map = (
  "初号": 42pt,
  "小初": 36pt,
  "一号": 26pt,
  "小一": 24pt,
  "二号": 22pt,
  "小二": 18pt,
  "三号": 16pt,
  "小三": 15pt,
  "四号": 14pt,
  "小四": 12pt,
  "五号": 10.5pt,
  "小五": 9pt,
  "六号": 7.5pt,
  "小六": 6.5pt,
  "七号": 5.5pt,
  "八号": 5pt
)

/// 初始化页面整体样式
#let init(
    // 页面
    paper: "a4",
    margin: auto,
    numbering: "1",
    page-args: none,
    // 字体
    english-font: "New Computer Modern", 
    english-emph-font: "New Computer Modern", 
    english-strong-font: "New Computer Modern",
    chinese-font: "FandolSong",
    chinese-emph-font: "FandolKai",
    chinese-strong-font: "FandolSong",
    text-size: font-size-map.at("五号"),
    text-args: none,
    // 段落
    par-indent: 2em, 
    par-leading-rate: 1, // 行间距倍数
    par-spacing-rate: 1, // 块间距倍数
    par-leading: auto,
    par-spacing: auto,
    par-justify: true, 
    par-args: none,
    // 章节
    heading-font: auto,
    heading-size: (font-size-map.at("小三"), font-size-map.at("小四"), font-size-map.at("五号")), // 小三 小四 五号
    heading-align: (center, auto), // 默认第一级标题居中
    heading-spacing-top: 1.2em,
    heading-spacing-bottom: 1.2em,
    // 编号
    heading-numbering: "1.1  ",
    figure-numbering: "1",
    equation-numbering: none,

    // 标题 作者 日期
    title: none,
    title-text-args: (size: font-size-map.at("小二"),), // 小二
    author: none,
    author-text-args: (size: font-size-map.at("小四"),), // 小四
    date: none,
    date-text-args: (size: font-size-map.at("小四"),), // 小四
    make-title: false,
    title-page: false,
    title-spacing-bottom: 1.5em,

    // 目录
    make-outline: false,
    outline-args: (indent: auto,),
    outline-spacing: 1.35em,

    // 摘要
    abstract: none,
    abstract-text-args: (size: font-size-map.at("小五"),),

    // 关键词
    keywords: none,
    keywords-text-args: (size: font-size-map.at("小五"),),

    // 索引
    bookmarked: false,
  
    body
  ) = {
  
  // return arr[i]
  // if illegal or empty, return none
  // if out of bound, return the last element
  let array-at(arr, i) = {
    if type(arr) != array or arr.len() == 0 or i < 0 { none }
    else { arr.at(calc.min(i, arr.len()) - 1) }
  }

  par-leading = if par-leading == auto {par-leading-rate * 15.6pt - 0.7em} else {par-leading} // 行间距
  par-spacing = if par-spacing == auto {par-spacing-rate * 15.6pt - 0.7em} else {par-spacing} // 段间距
  // par-spacing = 0pt

  // 页面 
  set page(paper: paper, margin: margin, numbering: numbering, ..page-args)

  // 1 字体
  set text(font: (english-font, chinese-font), size: text-size, lang: "zh", region: "cn", ..{if text-args != none {text-args}})
  show emph: set text(font: (english-emph-font, chinese-emph-font))
  show strong: set text(font: (english-strong-font, chinese-strong-font))
  show enum: set text(font: (chinese-font, english-font))

  // 2 段落
  // 2.1 段落设置
  set par(
    spacing: par-spacing,
    justify: par-justify, 
    leading: par-leading,
    first-line-indent: par-indent,
    ..{if par-args != none {par-args}}
  )
  // 2.2 忽略章节标题后的首行缩进以及设置段前段后间距
  let empty-par = par[#box()]
  let fake-par = context empty-par + v(-measure(empty-par + empty-par).height)

  // 2.3 添加假段落设置段落换行
  show list: it => it + fake-par
  show enum: it => it + fake-par
  show figure: it => it + fake-par
  show math.equation.where(block: true): it => it + fake-par

  if heading-font == auto {
    heading-font = ((english-strong-font, chinese-strong-font),)
  }

  let heading-spacing-top-v = v(weak: true, heading-spacing-top)
  let heading-spacing-bottom-v = v(weak: true, heading-spacing-bottom)
  
  // 3 章节
  show heading: it => {
    // 3.1 章节字体与字号
    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
    )
    heading-spacing-top-v
    it
    fake-par
    heading-spacing-bottom-v
  }

  show heading: it => {
    // 3.2 章节对齐
    let al = array-at(heading-align, it.level)
    if (al != none and al != auto) {
      set align(al)
      it
    } else {
      it
    }
  }

  // 3.3 paragraph 样式设置
  let paragraph-style = it => {
    box(it.body)
  }
  show heading.where(level: 4): paragraph-style
  show heading.where(level: 4): set heading(outlined: false)
  show heading.where(level: 5): paragraph-style
  show heading.where(level: 5): set heading(outlined: false)

  // 4 编号
  // 4.1 设置 heading 的编号
  set heading(numbering: heading-numbering, bookmarked: bookmarked)

  // 4.2 设置 figure 和 equation 的编号
  set figure(numbering: figure-numbering)
  set math.equation(numbering: equation-numbering)

  // 5 表格表头置顶
  show figure.where(
    kind: table
  ): set figure.caption(position: top)

  let title-display = align(
    center, 
    {
      if title != none {
        block(
          spacing: 2.4em * (if title-page {1.5} else {1}),
          align(
            center, 
            text(..title-text-args, title)
          )
        )
      }
      if author != none {
        block(
          spacing: 1.6em * (if title-page {1.5} else {1}),
          align(
            center, 
            text(..author-text-args, author)
          )
        )
      }
      if date != none {
        block(
          align(
            center, 
            text(..date-text-args, date)
          )
        )
      }
    }
  )

  // 6 调整行内公式
  // show math.equation.where(block: false): it => context {
  //   let width = measure(block("-")).width // 一个空格的宽度
  //   h(width, weak: true) + it + h(width, weak: true)
  // }

  // create a transparent box
  let transparent-box = (it) => {
    context {
      let width = measure(it).width
      let height = measure(it).height
      box(width: width, height: height)
    }
  }

  // 制作标题
  if make-title {
    if title-page {
      // let the center of the page is the bottom of the title
      title-display = align(center + horizon, title-display)
      page(
        numbering: none,
        title-display + transparent-box(title-display)
      )
      counter(page).update(1)
    } else {
      title-display
      v(title-spacing-bottom)
    }
  }

  // 制作目录
  if make-outline {
    show outline: set par(first-line-indent: 0em)
    show outline.entry: outrageous.show-entry
    show outline.entry.where(
      level: 1
    ): it => {
      v(outline-spacing, weak: true)
      strong(it)
    }
    outline(..outline-args)
  }
  
  // 摘要
  if abstract != none {
    set text(..abstract-text-args)
    strong(align(center)[#(if chinese-font == "" or chinese-font == none {text("Abstract")} else {text("摘要")})])
    par(abstract)
  }

  // 关键词
  if keywords != none {
    set text(..keywords-text-args)
    par(strong[#(if chinese-font == "" or chinese-font == none {text("Keywords")} else {text("关键词")} ): ] + keywords)
  }

  body
  
}
