open Axios

%%private(let config = makeConfig())

module Tracks = {
  %%private(let inst = make(Env.apiUrl, "tracks"))
  let all = () => inst->get("all", config)
}

module Playlists = {
  %%private(let inst = make(Env.apiUrl, "playlists"))
  let all = () => inst->get("all", config)
  let create = data => inst->post("create", data, config)
  let getUris = id => inst->get(`uris?id=${id}`, config)
}
