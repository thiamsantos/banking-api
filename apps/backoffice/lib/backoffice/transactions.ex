defmodule Backoffice.Transactions do
  import Ecto.Query
  alias Core.Repo
  alias Core.Schemas.Transaction

  def total_amount do
    sum_amount()
    |> Repo.one()
  end

  def total_amount_by_day(date) do
    base_date = Timex.to_naive_datetime(date)

    start_date = Timex.beginning_of_day(base_date)
    end_date = Timex.end_of_day(base_date)

    start_date
    |> sum_amount(end_date)
    |> Repo.one()
  end

  def total_amount_by_month(year, month) do
    base_date =
      {year, month, 1}
      |> Date.from_erl!()
      |> Timex.to_naive_datetime()

    start_date = Timex.beginning_of_month(base_date)
    end_date = Timex.end_of_month(base_date)

    start_date
    |> sum_amount(end_date)
    |> Repo.one()
  end

  def total_amount_by_year(year) do
    base_date =
      {year, 1, 1}
      |> Date.from_erl!()
      |> Timex.to_naive_datetime()

    start_date = Timex.beginning_of_year(base_date)
    end_date = Timex.end_of_year(base_date)

    start_date
    |> sum_amount(end_date)
    |> Repo.one()
  end

  defp sum_amount do
    from(t in Transaction,
      select: %{
        total_amount: t.amount |> sum() |> type(:integer) |> coalesce(0),
        count: count(t.id)
      }
    )
  end

  defp sum_amount(start_date, end_date) do
    sum_amount()
    |> where([t], ^start_date <= t.inserted_at and t.inserted_at <= ^end_date)
  end
end
