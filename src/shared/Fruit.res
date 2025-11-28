type t<'a> = ReactQuery.queryResult<'a>

type useFruitOptions<'a> = {
  fn: unit => promise<Axios.apiResult>,
  key: array<string>,
  decode: Js.Json.t => 'a,
  enabled?: bool,
}

let useFruit = (opts: useFruitOptions<'a>) =>
  ReactQuery.useQuery({
    fn: opts.fn,
    key: opts.key,
    select: data => {
      switch data {
      | Ok(json) => json->opts.decode
      | Error(e) => Error(e)
      }
    },
    enabled: ?opts.enabled,
  })

@react.component
let make = (~fruit: t<'a>, ~ok, ~err=?, ~loader=?) => {
  switch fruit {
  | {isLoading: true} => loader->Option.getOr(React.null)
  | {data: Some(res)} =>
    switch res {
    | Ok(data) => ok(data)
    | Error(data) =>
      switch err {
      | Some(fn) => fn(data)
      | None => React.null
      }
    }
  | _ => React.null
  }
}

let renderErr = _ => <ReqError />

let onSome = (fruit: t<'a>, fn) => {
  if !fruit.isLoading {
    switch fruit.data {
    | Some(data) => fn(data)
    | None => ()
    }
  }
}

let onOk = (fruit: t<'a>, fn) =>
  fruit->onSome(data =>
    switch data {
    | Ok(ok) => fn(ok)
    | Error(_) => ()
    }
  )

let unwrap = fruitData =>
  fruitData->Option.flatMap(r =>
    switch r {
    | Ok(cat) => Some(cat)
    | Error(_) => None
    }
  )

let unwrapData = (fruit: t<'a>) =>
  fruit.data->Option.flatMap(r =>
    switch r {
    | Ok(cat) => Some(cat)
    | Error(_) => None
    }
  )
