module Inertia::Tasks
  VUE3_TEMPLATE = <<-JS
    import { createApp, h } from 'vue'
    import { createInertiaApp } from '@inertiajs/inertia-vue3'

    createInertiaApp({
      resolve: (name) => require(`./Pages/${name}`),
      setup({ el, app, props, plugin }) {
        createApp({ render: () => h(app, props) })
          .use(plugin)
          .mount(el)
      },
    })
  JS

  VUE3_PAGE = <<-VUE
    <template>
      <div>
        <h1 class="text-3xl font-bold mb-4">Inertia Vue3</h1>
        <p class="text-gray-600 mb-8">
          This is a test page for the Inertia Vue3 adapter.
        </p>
        <p class="text-gray-600 mb-8">
          You can find the source code for this page in <code>src/Pages/Test.vue</code>.
        </p>
        <p class="text-gray-600 mb-8">
          You can find the source code for the Inertia Vue3 adapter in <code>node_modules/@inertiajs/inertia-vue3</code>.
        </p>
      </div>
    </template>

    <script setup>
    </script>
  VUE
end
