defmodule FakebustersWeb.RolesHelpers do
  def human_readable_role(role) do
    case role do
      0 -> "judge"
      1 -> "truthy side's advocate"
      2 -> "falsy side's advocate"
      3 -> "truthy side's defender"
      4 -> "falsy side's defender"
      nil -> "outsider"
    end
  end
end
