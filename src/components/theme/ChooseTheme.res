let themes = [
  "cupcake",
  "light",
  "dark",
  "bumblebee",
  "emerald",
  "corporate",
  "synthwave",
  "retro",
  "cyberpunk",
  "valentine",
  "halloween",
  "garden",
  "forest",
  "aqua",
  "lofi",
  "pastel",
  "fantasy",
  "wireframe",
  "black",
  "luxury",
  "dracula",
  "cmyk",
  "autumn",
  "business",
  "acid",
  "lemonade",
  "night",
  "coffee",
  "winter",
  "dim",
  "nord",
  "sunset",
]

@react.component
let make = (~isOpen, ~onClose) => {
  let (currentTheme, setCurrrentTheme) = React.useState(_ => Util.Dom.getTheme())

  let onChange = theme => {
    theme->Util.Dom.setTheme
    setCurrrentTheme(_ => theme)
  }

  React.useEffect0(() => {
    currentTheme->Util.Dom.setTheme
    None
  })

  React.useEffectOnEveryRender(() => {
    setCurrrentTheme(_ => Util.Dom.getTheme())
    None
  })

  let themeCards = Array.map(themes, theme =>
    <ThemeCard theme onChange key=theme>
      <div
        className="flex flex-row rounded-box bg-base-100 border-4 border-neutral relative cursor-pointer">
        <div className="w-8 min-h-[100%] bg-neutral" />
        <div className="flex flex-col grow p-4">
          <p className="title font-bold"> {theme->Util.toCapitalize->React.string} </p>
          <div
            className="flex flex-row gap-1 rounded-btn [&>div]:h-6 [&>div]:w-2 [&>div]:rounded-box">
            <div className="bg-primary" />
            <div className="bg-accent" />
            <div className="bg-secondary" />
            <div className="bg-neutral" />
          </div>
          {currentTheme == theme
            ? <Icon.sparkle
                className="size-4 text-neutral-content absolute top-1 left-1 animate-grow"
                weight=Fill
              />
            : React.null}
        </div>
      </div>
    </ThemeCard>
  )

  isOpen
    ? <Modal title="Themes" onClose classes="min-w-[60vw]">
        <ul
          id="theme-container"
          tabIndex=0
          className="grid grid-cols-12 gap-4 min-h-0 overflow-y-auto">
          {themeCards->React.array}
        </ul>
      </Modal>
    : React.null
}
