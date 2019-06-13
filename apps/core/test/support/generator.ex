defmodule Core.Generator do
  def random_string(size) do
    size |> :crypto.strong_rand_bytes() |> Base.url_encode64() |> binary_part(0, size)
  end
end
