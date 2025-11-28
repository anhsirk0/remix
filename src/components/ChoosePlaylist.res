module Item = {
  @react.component
  let make = (~name, ~isSelected, ~onClick, ~isPlaylist=false, ~icon=Icon.playlist) => {
    let bg = isSelected ? "bg-neutral-content/20 text-neutral-content" : ""
    let className = `flex flex-row p-1 2xl:p-2 px-4 gap-2 ${bg} rounded-box relative isolate overflow-hidden items-center cursor-pointer hover:bg-neutral-content/25 shrink-0 transitional duration-500`
    <div tabIndex=0 role="button" className onClick>
      {React.createElement(icon, {className: "r-icon text-neutral-content/80"})}
      <span className="truncate grow r-title"> {name->React.string} </span>
    </div>
  }
}

module AllPlaylists = {
  @react.component
  let make = () => {
    let {playlist, playlists, update} = Store.Lollypop.use()

    playlists
    ->Array.map(item => {
      let onClick = _ => update(SetPlaylist(UserPlaylist(item)))

      let isSelected = switch playlist {
      | All => false
      | UserPlaylist(t) => Shape.Playlist.eq(t, item)
      }

      <Item key=item.name name=item.name onClick isSelected isPlaylist=true />
    })
    ->React.array
  }
}

@react.component
let make = () => {
  let {playlist, playlists, update} = Store.Lollypop.use()

  let fruit = Fruit.useFruit({
    fn: Api.Playlists.all,
    key: ["Playlists.all"],
    decode: Shape.Playlist.decodeMany,
  })

  React.useEffect1(() => {
    switch fruit.data->Fruit.unwrap {
    | None => ignore()
    | Some(playlists) => update(Playlists(playlists))
    }
    None
  }, [fruit.data])

  <div className="flex flex-col gap-1 2xl:gap-2 overflow-y-auto h-full">
    <Item
      name="All Tracks"
      isSelected={playlist == All}
      onClick={_ => {
        update(SetPlaylist(All))
        Util.Dom.setDocTitle(None)
      }}
      icon={Icon.musicNotes}
    />
    {playlists->Util.Arr.isEmpty
      ? <Empty
          icon=Icon.playlist
          title="No playlists"
          subtitle="Use the + button to create playlists"
          classes="h-full"
        />
      : <AllPlaylists />}
  </div>
}
