open Express
open Sqlite
open Lollypop

@module("cors") external corsMiddleware: unit => Express.middleware = "default"

let dbPath = Nodejs.Os.homedir() ++ Tracks.dbPath
let playlistDbPath = Nodejs.Os.homedir() ++ Playlists.dbPath
let app = express()

app->use(jsonMiddleware())
app->use(corsMiddleware())

// TODO: add error handling in sqlite queries

// TODO: maybe paginate tracks
app->get("/tracks/all", (_req, res) => {
  let tracks = Database.make(dbPath)->Query.make(Tracks.queryAll)->Query.all
  let _ = res->status(200)->json({"ok": true, "tracks": tracks})
})

app->get("/playlists/all", (_req, res) => {
  let playlists = Database.make(playlistDbPath)->Query.make(Playlists.queryAll)->Query.all
  let _ = res->status(200)->json({"ok": true, "playlists": playlists})
})

app->post("/playlists/create", (req, res) => {
  let body = req->body
  // TODO: validate these
  let id = body["id"]->Js.Nullable.toOption
  let name = body["name"]->Js.Nullable.toOption->Option.getOr("Playlist")
  let uris = body["uris"]->Js.Nullable.toOption->Option.getOr([])
  let db = Database.make(playlistDbPath)

  let playlistId = switch id {
  | Some(id) => id
  | None => (db->Query.make(Playlists.create)->Query.runInsert([name])).lastInsertRowid
  }
  let query = db->Query.make(Playlists.insertUri(playlistId->Int.toString))
  uris->Array.forEach(uri => query->Query.runInsert([uri])->ignore)
  let _ = res->status(200)->json({"ok": true})
})

// app->useWithError((err, _req, res, _next) => {
//   Js.Console.error(err)
//   let _ = res->status(500)->endWithData("An error occured")
// })

let port = 8081
let _ = app->listenWithCallback(port, _ => {
  Js.Console.log(`Listening on http://localhost:${port->Int.toString}`)
})
