module Inertia::Tasks
  REACT_TEMPLATE = <<-JS
    import React from 'react'
    import ReactDOM from 'react-dom'
    import { InertiaApp } from '@inertiajs/inertia-react'
    import { InertiaProgress } from '@inertiajs/progress'

    InertiaProgress.init()

    const el = document.getElementById('app')

    ReactDOM.render(
      <InertiaApp
        initialPage={JSON.parse(el.dataset.page)}
        resolveComponent={name => require(`./Pages/${name}`).default}
      />,
      el
    )
  JS

  REACT_PAGE = <<-JS
    import React from 'react'

    export default function Test(props) {
      return (
        <div>
          <h1 className="text-3xl font-bold mb-4">Inertia React</h1>
          <p className="text-gray-600 mb-8">
            This is a test page for the Inertia React adapter.
          </p>
          <p className="text-gray-600 mb-8">
            You can find the source code for this page in <code>src/Pages/Test.js</code>.
          </p>
          <p className="text-gray-600 mb-8">
            You can find the source code for the Inertia React adapter in <code>node_modules/@inertiajs/inertia-react</code>.
          </p>
        </div>
      )
    }
  JS
end
