open Axios

module Api = {}

module Album = {
  type t = {id: float, name: string}
  let eq = (one, other) => one.id == other.id
}

module Artist = {
  type t = {id: float, name: string}
  let eq = (one, other) => one.id == other.id
}

module Track = {
  // type item = {id: float, name: string, uri: string}
  type t = {id: float, name: string, uri: string, album: Album.t, artist: Artist.t}
  let eq = (one, other) => one.id == other.id
  let ne = (one, other) => one.id != other.id

  // let toItem = track => {id: track.id, name: track.name, uri: track.uri}

  let decode: Js.Json.t => result<t, queryError> = json => {
    try {
      let obj = json->Decode.decodeObject->Option.getExn
      let id = obj->Decode.num("id")->Option.getExn
      let name = obj->Decode.str("name")->Option.getExn
      let uri = obj->Decode.str("uri")->Option.getExn

      let artistId = obj->Decode.num("artistId")->Option.getExn
      let artistName = obj->Decode.str("artistName")->Option.getExn
      let albumId = obj->Decode.num("albumId")->Option.getExn
      let albumName = obj->Decode.str("albumName")->Option.getExn

      Ok({
        id,
        name,
        uri,
        artist: {id: artistId, name: artistName},
        album: {id: albumId, name: albumName},
      })
    } catch {
    | _ => Error(DecodeError("Shape.Track: failed to decode json"))
    }
  }

  let decodeMany: Js.Json.t => result<array<t>, queryError> = json => {
    try {
      let obj = json->Decode.decodeObject->Option.getExn
      let tracks = obj->Decode.arr("tracks")->Decode.manyOption(decode)
      switch tracks {
      | Some(tracks) => Ok(tracks)
      | None => Error(DecodeError("Shape.Track: Decode many error"))
      }
    } catch {
    | _ => Error(DecodeError("Shape.Track: Decode many error"))
    }
  }
}

module Playlist = {
  type t = {id: float, name: string}
  let eq = (one, other) => one.id == other.id
  type kind = All | UserPlaylist(t)

  let decode: Js.Json.t => result<t, queryError> = json => {
    try {
      let obj = json->Decode.decodeObject->Option.getExn
      let id = obj->Decode.num("id")->Option.getExn
      let name = obj->Decode.str("name")->Option.getExn

      Ok({id, name})
    } catch {
    | _ => Error(DecodeError("Shape.Playlist: failed to decode json"))
    }
  }

  let decodeMany: Js.Json.t => result<array<t>, queryError> = json => {
    try {
      let obj = json->Decode.decodeObject->Option.getExn
      let playlists = obj->Decode.arr("playlists")->Decode.manyOption(decode)
      switch playlists {
      | Some(playlists) => Ok(playlists)
      | None => Error(DecodeError("Shape.Playlist: Decode many error"))
      }
    } catch {
    | _ => Error(DecodeError("Shape.Playlist: Decode many error"))
    }
  }
}
