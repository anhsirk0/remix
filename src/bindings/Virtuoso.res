@module("react-virtuoso") @react.component
external make: (
  ~style: ReactDOM.style=?,
  ~data: array<'a>,
  ~itemContent: (int, 'a) => React.element,
  ~id: string=?,
) => React.element = "Virtuoso"
