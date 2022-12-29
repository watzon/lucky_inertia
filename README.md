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
      mix
        .setPublicPath("public")
        .js("src/js/app.js", "js")
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

## Contributing

1. Fork it (<https://github.com/watzon/lucky_inertia/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
