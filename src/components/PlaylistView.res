@react.component
let make = (~playlist: Shape.Playlist.t) => {
  Hook.useDocTitle(playlist.name)

  <div className="center size-full">
    <Empty icon=Icon.playlist title=playlist.name subtitle="TODO: Add single playlist view" />
  </div>
}
