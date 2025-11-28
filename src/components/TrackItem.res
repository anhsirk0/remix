module Content = {
  @react.component
  let make = (~track: Shape.Track.t) => {
    <div className="flex flex-col p-4 gap-2 min-w-0 grow">
      <div className="flex flex-row gap-2 items-center w-full">
        <Icon.musicNote className="size-5" />
        <p className="r-title truncate"> {track.name->React.string} </p>
      </div>
      <div className="flex flex-row gap-2 text-80 items-center w-full">
        <Icon.userCircle className="size-5" />
        <p className="r-text-sm truncate"> {track.artist.name->React.string} </p>
        <Icon.vinylRecord className="size-5 ml-2" />
        <p className="r-text-sm truncate"> {track.album.name->React.string} </p>
      </div>
    </div>
  }
}

@react.component
let make = (~track, ~index, ~isSelected) => {
  let {update} = Store.Lollypop.use()

  let activeClass = isSelected
    ? "bg-primary text-primary-content"
    : "border-r border-base-content/10 text-40"

  let onClick = _ => update(SelectedTracks(ToggleOne(track)))

  <div className="flex flex-row rounded-box bg-base-100 mb-4">
    <div
      role="button"
      onClick
      className={`p-4 center min-w-[6rem] rounded-l-box cursor-pointer ${activeClass}`}>
      <p className="font-bold text-5xl"> {index->Int.toString->React.string} </p>
    </div>
    <Content track />
  </div>
}
