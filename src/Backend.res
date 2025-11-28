open Express

@module("cors") external corsMiddleware: unit => Express.middleware = "default"

let dbPath = Nodejs.Os.homedir() ++ Lollypop.Tracks.dbPath
let playlistDbPath = Nodejs.Os.homedir() ++ "/.local/share/lollypop/playlists.db"
let app = express()

app->use(jsonMiddleware())
app->use(corsMiddleware())

// TODO: add error handling in sqlite queries

// TODO: maybe paginate tracks
app->get("/tracks/all", (_req, res) => {
  let db = Sqlite.Database.make(dbPath)
  let query = db->Sqlite.Query.make(Lollypop.Tracks.queryAll)
  let tracks = query->Sqlite.Query.all
  let _ = res->status(200)->json({"ok": true, "tracks": tracks})
})

app->get("/playlists/all", (_req, res) => {
  let db = Sqlite.Database.make(playlistDbPath)
  let query = db->Sqlite.Query.make(Lollypop.Playlists.queryAll)
  let playlists = query->Sqlite.Query.all
  let _ = res->status(200)->json({"ok": true, "playlists": playlists})
})

app->post("/playlists/create", (req, res) => {
  let body = req->body
  // TODO: validate these
  let id = body["id"]->Js.Nullable.toOption
  let name = body["name"]->Js.Nullable.toOption->Option.getOr("Playlist")
  let uris = body["uris"]->Js.Nullable.toOption->Option.getOr([])
  let db = Sqlite.Database.make(playlistDbPath)

  let playlistId = switch id {
  | Some(id) => id
  | None => {
      let query = db->Sqlite.Query.make(Lollypop.Playlists.create)
      let {lastInsertRowid} = query->Sqlite.Query.runInsert([name])
      lastInsertRowid
    }
  }
  let query = db->Sqlite.Query.make(Lollypop.Playlists.insertUri(playlistId->Int.toString))
  uris->Array.forEach(uri => query->Sqlite.Query.runInsert([uri])->ignore)

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
