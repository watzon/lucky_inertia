require "lucky"
require "habitat"

module Inertia
  Habitat.create do
    setting version : String? = nil
    setting ssr_enabled : Bool = false
    setting ssr_url : String = "http://localhost:13714"
  end
end

require "./inertia/*"
require "./lucky/*"
