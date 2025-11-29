// type q = Track(string) | Album(string) | Artist(string) | Any

@react.component
let make = (~tracks: array<Shape.Track.t>, ~title) => {
  Hook.useDocTitle(title)
  let {selectedTracks} = Store.Lollypop.use()
  let (query, setQuery) = React.useState(_ => "")

  let filteredTracks = React.useMemo2(() => {
    tracks->Array.filter(t => {
      t.name->Util.Str.contains(query) ||
      t.artist.name->Util.Str.contains(query) ||
      t.album.name->Util.Str.contains(query)
    })
  }, (query, tracks))

  <div className="flex flex-row size-full">
    <FilterPanel filteredTracks query setQuery />
    <SelectedTracks query />
    <Virtuoso
      id="tracks"
      style={{
        display: "flex",
        flexDirection: "column",
        width: "calc(4/11 * 100%)",
      }}
      data=filteredTracks
      itemContent={(idx, track) =>
        <TrackItem
          key={track.id->Float.toString}
          track
          index={idx + 1}
          isSelected={selectedTracks->Array.some(Shape.Track.eq(track, _))}
        />}
    />
  </div>
}
