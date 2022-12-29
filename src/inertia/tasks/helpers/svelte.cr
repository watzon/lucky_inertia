module Inertia::Tasks
  SVELTE_TEMPLATE = <<-JS
      import { InertiaApp } from '@inertiajs/inertia-svelte'
      import { InertiaProgress } from '@inertiajs/progress'

      InertiaProgress.init()

      const app = document.getElementById('app')

      new InertiaApp({
        target: app,
        props: {
          initialPage: JSON.parse(app.dataset.page),
          resolveComponent: name => require(`./Pages/${name}.svelte`),
        },
      })
    JS

  SVELTE_PAGE = <<-SVELTE
    <script>
    export let page
    </script>

    <style>
    </style>

    <div>
      <h1 class="text-3xl font-bold mb-4">Inertia Svelte</h1>
      <p class="text-gray-600 mb-8">
        This is a test page for the Inertia Svelte adapter.
      </p>
      <p class="text-gray-600 mb-8">
        You can find the source code for this page in <code>src/Pages/Test.svelte</code>.
      </p>
      <p class="text-gray-600 mb-8">
        You can find the source code for the Inertia Svelte adapter in <code>node_modules/@inertiajs/inertia-svelte</code>.
      </p>
    </div>
  SVELTE
end
