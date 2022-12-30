# Inertia.js Lucky Adapter

Create server-driven single page applications using [Lucky](https://luckyframework.org) and Vue3, React, or Svelte. No client routing, no store.

To use Inertia.js you need a server side adapter (like this) and a client side adapter, such as [inertia-vue](https://github.com/inertiajs/inertia-vue). Follow the installation instructions below to get started, and don't forget to check out the [Inertia.js Documentation](https://inertiajs.com/) itself.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     lucky_inertia:
       github: watzon/lucky_inertia
   ```

2. Run `shards install`

3. Include the shard in your `src/shards.cr` file
    ```crystal
    # Require your shards here
    require "lucky"
    require "avram/lucky"
    require "carbon"
    require "lucky_inertia" # <- Put it here
    ```

4. Run the installer task
    ```shell
    # For Vue3
    lucky inertia.install vue

    # For React
    lucky inertia.install react

    # For Svelte
    lucky inertia.install svelte

    # Or the bring-your-own-framework method
    lucky intertia.install
    ```

5. If you selected a framework to be installed, import the newly created `src/js/inertia.js` file in your `app.js`
    ```js
    require("@rails/ujs").start();
    require("./inertia"); // <- put it here
    ```

6. Be sure to update your build file to work with the framework you're using. With Vue3 and Laravel Mix as an example:
    ```js
      const path = require("path")
      
      //..

      mix
        .setPublicPath("public")
        .js("src/js/app.js", "js")
        .alias({ '@': path.resolve('src/js') })
        .sourceMaps()
        .vue()
    ```

## Usage

Inertia facilitates communication between your frontend SPA and your backend web server, in this case Lucky. What this means is that you can directly render your Vue, React, or Svelte pages from your Lucky actions. For example:

```crystal
class App::Index < InertiaAction
  get "/" do
    inertia "Index"
  end
end
```

The above will tell the Inertia.js frontend to open the page registered as `TestPage`. Using the default installation this will be the file located at `src/js/Pages/TestPage.{vue,svelte,jsx}`.

### SSR

SSR support requires some changes to your codebase that are best handled manually. Most of the changes are detailed in the [Server Side Rendering](https://inertiajs.com/server-side-rendering) side of the Inertia documentation, so I'd recommend following the instructions there to get the SSR components installed for your framework of choice. Listed below are the instructions specifically for Vue.

1. Install the server-side rendering dependencies
    ```shell
    yarn add @vue/server-renderer
    ```

2. Install the `@inertiajs/server` package to add SSR support to Inertia itself
    ```shell
    yarn add @inertiajs/server
    ```

3. Create the SSR JS entrypoint
    ```shell
    touch src/js/ssr.js
    ```

4. This file will look a lot like your `inertia.js` file, with the main exception being this file will not run in the browser. Add anything that is in `inertia.js` to this file as well, just make sure anything you're using is SSR compatible.
    ```js
    import { createSSRApp, h } from 'vue'
    import { renderToString } from '@vue/server-renderer'
    import { createInertiaApp } from '@inertiajs/inertia-vue3'
    import createServer from '@inertiajs/server'

    createServer((page) => createInertiaApp({
      page,
      render: renderToString,
      resolve: name => require(`./Pages/${name}`),
      setup({ app, props, plugin }) {
        return createSSRApp({
          render: () => h(app, props),
        }).use(plugin)
      },
    }))
    ```

5. Install `webpack-node-externals`
    ```shell
    yarn add webpack-node-externals --dev
    ```

6. Create `webpack.ssr.mix.js`. This is going to be your SSR pipeline entrypoint.
    ```shell
    touch webpack.ssr.mix.js
    ```

    Here is an example of what you should have in this file:
    ```js
    const path = require('path')
    const mix = require('laravel-mix')
    const webpackNodeExternals = require('webpack-node-externals')

    mix
      .options({ manifest: false })
      .js('src/js/ssr.js', 'public/js')
      .vue({ version: 3, options: { optimizeSSR: true } })
      .alias({ '@': path.resolve('src/js') })
      .webpackConfig({
        target: 'node',
        externals: [webpackNodeExternals()],
      })
    ```

7. Enable SSR in your `config/inertia.cr` file by setting `settings.ssr_enabled = true`

The following steps are optional, but really help streamline your build pipeline.

8. Install `concurrently`
    ```shell
    yarn add concurrently --dev
    ```

9. Add the following to the `scripts` section of your `package.json`, overwriting what's there currently
    ```json
    {
      // ...
      "scripts": {
        "dev": "concurrently \"yarn run watch:base\" \"yarn run watch:ssr\"",
        "dev:base": "yarn run mix",
        "dev:ssr": "yarn run mix --mix-config=webpack.ssr.mix.js",
        "watch": "concurrently \"yarn run watch:base\" \"yarn run watch:ssr\"",
        "watch:base": "yarn run mix watch",
        "watch:ssr": "yarn run mix watch --mix-config=webpack.ssr.mix.js",
        "prod": "yarn run mix --production && yarn run mix --production --mix-config=webpack.ssr.mix.js"
      }
      // ...
    }
    ```

10. Add the following line to `Procfile` and `Procfile.dev`
      ```procfile
      ssr: node public/js/ssr.js
      ```

And that's it. A lot of steps, but you should now have a working Vue3 SSR application.

## Contributing

1. Fork it (<https://github.com/watzon/lucky_inertia/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
