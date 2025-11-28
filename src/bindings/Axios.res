type instance
type config
type axiosResp = {
  data: Js.Json.t,
  status: int,
}

type queryError = AxiosError(axiosResp) | DecodeError(string)
type apiResult = result<Js.Json.t, queryError>

%%raw(`import axios from "axios"`)

let make: (string, string) => instance = %raw(`function(apiUrl, base) {
  let instance = axios.create({
    baseURL: apiUrl + "/" + base,
    timeout: 60000
  })
  instance.interceptors.response.use(r => r, e => e.response);
  return instance
}`)

@send external get_: (instance, string, config) => promise<axiosResp> = "get"
@send external post_: (instance, string, 'data, config) => promise<axiosResp> = "post"
@send external put_: (instance, string, 'data, config) => promise<axiosResp> = "put"
@send external patch_: (instance, string, 'data, config) => promise<axiosResp> = "patch"

let toResult: axiosResp => apiResult = r =>
  r.status >= 200 && r.status < 210
    ? Ok(r.data)
    : Error(AxiosError({data: r.data, status: r.status}))

let get = async (instance, url, config) => {
  let resp = await instance->get_(url, config)
  resp->toResult
}

let post = async (instance, url, data, config) => {
  let resp = await instance->post_(url, data, config)
  resp->toResult
}

let put = async (instance, url, data, config) => {
  let resp = await instance->put_(url, data, config)
  resp->toResult
}

let patch = async (instance, url, data, config) => {
  let resp = await instance->patch_(url, data, config)
  resp->toResult
}

module Headers = {
  type t

  external fromObj: Js.t<{..}> => t = "%identity"
  external fromDict: Js.Dict.t<string> => t = "%identity"
}

@obj
external makeConfig: (~headers: Headers.t=?, ~params: Js.t<'params>=?) => config = ""

let tokenHeaders = token => Headers.fromObj({"Authorization": `Bearer ${token}`})
let tokenConfig = token => makeConfig(~headers=token->tokenHeaders)
