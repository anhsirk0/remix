module Json = Js.Json

let decodeObject = Json.decodeObject
let obj = (obj, key) => obj->Dict.get(key)->Option.flatMap(o => decodeObject(o))
let str = (obj, key) => obj->Dict.get(key)->Option.flatMap(s => Json.decodeString(s))
let num = (obj, key) => obj->Dict.get(key)->Option.flatMap(n => Json.decodeNumber(n))
let integer = (obj, key) => obj->str(key)->Option.flatMap(s => Int.fromString(s))
let boolean = (obj, key) => obj->Dict.get(key)->Option.flatMap(n => Json.decodeBoolean(n))
let arr = (obj, key) => obj->Dict.get(key)->Option.flatMap(a => Json.decodeArray(a))

let many = (data, decoder, err) => {
  try {
    Ok(data->Option.map(it => it->Array.map(i => i->decoder->Result.getExn))->Option.getExn)
  } catch {
  | _ => Error(err)
  }
}

let manyOption = (data, decoder) =>
  data->Option.flatMap(items => Some(
    items->Array.filterMap(i => {
      switch i->decoder {
      | Ok(ok) => Some(ok)
      | Error(_err) => None
      }
    }),
  ))

let one = (data, decoder) =>
  data
  ->manyOption(decoder)
  ->Option.flatMap(Array.get(_, 0))

let oneFromArr = (json, decoder) =>
  json
  ->Js.Json.decodeArray
  ->manyOption(decoder)
  ->Option.flatMap(Array.get(_, 0))

let dataObj = json => json->decodeObject->Option.flatMap(obj(_, "data"))
let resultsArr = json => json->decodeObject->Option.flatMap(arr(_, "results"))
