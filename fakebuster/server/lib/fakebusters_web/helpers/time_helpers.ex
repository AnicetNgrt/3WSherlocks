defmodule FakebustersWeb.TimeHelpers do
  def extract_days(sec), do: extract(sec, 60 * 60 * 24)

  def extract_hours(sec), do: extract(sec, 60 * 60)

  def extract_minutes(sec), do: extract(sec, 60)

  def extract(sec, amount) do
    chunks = div(sec, amount)
    {chunks, sec - amount * chunks}
  end

  def if_sup_chunk_by(n, chunk_size) do
    if n > chunk_size do
      n - rem(n, chunk_size)
    else
      n
    end
  end

  def human_readable_time(nil), do: "0 minutes"

  def human_readable_time(sec) do
    parts = [""]

    {sec, parts} =
      case extract_days(sec) do
        {0, sec} -> {sec, parts}
        {days, sec} -> {sec, ["#{days} days" | parts]}
      end

    {sec, parts} =
      case extract_hours(sec) do
        {0, sec} -> {sec, parts}
        {hours, sec} -> {sec, ["#{hours} hours" | parts]}
      end

    {sec, parts} =
      case extract_minutes(sec) do
        {0, sec} -> {sec, parts}
        {minutes, sec} -> {sec, ["#{minutes} minutes" | parts]}
      end

    Enum.join(Enum.reverse(parts), " ")
  end
end
