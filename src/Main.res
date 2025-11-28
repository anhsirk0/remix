%%raw("import './index.css'")

let client = ReactQuery.Provider.createClient()

switch ReactDOM.querySelector("#root") {
| Some(root) =>
  ReactDOM.Client.createRoot(root)->ReactDOM.Client.Root.render(
    <React.StrictMode>
      <ReactQuery.Provider client>
        <Toast.Toaster />
        <App />
      </ReactQuery.Provider>
    </React.StrictMode>,
  )
| None => ()
}
