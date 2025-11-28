let client = ReactQuery.Provider.createClient()

@react.component
let make = () => {
  let {update, playlist} = Store.Lollypop.use()

  let fruit = Fruit.useFruit({
    fn: Api.Tracks.all,
    key: ["Tracks.all"],
    decode: Shape.Track.decodeMany,
  })

  React.useEffect1(() => {
    switch fruit.data->Fruit.unwrap {
    | None => ignore()
    | Some(tracks) => update(Tracks(tracks))
    }
    None
  }, [fruit.data])

  <div className="size-full flex flex-row bg-base-300">
    <Sidebar />
    {switch playlist {
    | All => <AllTracksView />
    | UserPlaylist(playlist) => <PlaylistView playlist />
    }}
  </div>
}
