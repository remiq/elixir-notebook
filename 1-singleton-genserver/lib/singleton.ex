defmodule Singleton do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    master_children = [
      worker(Singleton.AbeVigoda, [[name: Singleton.AbeVigoda]])
    ]
    children = [
      worker(Singleton.AbeDVDPrice, [[name: Singleton.AbeDVDPrice]])
    ]
    if (Node.self == master_node) do
      children = master_children ++ children
    else
      :pong = Node.ping master_node
    end
    opts = [strategy: :one_for_one]
    Supervisor.start_link children, opts
  end

  def master_node do
    Application.get_env :singleton, :master_node
  end
end
