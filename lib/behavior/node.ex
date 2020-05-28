defprotocol Behavior.Node do
  @type task :: any

  @spec create_task(t) :: task
  def create_task(node)
end
