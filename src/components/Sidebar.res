@react.component
let make = () => {
  let {tracks, playlists} = Store.Lollypop.use()
  let (isOpen, toggleOpen, _) = Hook.useToggle() // theme

  <React.Fragment>
    <div className="z-10 w-fit h-full flex flex-row">
      <div
        className="w-[14rem] 2xl:w-[16rem] p-2 2xl:px-4 flex flex-col gap-1 2xl:gap-2 h-full bg-neutral text-neutral-content">
        <div className="flex flex-row gap-1 items-center justify-between h-9 2xl:h-12">
          <p className="r-text-xl font-bold font-serif"> {"Remix"->React.string} </p>
          <button
            onClick={_ => toggleOpen()}
            ariaLabel="settings-btn"
            className="btn btn-circle btn-ghost r-btn">
            <Icon.palette className="r-icon" />
          </button>
        </div>
        <ChoosePlaylist />
        <div className="grow" />
        <div className="flex flex-row items-center space-between">
          <p className="text-neutral-content/80 r-text">
            {tracks->Array.length->Util.toAmountLabel("Track")->React.string}
          </p>
          <div className="grow" />
          <p className="text-neutral-content/80 r-text">
            {playlists->Array.length->Util.toAmountLabel("Playlist")->React.string}
          </p>
        </div>
      </div>
    </div>
    <ChooseTheme isOpen onClose=toggleOpen />
  </React.Fragment>
}
