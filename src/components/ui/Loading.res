type sizeT = [#small | #medium | #large]

@react.component
let make = (~classes="", ~size=#small) => {
  let sizeCls = switch size {
  | #small => ""
  | #medium => "w-20 2xl:w-24"
  | #large => "w-28 2xl:w-32"
  }
  let className = `loading loading-infinity 2xl:loading-lg ${classes} ${sizeCls}`
  <div className />
}
