@react.component
let make = () => {
  let {selectedTracks, playlists, update} = Store.Lollypop.use()
  let (name, setName) = React.useState(_ => "")

  let clearText = _ => {
    setName(_ => "")
    "#name-input"->Util.Dom.querySelectAndThen(Util.Dom.focus)
  }

  let {mutate} = Hook.useApi({
    fn: Api.Playlists.create,
    onSuccess: _resp => {
      Toast.success(
        `${selectedTracks->Array.length->Util.toAmountLabel("track")} added to playlist "${name}"`,
      )
      update(SelectedTracks(Set([])))
    },
  })

  let onSubmit = evt => {
    evt->ReactEvent.Form.preventDefault
    let uris = selectedTracks->Array.map(t => t.uri)
    let id = playlists->Array.find(p => p.name == name)->Option.map(p => p.id)
    mutate({"name": name, "uris": uris, "id": id})
  }

  <form onSubmit className="flex flex-col gap-4 p-4 bg-base-100 rounded-box grow">
    <div className="text-2xl font-bold hidden xl:inline"> {"Create playlist"->React.string} </div>
    <div className="grow center">
      <Icon.playlist className="size-16 xl:size-20 2xl:size-28" />
    </div>
    <label
      className="input input-md xl:input-lg input-bordered flex items-center gap-2 outline-none rounded-box w-full shrink-0">
      <InputBase
        id="name-input"
        value=name
        onChange={evt => setName(_ => evt->Util.Dom.targetValue)}
        className="grow outline-none focus:outline-none"
        placeholder="Name"
        required=true
        autoComplete="off"
      />
      {name->String.length > 0
        ? <button
            onClick=clearText
            type_="button"
            className="btn btn-sm btn-ghost btn-circle text-base-content/80 -mr-2">
            <Icon.x />
          </button>
        : React.null}
    </label>
    <button disabled={selectedTracks->Util.Arr.isEmpty} className="btn xl:btn-lg btn-primary">
      {"Create playlist"->React.string}
    </button>
  </form>
}
