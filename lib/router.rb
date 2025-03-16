class Router 
  def initialize
    @routes = {}
  end

  def add_route(method, path, action)
    @routes[method] ||= {}
    @routes[method][path] = action      
  end

  def resolve(request) 
    method = request.method
    path = request.path
    action = @routes.dig(method, path)
    return action.call(request) if action.is_a?(Proc)
    return action if action
    "#{method} #{path} 404 not found"
  end
end