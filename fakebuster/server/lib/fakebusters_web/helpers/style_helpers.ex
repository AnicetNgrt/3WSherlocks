defmodule FakebustersWeb.StyleHelpers do
  def tw_components() do
    %{
      form_title: "text-2xl mb-5",
      input_text: "appearance-none text-xl m-1 px-3 py-2 focus:outline-none focus:ring ring-offset-4 rounded-md bg-gradient-to-l from-blue-200 to-blue-300",
      field_label: "pb-1 pl-2",
      field_error: "py-1 pl-2 text-red-700",
      form_error: "mb-3 px-3 py-2 rounded-md bg-gradient-to-l from-red-200 to-red-300",
      form_submit: "appearance-none mt-3 px-3 py-2 focus:ring ring-offset-4 rounded-md bg-gradient-to-l from-blue-200 to-blue-300 hover:from-green-200 hover:to-green-300 hover:shadow-md"
    }
  end
end
