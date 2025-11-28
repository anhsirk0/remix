let toCapitalize = str =>
  str->String.charAt(0)->String.toUpperCase ++ str->String.sliceToEnd(~start=1)

let cn = strs => strs->Array.filter(s => s->String.length > 0)->Array.join(" ")

let sep = "•"
let range = Belt.Array.range(1, _)
let isValidToken = token => token->String.length > 34

let toInitials = name =>
  name
  ->String.split(" ")
  ->Array.map(s => s->String.charAt(0))
  ->Array.map(String.toUpperCase)
  ->Array.join("")

let toAmountLabel = (count, label) => `${count->Int.toString} ${label}${count == 1 ? "" : "s"}`

let renderSome = (data, fn) =>
  switch data {
  | Some(some) => fn(some)
  | None => React.null
  }

let makeParamsString = (params, key, val) => {
  open Webapi.Url
  let prms = URLSearchParams.make(params->URLSearchParams.toString)
  prms->URLSearchParams.set(key, val)
  `?${prms->URLSearchParams.toString}`
}

module Str = {
  let isEmpty = str => str->String.length === 0
  let or = (str, str2) => str->isEmpty ? str2 : str
  let isSame = (str, str2) => str->String.toLowerCase == str2->String.toLowerCase
  let contains = (s1, s2) => s1->String.toLowerCase->String.includes(s2->String.toLowerCase)
}

module Arr = {
  let isEmpty = arr => arr->Array.length === 0
  let or = (arr, arr2) => arr->isEmpty ? arr2 : arr
  let toggle = (arr: array<'a>, item: 'a) =>
    arr->Array.some(i => i == item) ? arr->Array.filter(i => i != item) : arr->Array.concat([item])
  // let render = (arr, fn) => arr->Array.map(fn)->React.array
  // let renderOr = (arr, fn, empty) => arr->isEmpty ? empty : arr->Array.map(fn)->React.array
}

module Date = {
  let toRelative = date => {
    let fmt = if date->DateFns.isToday {
      "hh:mm aa"
    } else if date->DateFns.isYesterday {
      "hh:mm aa, 'Yesterday'"
    } else if date->DateFns.isThisWeek {
      "hh:mm aa, EEEE"
    } else {
      "hh:mm aa, dd-MM-yyyy"
    }
    date->DateFns.format(fmt)
  }

  let toStr = date => date->DateFns.format("hh:mm aa, dd-MM-yyyy")
}

module Dom = {
  @set external setValue: (Dom.element, string) => unit = "value"
  @send external focus: Dom.element => unit = "focus"
  @send external click: Dom.element => unit = "click"
  @send external blur: Dom.element => unit = "blur"
  @send external setAttribute: (Dom.element, string, string) => unit = "setAttribute"

  let querySelectAndThen = (selector, action) => {
    switch ReactDOM.querySelector(selector) {
    | Some(el) => el->action
    | None => ()
    }
  }
  let getTheme = () => {
    switch "remixTheme"->Dom.Storage.getItem(Dom.Storage.localStorage) {
    | Some(theme) => theme
    | None => "bumblebee"
    }
  }
  let setTheme = theme => {
    "html"->querySelectAndThen(setAttribute(_, "data-theme", theme))
    "remixTheme"->Dom.Storage.setItem(theme, Dom.Storage.localStorage)
  }
  let setDocTitle = title => {
    let mainTitle = "Remix"
    let docTitle = switch title {
    | Some(title) => `${title} • ${mainTitle}`
    | None => mainTitle
    }
    Document.document->Document.setTitle(docTitle)
  }

  module WDom = Webapi.Dom
  let windowScrollToTop = () =>
    window->WDom.Window.scrollToWithOptions({"behavior": "smooth", "top": 0., "left": 0.})
  let scrollToTop = WDom.Element.scrollToWithOptions(
    _,
    {"behavior": "smooth", "top": 0., "left": 0.},
  )
  let scrollIntoView = WDom.Element.scrollIntoViewWithOptions(
    _,
    {"behavior": "smooth", "block": "start"},
  )
  let targetValue = evt => ReactEvent.Form.target(evt)["value"]

  %%private(@get external matches: WDom.Window.mediaQueryList => bool = "matches")
  let isDarkMode = () => window->WDom.Window.matchMedia("(prefers-color-scheme: dark)")->matches
}
