@react.component
let make = (~title=?, ~msg=?, ~classes="") => {
  <div className={`center w-full flex-col ${classes}`}>
    <Icon.warning className="size-24 text-error" />
    <p className="text-center r-text-lg font-bold">
      {title->Option.getOr("Something went wrong!")->React.string}
    </p>
    <p className="text-center r-text-sm text-80">
      {msg->Option.getOr("Please try refreshing the page")->React.string}
    </p>
  </div>
}
