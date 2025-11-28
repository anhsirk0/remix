module Tracks = {
  let dbPath = "/.local/share/lollypop/lollypop.db"
  let queryAll = "select tracks.id, tracks.name, tracks.uri,
  artists.id as artistId, artists.name as artistName,
  albums.id as albumId, albums.name as albumName
  from tracks
  join track_artists on track_artists.track_id = tracks.id
  join artists on track_artists.artist_id = artists.id
  join albums on tracks.album_id = albums.id
  group by tracks.id
  order by albums.mtime desc"
}

module Playlists = {
  let dbPath = "/.local/share/lollypop/lollypop.db"
  let queryAll = "select id, name from playlists"
  let queryTracksUri = id => `select uri from tracks where playlist_id like '${id}'`
  let insertUri = id => `insert into tracks (playlist_id, uri) values (${id}, ?)`
  let create = "insert into playlists (name, mtime) values (?, current_timestamp)"
}
