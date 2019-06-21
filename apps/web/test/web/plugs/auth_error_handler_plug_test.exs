defmodule Web.AuthErrorHandlerPlugTest do
  use Web.ConnCase, async: true

  import ExUnit.CaptureLog

  alias Web.AuthErrorHandlerPlug

  describe "auth_error/3" do
    test "log errors and respond with 401", %{conn: conn} do
      type = :type
      reason = :reason

      expected_message =
        "Failed to authenticate request. Type: #{inspect(type)}. Reason: #{inspect(reason)}."

      actual_message =
        capture_log(fn ->
          response =
            conn
            |> AuthErrorHandlerPlug.auth_error({type, reason}, [])
            |> json_response(401)

          assert response == %{"errors" => ["Invalid token"]}
        end)

      assert actual_message =~ expected_message
    end
  end
end
