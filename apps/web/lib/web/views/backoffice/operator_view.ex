defmodule Web.Backoffice.OperatorView do
  use Web, :view

  def render("show.json", %{operator: operator}) do
    %{data: render_one(operator, __MODULE__, "operator.json")}
  end

  def render("operator.json", %{operator: operator}) do
    %{id: operator.id, email: operator.email}
  end
end
