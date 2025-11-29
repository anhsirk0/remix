@react.component
let make = (~playlist: Shape.Playlist.t) => {
  Hook.useDocTitle(playlist.name)

  // let fruit = Fruit.useFruit({
  //   fn: () => Api.Playlists.getUris(playlist.id->Float.toString),
  //   key: ["Playlist.getUris", playlist.id->Float.toString],
  //   decode: Shape.Track.decodeMany,
  // })

  <div className="center size-full">
    <Empty icon=Icon.playlist title=playlist.name subtitle="TODO: Add single playlist view" />
  </div>
}
