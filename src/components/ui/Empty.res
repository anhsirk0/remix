@react.component
let make = (~icon: Icon.t=Icon.empty, ~title, ~subtitle=?, ~classes="") => {
  let className = `center flex-col ${classes}`

  <div className>
    {React.createElement(icon, {className: "size-28 2xl:size-32", width: "bold"})}
    <p className="r-text-xl text-center font-bold"> {title->React.string} </p>
    {subtitle->Util.renderSome(sub =>
      <p className="r-text text-center text-80 mt-2"> {sub->React.string} </p>
    )}
  </div>
}
