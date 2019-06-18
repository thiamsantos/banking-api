locals_without_parens = [
  assert_email_sent: 1
]

[
  import_deps: [:ecto],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens
]
