defmodule MelodyMatchWeb.SessionController do
  use MelodyMatchWeb, :controller
  alias MelodyMatch.Accounts

  def create(conn, %{"email" => email, "password" => password, "latitude" => lat, "longitude" => long}) do
    user = MelodyMatch.Accounts.authenticate(email, password)

    IO.inspect user

    if user do
      updated_params = %{last_latitude: lat, last_longitude: long}
      Accounts.update_user(user, updated_params)
        sess = %{
          user_id: user.id,
          name: user.name,
          token: Phoenix.Token.sign(conn, "user_id", user.id)
        }
        conn
        |> put_resp_header(
          "content-type",
        "application/json; charset=UTF-8")
        |> send_resp(:created, Jason.encode!(%{session: sess}))
    else
      conn
      |> put_resp_header(
        "content-type",
      "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(%{error: "fail"}))
    end
  end
end

