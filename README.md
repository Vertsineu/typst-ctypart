# ctypart

A Typst package imitating the `\documentclass{ctexart}` in LaTeX.

Currently, it is only for self-use, and not intended for public release. It is not a complete replacement for `ctexart`, but rather a starting point for those familiar with it. If you are not satisfied with the package, you can modify it as you wish after installing.

## Installation

Though this package has not been released to Typst package repository, you can install it as a local package.

All you need to do is to clone this repository to `{data-dir}/typst/packages/local/ctypart/0.1.0`, where `{data-dir}` [depends on your system](https://github.com/typst/packages#local-packages).

For example, for Linux users, it's `~/.local/share`, so  you can install the package using the following commands:

```bash
mkdir -p ~/.local/share/typst/packages/local/ctypart/0.1.0
git clone https://github.com/Vertsineu/ctypart.git ~/.local/share/typst/packages/local/ctypart/0.1.0
```

## Usage

After installing the package as a local package, you can import it in your Typst document like this:

```typst
#import "@local/ctexart:0.1.0": *
```

The package provides the following available variables:

- `init`: a function to initialize the Typst document with the `ctexart` style according to given parameters, such as `title`, `author`, `date` and so on.
- `font-size-map`: a dictionary mapping Chinese font sizes to length values. For example, `font-size-map.at("小四")` returns `12pt`.

## Example

After importing the package, there are some examples for daily usage.

If you want to write a Chinese paper, it's recommended to initialize the Typst document using the following commands:

```typ
#show: init.with(
  make-title: true,
  title: strong("{Title}"),
  author: [姓名：{Name} #" " 班级：{Class} ...],
  date: datetime.today().display("[year]年[month]月[day]日"),
  bookmarked: true,
  // you can replace the following fonts with your own
  chinese-font: "FandolSong",
  chinese-strong-font: "FandolSong",
  chinese-emph-font: "FandolKai",
)
```

If you want to write a English paper, it's recommended to initialize the Typst document using the following commands:

```typ
#show: init.with(
  make-title: true,
  title: strong("{Title}"),
  author: [Name: {Name}#" " Class: {Class} ...],
  date: datetime.today().display("[month]-[day]-[year]"),
  bookmarked: true,
  // unset default Chinese fonts
  chinese-font: "",
  chinese-strong-font: "",
  chinese-emph-font: "",
  // you can replace the following fonts with your own
  english-font: "Libertinus Serif",
  english-strong-font: "Libertinus Serif",
  english-emph-font: "Libertinus Serif",
  par-indent: 0em,
  par-spacing-rate: 1.25,
  text-args: (lang: "en", region: "US")
)
```

## Thanks

Thanks to the following repositories for their inspiration and reference:

- [modern-nju-thesis](https://github.com/nju-lug/modern-nju-thesis)
- [typreset](https://github.com/Fr4nk1inCs/typreset)

## License

This package is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0). You can use, modify and distribute it under the terms of the license.
