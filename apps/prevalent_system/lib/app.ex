defmodule Prevalent.App do
    use Application

    def start(_type, _args) do
        import Supervisor.Spec
        tree = [
            worker(Prevalent.System, [[], [name: :prevalent_system]])
        ]
        opts = [name: Prevalent.Sup, strategy: :one_for_one]
        Supervisor.start_link(tree, opts)
    end
  
end