defmodule Web.FallbackControllerTest do
  use Web.ConnCase, async: true

  alias Web.FallbackController
  alias Web.Accounts.CreateParams

  describe "call/2" do
    test "changeset error", %{conn: conn} do
      {:error, changeset} = CreateParams.parse(%{})

      response =
        conn
        |> FallbackController.call({:error, changeset})
        |> json_response(422)

      assert response == %{
               "errors" => %{
                 "email" => ["can't be blank"],
                 "password" => ["can't be blank"]
               }
             }
    end

    test "invalid email or password error", %{conn: conn} do
      response =
        conn
        |> FallbackController.call({:error, :invalid_email_or_password})
        |> json_response(422)

      assert response == %{"errors" => %{"email" => ["Invalid email or password"]}}
    end

    test "generic error", %{conn: conn} do
      response =
        conn
        |> FallbackController.call({:error, :some_random_error})
        |> json_response(500)

      assert response == %{"errors" => ["some_random_error"]}
    end
  end
end
