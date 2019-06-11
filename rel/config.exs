~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: :prod

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"wE<T0_B&WF_x{`OFvo=~0LDtm<4^gB/6YL47y6H6.q)]N~pnP*Q4@qGw>r1b[vVj"
  set vm_args: "rel/vm.args"
  set config_providers: [
    {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]
  set overlays: [
    {:copy, "rel/config/config.exs", "etc/config.exs"}
  ]
end

release :banking_api do
  set version: "0.1.0"
  set applications: [
    :runtime_tools,
    backoffice: :permanent,
    banking: :permanent,
    core: :permanent,
    web: :permanent
  ]
end
