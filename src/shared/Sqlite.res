%%raw(`import { DatabaseSync } from "node:sqlite"`)

// TODO: error handling

module Database = {
  type t
  let make: string => t = %raw("function (path) {
    return  new DatabaseSync(path);
  }")
  @send external close: t => unit = "close"
}

module Query = {
  type t
  type allResult
  type runResult = {lastInsertRowid: int}

  @send external make: (Database.t, string) => t = "prepare"
  @send external run: (t, string) => unit = "run"
  @send external all: t => allResult = "all"

  @variadic @send external runInsert: (t, array<'a>) => runResult = "run"

  external transform: allResult => 'a = "%identity"
}
