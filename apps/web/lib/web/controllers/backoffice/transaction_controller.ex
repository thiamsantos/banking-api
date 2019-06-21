defmodule Web.Backoffice.TransactionController do
  use Web, :controller

  action_fallback Web.FallbackController

  def total_amount(conn, %{"year" => year, "month" => month, "day" => day}) do
    with {:ok, date} <- parse_date("#{year}-#{month}-#{day}", "{YYYY}-{M}-{D}") do
      amount = Backoffice.total_transactions_amount_by_day(date)
      render(conn, "show.json", amount: amount)
    end
  end

  def total_amount(conn, %{"year" => year, "month" => month}) do
    with {:ok, date} <- parse_date("#{year}-#{month}", "{YYYY}-{M}") do
      amount = Backoffice.total_transactions_amount_by_month(date.year, date.month)
      render(conn, "show.json", amount: amount)
    end
  end

  def total_amount(conn, %{"year" => year}) do
    with {:ok, date} <- parse_date(year, "{YYYY}") do
      amount = Backoffice.total_transactions_amount_by_year(date.year)
      render(conn, "show.json", amount: amount)
    end
  end

  def total_amount(conn, _params) do
    amount = Backoffice.total_transactions_amount()
    render(conn, "show.json", amount: amount)
  end

  defp parse_date(date, format) do
    case Timex.parse(date, format) do
      {:ok, date} -> {:ok, date}
      {:error, _reason} -> {:error, :invalid_date}
    end
  end
end
