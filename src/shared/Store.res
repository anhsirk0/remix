module Lollypop = {
  type t = {
    tracks: array<Shape.Track.t>,
    playlists: array<Shape.Playlist.t>,
    playlist: Shape.Playlist.kind,
    selectedTracks: array<Shape.Track.t>,
  }
  type selectedAction =
    | Set(array<Shape.Track.t>)
    | ToggleOne(Shape.Track.t)
    | AddOne(Shape.Track.t)
    | RemoveOne(Shape.Track.t)
    | AddMany(array<Shape.Track.t>)
    | RemoveMany(array<Shape.Track.t>)

  type updateAction =
    | Tracks(array<Shape.Track.t>)
    | Playlists(array<Shape.Playlist.t>)
    | SetPlaylist(Shape.Playlist.kind)
    | SelectedTracks(selectedAction)

  module StoreData = {
    type state = {...t, update: updateAction => unit}
  }

  let hasOne = (arr, item) => arr->Array.some(Shape.Track.eq(item, _))
  let addOne = (arr, item) => arr->hasOne(item) ? arr : arr->Array.concat([item])
  let removeOne = (arr, item) =>
    arr->hasOne(item) ? arr->Array.filter(Shape.Track.ne(item, _)) : arr

  module Store = Zustand.MakeStore(StoreData)
  let store = Store.create(set => {
    tracks: [],
    selectedTracks: [],
    playlists: [],
    playlist: All,
    update: action =>
      set(.state =>
        switch action {
        | Tracks(tracks) => {...state, tracks}
        | Playlists(playlists) => {...state, playlists}
        | SetPlaylist(playlist) => {...state, playlist}
        | SelectedTracks(sa) => {
            ...state,
            selectedTracks: switch sa {
            | Set(selectedTracks) => selectedTracks
            | ToggleOne(item) => state.selectedTracks->Util.Arr.toggle(item)
            | AddOne(item) => state.selectedTracks->addOne(item)
            | RemoveOne(item) => state.selectedTracks->removeOne(item)
            | AddMany(items) => items->Array.reduce(state.selectedTracks, addOne)
            | RemoveMany(items) => items->Array.reduce(state.selectedTracks, removeOne)
            },
          }
        }
      ),
  })

  let use = () => store->Store.use(state => state)
}
