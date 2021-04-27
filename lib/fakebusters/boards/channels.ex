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
    },
    %{
      name: :advocates_t_defenders,
      readonly: false,
      whitelist: [1, 3]
    },
    %{
      name: :advocates_f_defenders,
      readonly: false,
      whitelist: [2, 4]
    }
  ]

  def channel_human_readable(:events, _), do: "Administration events"
  def channel_human_readable(:members, _), do: "Members board"
  def channel_human_readable(:judge_t_advocates, _), do: "Advocates (truthy side) & Judge"
  def channel_human_readable(:judge_f_advocates, _), do: "Advocates (false side) & Judge"
  def channel_human_readable(:advocates_t_defenders, _), do: "Advocates & Defenders (truthy side)"
  def channel_human_readable(:advocates_f_defenders, _), do: "Advocates & Defenders (false side)"
  def channel_human_readable(_, _), do: "Unknown channel"

  def num_to_channel(num) do
    case Enum.at(@channels, num, nil) do
      %{name: name} -> name
      _ -> nil
    end
  end

  def channel_to_num(name) do
    res =
      Enum.reduce_while(@channels, {false, 0}, fn el, {_found, num} ->
        if el.name != name do
          {:cont, {false, num + 1}}
        else
          {:halt, {true, num}}
        end
      end)

    case res do
      {true, num} -> num
      _ -> nil
    end
  end

  def textable_channels_nums() do
    {_i, list} =
      Enum.reduce(@channels, {0, []}, fn channel, {i, list} ->
        list =
          if channel.readonly do
            list
          else
            [i | list]
          end

        {i + 1, list}
      end)

    list
  end

  def textable_channel?(name) when is_atom(name) do
    channel = Enum.find(@channels, &(&1.name == name))
    not channel.readonly
  end

  def textable_channel?(num) when is_integer(num) do
    channel = Enum.at(@channels, num)
    not channel.readonly
  end

  def role_channels(role) do
    Enum.reduce(@channels, [], fn channel, list ->
      if Enum.member?(channel.whitelist, role) do
        [channel.name | list]
      else
        list
      end
    end)
  end
end
