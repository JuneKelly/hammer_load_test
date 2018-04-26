defmodule HammerLoadTestWeb.PageController do
  use HammerLoadTestWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def timestamp(conn, _params) do
    ip = conn.remote_ip
    |> Tuple.to_list
    |> Enum.join(".")
    case Hammer.check_rate("timestamp:#{ip}", 1_000, 500) do
      {:allow, _count} ->
        now = DateTime.utc_now()
        conn |> json(%{timestamp: "#{now}"})
      {:deny, _} ->
        conn |> send_resp(429, "Too many requests")
    end
  end

end
