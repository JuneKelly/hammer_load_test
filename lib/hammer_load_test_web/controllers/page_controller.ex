defmodule HammerLoadTestWeb.PageController do
  use HammerLoadTestWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def timestamp(conn, _params) do
    ip = conn.remote_ip
    |> Tuple.to_list
    |> Enum.join(".")
    # Do a custom-increment half of the time
    if :rand.uniform() > 0.5 do
      case Hammer.check_rate("timestamp:#{ip}", 1_000, 2000) do
        {:allow, _count} ->
          respond_timestamp(conn)
        {:deny, _limit} ->
          respond_rate_limit_exceeded(conn)
      end
    else
      case Hammer.check_rate_inc("timestamp:#{ip}", 1_000, 2000, 2) do
        {:allow, _count} ->
          respond_timestamp(conn)
        {:deny, _limit} ->
          respond_rate_limit_exceeded(conn)
      end
    end
  end

  defp respond_timestamp(conn) do
    now = DateTime.utc_now()
    conn |> json(%{timestamp: "#{now}"})
  end

  defp respond_rate_limit_exceeded(conn) do
    conn |> send_resp(429, "Too many requests")
  end

end
