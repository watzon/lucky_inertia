module Lucky::Renderable
  def inertia(component : String, props : Hash | NamedTuple = {} of String => String)
    Inertia::Renderer.render(component, props, context)
  end
end
