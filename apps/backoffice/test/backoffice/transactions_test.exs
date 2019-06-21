defmodule Backoffice.TransactionsTest do
  use Backoffice.DataCase, async: true

  alias Backoffice.Transactions

  describe "total_amount/0" do
    test "with transactions" do
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 23:00:07])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      assert Transactions.total_amount() == %{total_amount: 1000, count: 4}
    end

    test "without transactions" do
      assert Transactions.total_amount() == %{total_amount: 0, count: 0}
    end
  end

  describe "total_amount_by_day/1" do
    test "with transactions" do
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 00:00:00])
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 23:59:59])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      assert Transactions.total_amount_by_day(~D[2000-01-01]) == %{total_amount: 200, count: 2}
    end

    test "without transactions" do
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 23:00:07])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      assert Transactions.total_amount_by_day(~D[2000-01-03]) == %{total_amount: 0, count: 0}
    end
  end

  describe "total_amount_by_month/1" do
    test "with transactions" do
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 00:00:00])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-31 23:59:59])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      assert Transactions.total_amount_by_month(2000, 1) == %{total_amount: 300, count: 2}
    end

    test "without transactions" do
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 23:00:07])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      assert Transactions.total_amount_by_month(2000, 3) == %{total_amount: 0, count: 0}
    end
  end

  describe "total_amount_by_year/1" do
    test "with transactions" do
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 00:00:00])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-12-31 23:59:59])
      insert(:transfer, amount: 400, inserted_at: ~N[2001-12-31 23:59:59])

      assert Transactions.total_amount_by_year(2000) == %{total_amount: 1000, count: 4}
    end

    test "without transactions" do
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 23:00:07])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      assert Transactions.total_amount_by_year(2001) == %{total_amount: 0, count: 0}
    end
  end
end
