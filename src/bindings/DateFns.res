type t
@module("date-fns") external format: (t, string) => string = "format"
// @module("date-fns") external isThisMinute: tt => bool = "isThisMinute"
@module("date-fns") external isToday: t => bool = "isToday"
@module("date-fns") external isYesterday: t => bool = "isYesterday"
@module("date-fns") external isThisWeek: t => bool = "isThisWeek"
