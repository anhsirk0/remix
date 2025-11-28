type weight =
  | @as("thin") Thin
  | @as("light") Light
  | @as("bold") Bold
  | @as("fill") Fill
  | @as("duotone") Duotone

type props = {className?: string, weight?: weight, width?: string}
type t = React.component<props>

@module("@phosphor-icons/react") external user: t = "UserIcon"
@module("@phosphor-icons/react") external userCircle: t = "UserCircleIcon"
@module("@phosphor-icons/react") external userSquare: t = "UserSquareIcon"
@module("@phosphor-icons/react") external x: t = "XIcon"
@module("@phosphor-icons/react") external magnifyingGlass: t = "MagnifyingGlassIcon"

// Arrows
@module("@phosphor-icons/react") external arrowLeft: t = "ArrowLeftIcon"
@module("@phosphor-icons/react") external arrowRight: t = "ArrowRightIcon"
@module("@phosphor-icons/react") external caretUp: t = "CaretUpIcon"
@module("@phosphor-icons/react") external caretLeft: t = "CaretLeftIcon"

@module("@phosphor-icons/react") external house: t = "HouseIcon"
@module("@phosphor-icons/react") external warning: t = "WarningIcon"
@module("@phosphor-icons/react") external warningCircle: t = "WarningCircleIcon"
@module("@phosphor-icons/react") external check: t = "CheckIcon"
@module("@phosphor-icons/react") external checkCircle: t = "CheckCircleIcon"
@module("@phosphor-icons/react") external robot: t = "RobotIcon"
@module("@phosphor-icons/react") external stackSimple: t = "StackSimpleIcon"
@module("@phosphor-icons/react") external stack: t = "StackIcon"
@module("@phosphor-icons/react") external empty: t = "EmptyIcon"
@module("@phosphor-icons/react") external plus: t = "PlusIcon"
@module("@phosphor-icons/react") external pencil: t = "PencilIcon"

@module("@phosphor-icons/react") external sliders: t = "SlidersIcon"
@module("@phosphor-icons/react") external sparkle: t = "SparkleIcon"
@module("@phosphor-icons/react") external palette: t = "PaletteIcon"
@module("@phosphor-icons/react") external musicNote: t = "MusicNoteIcon"
@module("@phosphor-icons/react") external musicNotes: t = "MusicNotesIcon"
@module("@phosphor-icons/react") external playlist: t = "PlaylistIcon"
@module("@phosphor-icons/react") external cassetteTape: t = "CassetteTapeIcon"
@module("@phosphor-icons/react") external vinylRecord: t = "VinylRecordIcon"
