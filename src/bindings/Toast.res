type t

module Options = {
  type t
  external fromObj: Js.t<{..}> => t = "%identity"
}

module Toaster = {
  @react.component @module("react-hot-toast")
  external make: (~position: string=?) => React.element = "Toaster"
}

%%private(
  @module("react-hot-toast") external toast: (string, Options.t) => unit = "toast"
  let classes = " !font-medium !text-2xl !max-w-xl !border-0"
  let makeIcon = (icon: Icon.t) => React.createElement(icon, {className: "size-6", width: "bold"})

  let make = (options, msg) => toast(msg, options)
)

let success = make(
  Options.fromObj({
    "icon": makeIcon(Icon.checkCircle),
    "className": "!alert !alert-success" ++ classes,
  }),
  _,
)

let error = make(
  Options.fromObj({
    "icon": makeIcon(Icon.warning),
    "className": "!alert !alert-error" ++ classes,
  }),
  _,
)

let warn = make(
  Options.fromObj({
    "icon": makeIcon(Icon.warningCircle),
    "className": "!alert !alert-warning" ++ classes,
  }),
  _,
)

// let success = msg => privateSuccess(make, msg)
// let error = msg => privateError(make, msg)
