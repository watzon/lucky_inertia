require "colorize"

class Inertia::Setup < BaseTask
  summary "Create the necessary files for a new Inertia project"

  def initialize(@quiet : Bool = false)
  end

  def help_message
    <<-TEXT
      #{summary}

      Examples:

        inertia.setup vue       # Create a new Vue3 project
        inertia.setup react    # Create a new React project
        inertia.setup svelte  # Create a new Svelte project
        inertia.setup             # Install inertia, but don't create any framework specific files
      TEXT
  end

  def run_task
    framework = ARGV[0]?

    log "Installing Inertia"
    install_inertia

    case framework
    when "vue"
      log "Installing Vue3"
      install_vue
    when "react"
      log "Installing React"
      install_react
    when "svelte"
      log "Installing Svelte"
      install_svelte
    end

    log "Done!"
  end

  private def install_inertia
    `yarn add @inertiajs/inertia @inertiajs/progress --dev`

    FileUtils.mkdir_p("src/actions/app")
    File.write("src/actions/inertia_action.cr", INERTIA_BASE_ACTION)
    File.write("src/actions/app/index.cr", DEFAULT_ACTION)
    File.write("src/pages/inertia_layout.cr", ROOT_LAYOUT)
    File.write("config/inertia.cr", CONFIG_TEMPLATE)

    log
    log "  - Created config/inertia.cr".colorize(:green)
    log "  - Created src/actions/inertia_action.cr".colorize(:green)
    log "  - Created src/actions/app/index.cr".colorize(:green)
    log "  - Created src/pages/inertia_layout.cr".colorize(:green)
    log
  end

  private def install_vue
    `yarn add @inertiajs/inertia-vue3 vue@next vue-loader@^16.2.0  --dev`
    FileUtils.mkdir_p("src/js/Pages")
    File.write("src/js/inertia.js", Inertia::Tasks::VUE3_TEMPLATE)
    File.write("src/js/Pages/Index.vue", Inertia::Tasks::VUE3_PAGE)

    log
    log "  - Created src/js/inertia.js".colorize(:green)
    log "  - Created src/js/Pages/Index.vue".colorize(:green)
    log
  end

  private def install_react
    `yarn add @inertiajs/inertia-react react react-dom --dev`
    FileUtils.mkdir_p("src/js/Pages")
    File.write("src/js/inertia.js", Inertia::Tasks::REACT_TEMPLATE)
    File.write("src/js/Pages/Index.jsx", Inertia::Tasks::REACT_PAGE)

    log
    log "  - Created src/js/inertia.js".colorize(:green)
    log "  - Created src/js/Pages/Index.jsx".colorize(:green)
    log
  end

  private def install_svelte
    `yarn add @inertiajs/inertia-svelte svelte --dev`
    FileUtils.mkdir_p("src/js/Pages")
    File.write("src/js/inertia.js", Inertia::Tasks::SVELTE_TEMPLATE)
    File.write("src/js/Pages/Index.svelte", Inertia::Tasks::SVELTE_PAGE)

    log
    log "  - Created src/js/inertia.js".colorize(:green)
    log "  - Created src/js/Pages/Index.svelte".colorize(:green)
    log
  end

  private def log(*args)
    puts(*args) unless @quiet
  end

  CONFIG_TEMPLATE = <<-CRYSTAL
    Inertia.configure do |settings|
      # set the current version for automatic asset refreshing. A string value should be used if any.
      settings.version = nil

      # ssr specific options
      settings.ssr_enabled = false
      settings.ssr_url = "http://localhost:13714"
    end
  CRYSTAL

  DEFAULT_ACTION = <<-CRYSTAL
    class App::Index < InertiaAction
      get "/" do
        inertia "Index"
      end
    end
  CRYSTAL

  INERTIA_BASE_ACTION = <<-CRYSTAL
    abstract class InertiaAction < Lucky::Action
      include Lucky::ProtectFromForgery
      include Lucky::EnforceUnderscoredRoute
      include Lucky::SecureHeaders::DisableFLoC
      accepted_formats [:html, :json], default: :html
    end
  CRYSTAL

  ROOT_LAYOUT = <<-CRYSTAL
    @[Inertia::RootLayout]
    class InertiaLayout
      include Lucky::HTMLPage

      needs page : String
      needs content : String?
      needs head : Array(String)

      def page_title
        "Inertia"
      end

      def render
        html_doctype

        head do
          head.each { |tag| raw tag }

          utf8_charset
          title "My App - #{page_title}"
          css_link asset("css/app.css")
          js_link asset("js/app.js"), defer: "true"

          csrf_meta_tags
          responsive_meta_tag
          live_reload_connect_tag
        end

        html lang: "en" do
          body do
            if content = self.content
              raw content
            else
              div id: "app", data_page: page
            end
          end
        end
      end
    end
  CRYSTAL
end
