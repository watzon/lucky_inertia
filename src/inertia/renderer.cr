require "json"
require "http/server"
require "lucky"

require "./annotations"

module Inertia
  module Renderer
    extend self

    macro finished
      {% for cls in Lucky::HTMLPage.includers %}
        {% if ann = cls.annotation(Inertia::RootLayout) %}
          ROOT_LAYOUT = {{ cls }}
        {% end %}
      {% end %}
    end

    def render(component : String, props : Hash | NamedTuple, context : HTTP::Server::Context) : Lucky::TextResponse
      request = context.request
      response = context.response
      if request.headers.has_key?("X-Inertia")
        response.headers["Vary"] = "Accept"
        response.headers["X-Inertia"] = "true"
        payload = make_page(component, props, context)
        json_response(payload.to_json, context)
      else
        return render_ssr(component, props, context) if Inertia.settings.ssr_enabled?
        html_response(component, props, context)
      end
    end

    private def render_ssr(component, props, context)
      page = make_page(component, props, context)
      uri = URI.parse(Inertia.settings.ssr_url + "/render")

      res = HTTP::Client.post(uri, body: page.to_json, headers: HTTP::Headers{"Content-Type" => "application/json"})
      json = JSON.parse(res.body)

      head = json["head"].as_a.map(&.as_s)
      body = json["body"].as_s

      html_response(component, props, context, head: head, content: body)
    end

    private def make_page(component, props, context)
      {
        component: component,
        props:     props,
        url:       context.request.path,
        version:   Inertia.settings.version,
      }
    end

    private def json_response(body, context)
      Lucky::TextResponse.new(
        context,
        "application/json",
        body,
        status: context.response.status_code,
        enable_cookies: true,
      )
    end

    private def html_response(component, props, context, head = [] of String, content = nil)
      page = make_page(component, props, context)
      view = ROOT_LAYOUT.new(context: context, page: page.to_json, head: head, content: content)
      Lucky::TextResponse.new(
        context,
        "text/html",
        view.perform_render,
        status: context.response.status_code,
        enable_cookies: true,
      )
    end
  end
end
