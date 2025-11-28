module Os = {
  type t
  @module("os") external homedir: unit => string = "homedir"
}
