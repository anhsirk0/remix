let useDocTitle = (title: string) => {
  React.useEffect0(() => {
    switch Webapi.Dom.document->Webapi.Dom.Document.asHtmlDocument {
    | Some(doc) => doc->Webapi.Dom.HtmlDocument.setTitle(`${title} • Remix`)
    | None => ()
    }
    None
  })
}

let useToggle = (~init: bool=false) => {
  let (isOpen, setIsOpen) = React.useState(_ => init)
  let toggleOpen = () => setIsOpen(val => !val)
  (isOpen, toggleOpen, setIsOpen)
}

type useApiOptions<'a> = {
  fn: 'a => promise<Axios.apiResult>,
  onSuccess?: Js.Json.t => unit,
  onError?: Axios.queryError => unit,
  key?: array<string>,
}

let useApi = (opts: useApiOptions<'a>) =>
  ReactQuery.useMutation({
    fn: opts.fn,
    key: ?opts.key,
    onSettled: data => {
      switch data {
      | Ok(json) =>
        switch opts.onSuccess {
        | Some(fn) => fn(json)
        | None => ()
        }
      | Error(obj) =>
        switch opts.onError {
        | Some(fn) => fn(obj)
        | None => ()
        }
      }
    },
  })
