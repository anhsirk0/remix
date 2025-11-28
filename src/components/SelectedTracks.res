module Item = {
  @react.component
  let make = (~track: Shape.Track.t, ~index) => {
    let {update} = Store.Lollypop.use()
    let onClick = _ => update(SelectedTracks(RemoveOne(track)))

    <div className="flex flex-row rounded-box bg-base-100 mb-4 animate-slide-up">
      <div
        role="button"
        onClick
        className="p-4 center min-w-[6rem] rounded-l-box cursor-pointer bg-error text-error-content">
        <p className="font-bold text-5xl"> {index->Int.toString->React.string} </p>
      </div>
      <TrackItem.Content track />
      <div className="center shrink-0 min-w-[4rem]" />
    </div>
  }
}

@react.component
let make = (~query) => {
  let {selectedTracks} = Store.Lollypop.use()

  let filteredTracks = React.useMemo2(() => {
    selectedTracks->Array.filter(t => {
      t.name->Util.Str.contains(query) ||
      t.artist.name->Util.Str.contains(query) ||
      t.album.name->Util.Str.contains(query)
    })
  }, (query, selectedTracks))

  <div className="flex flex-col gap-4 min-w-[22rem] w-4/11 h-full border-r border-main">
    {selectedTracks->Util.Arr.isEmpty
      ? <div
          className="flex flex-col gap-2 p-4 rounded-box bg-base-100 m-4 h-full center animate-fade">
          <Empty
            icon=Icon.musicNote
            title="Selected tracks"
            subtitle="Click on the number on track card to select a track"
          />
        </div>
      : <Virtuoso
          id="selected-tracks"
          style={{
            display: "flex",
            flexDirection: "column",
            width: "100%",
          }}
          data=filteredTracks
          itemContent={(idx, track) =>
            <Item key={track.id->Float.toString} track index={idx + 1} />}
        />}
  </div>
}
