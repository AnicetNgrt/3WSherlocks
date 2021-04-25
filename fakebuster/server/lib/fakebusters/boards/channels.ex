defmodule Fakebusters.Boards.Channels do
  @moduledoc false

  @channels [
    %{
      name: :events,
      readonly: true,
      whitelist: [0]
    },
    %{
      name: :members,
      readonly: true,
      whitelist: [0, 1, 2, 3, 4]
    },
    %{
      name: :judge_t_advocates,
      readonly: false,
      whitelist: [0, 1]
    },
    %{
      name: :judge_f_advocates,
      readonly: false,
      whitelist: [0, 2]
    }
  ]

  def num_to_channel(num) do
    case Enum.at(@channels, num, nil) do
      %{name: name} -> name
      _ -> nil
    end
  end

  def textable_channels_nums() do
    Enum.reduce(@channels, {0, []}, fn (channel, {i, list}) ->
      list = if channel.readonly do
        list
      else
        [i | list]
      end

      {i + 1, list}
    end)
  end

  def textable_channel?(name) do
    channel = Enum.find(@channels, &(&1.name == name))
    not channel.readonly
  end

  def role_channels(role) do
    Enum.reduce(@channels, [], fn (channel, list) ->
      if Enum.member?(channel.whitelist, role) do
        [channel.name | list]
      else
        list
      end
    end)
  end

  def channel_human_readable(:events, _), do: "Administration events"
  def channel_human_readable(:members, _), do: "Members board"
  def channel_human_readable(:judge_t_advocates, _), do: "Advocates (truthy) & Judge"
  def channel_human_readable(:judge_f_advocates, _), do: "Advocates (falsy) & Judge"
end
