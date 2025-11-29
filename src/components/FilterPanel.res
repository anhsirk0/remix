@react.component
let make = (~query, ~setQuery, ~filteredTracks) => {
  let {update, selectedTracks, tracks} = Store.Lollypop.use()

  let clearText = _ => {
    setQuery(_ => "")
    "#search-input"->Util.Dom.querySelectAndThen(Util.Dom.focus)
  }

  let toggleAll = all =>
    update(SelectedTracks(all ? RemoveMany(filteredTracks) : AddMany(filteredTracks)))

  let selectByIndex = evt => {
    evt->ReactEvent.Form.preventDefault
    let target = evt->ReactEvent.Form.target
    let start = target["start"]["value"]->Int.fromString->Option.getOr(0) - 1
    let end = target["end"]["value"]->Int.fromString->Option.getOr(0)

    update(SelectedTracks(AddMany(filteredTracks->Array.slice(~start, ~end))))
  }

  let deselectByIndex = evt => {
    evt->ReactEvent.Form.preventDefault
    let target = evt->ReactEvent.Form.target
    let start = target["start"]["value"]->Int.fromString->Option.getOr(0) - 1
    let end = target["end"]["value"]->Int.fromString->Option.getOr(0)

    update(SelectedTracks(RemoveMany(filteredTracks->Array.slice(~start, ~end))))
  }

  <div
    className="flex flex-col gap-2 xl:gap-4 min-w-[20rem] w-3/11 h-full border-r border-main p-4 grow">
    <label
      className="input input-md xl:input-lg input-bordered flex items-center gap-2 outline-none rounded-box w-full shrink-0">
      <Icon.magnifyingGlass className="size-4 shrink-0" />
      <InputBase
        id="search-input"
        value=query
        onChange={evt => setQuery(_ => evt->Util.Dom.targetValue)}
        className="grow outline-none focus:outline-none"
        placeholder="Search Tracks"
        autoFocus=true
      />
      {query->String.length > 0
        ? <button
            onClick=clearText
            type_="button"
            className="btn btn-sm btn-ghost btn-circle text-base-content/80 -mr-2">
            <Icon.x />
          </button>
        : React.null}
    </label>
    <div className="stats bg-base-100">
      <div className="stat p-2 xl:p-4">
        <div className="stat-figure text-secondary">
          <Icon.musicNote className="size-6 xl:size-8" />
        </div>
        <div className="stat-title"> {"Selected tracks"->React.string} </div>
        <div className="stat-value">
          {selectedTracks->Array.length->Int.toString->React.string}
        </div>
      </div>
      <div className="stat p-2 xl:p-4">
        <div className="stat-figure text-secondary">
          <Icon.musicNotes className="size-6 xl:size-8" />
        </div>
        <div className="stat-title"> {"Total tracks"->React.string} </div>
        <div className="stat-value"> {tracks->Array.length->Int.toString->React.string} </div>
      </div>
    </div>
    <div className="flex flex-col gap-2 p-4 bg-base-100 rounded-box">
      <label className="text-sm"> {"Select/Deselect filtered"->React.string} </label>
      <div className="join">
        <button onClick={_ => toggleAll(false)} className="btn r-btn btn-neutral grow join-item">
          {"Select all"->React.string}
        </button>
        <button onClick={_ => toggleAll(true)} className="btn r-btn btn-neutral grow join-item">
          {"Deselect all"->React.string}
        </button>
      </div>
      <label className="text-sm mt-2"> {"Select by index"->React.string} </label>
      <form className="join" onSubmit=selectByIndex>
        <InputBase
          name="start"
          type_="number"
          className="input xl:input-lg join-item"
          placeholder="From"
          required=true
          autoComplete="off"
        />
        <InputBase
          name="end"
          type_="number"
          className="input xl:input-lg join-item"
          placeholder="To"
          required=true
          autoComplete="off"
        />
        <button className="btn r-btn btn-neutral join-item min-w-32">
          {"Select"->React.string}
        </button>
      </form>
      <label className="text-sm mt-2"> {"Deselect by index (from selected)"->React.string} </label>
      <form className="join" onSubmit=deselectByIndex>
        <InputBase
          name="start"
          type_="number"
          className="input xl:input-lg join-item"
          placeholder="From"
          required=true
          autoComplete="off"
        />
        <InputBase
          name="end"
          type_="number"
          className="input xl:input-lg join-item"
          placeholder="To"
          required=true
          autoComplete="off"
        />
        <button className="btn r-btn btn-neutral join-item min-w-32">
          {"Deselect"->React.string}
        </button>
      </form>
    </div>
    <CreatePlaylist />
  </div>
}
