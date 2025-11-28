type client

%%raw(`import * as Query from "@tanstack/react-query"`)

module Provider = {
  @module("@tanstack/react-query") @react.component
  external make: (~children: React.element, ~client: client) => React.element =
    "QueryClientProvider"

  let createClient: unit => client = %raw(`function () {
    return new Query.QueryClient({
      defaultOptions: { queries: { refetchOnWindowFocus: false } },
    });
  }`)
}

type mutationOptions<'a> = {
  fn: 'a => promise<Axios.apiResult>,
  key?: array<string>,
  // onSuccess: Js.Json.t => unit,
  // onError: Js.Json.t => unit,
  onSettled: Axios.apiResult => unit,
}

type mutationResult<'a> = {
  isPending: bool,
  mutate: 'a => unit,
  // mutateAsync: 'a=> unit,
}

let useMutation: mutationOptions<'a> => mutationResult<'a> = %raw(`function(options) {
  return Query.useMutation({
    mutationFn: options.fn,
    mutationKey: options.key,
    onSettled: options.onSettled
  })
}`)

type queryOptions<'a> = {
  fn: unit => promise<Axios.apiResult>,
  key: array<string>,
  enabled?: bool,
  select: Axios.apiResult => 'a,
}

type queryResult<'a> = {
  isLoading: bool,
  data: option<'a>,
}

let useQuery: queryOptions<'a> => queryResult<'a> = %raw(`function(options) {
  return Query.useQuery({
    queryFn: options.fn,
    queryKey: options.key,
    enabled: options.enabled,
    select: options.select,
  })
}`)
