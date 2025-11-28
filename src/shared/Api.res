open Axios

%%private(let inst = make(Env.apiUrl, ""))

let ping = data => inst->post("ping", data, makeConfig())

module Tracks = {
  %%private(let inst = make(Env.apiUrl, "tracks"))
  let all = () => inst->get("all", makeConfig())
}

module Playlists = {
  %%private(let inst = make(Env.apiUrl, "playlists"))
  let all = () => inst->get("all", makeConfig())
  let create = data => inst->post("create", data, makeConfig())
}
