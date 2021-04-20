defmodule FakebustersWeb.TailwindHelpers do
  def tw_components() do
    %{
      form_title:
        "text-2xl mb-5 text-yellow-400",
      input_text:
      "
        appearance-none
        text-xl
        m-1 px-3 py-2
        focus:outline-none focus:ring-2 ring-offset-2 ring-black
        rounded-md
        border-2 border-indigo-800
        bg-transparent
      ",
      field_label:
        "pb-1 pl-2",
      field_error:
        "py-1 pl-2 text-red-400",
      form_error:
        "mb-3 px-3 py-2 rounded-md border-2 border-red-500 text-red-400",
      form_submit:
      "
        flex items-center justify-center
        transition duration-100 ease-in-out
        w-max h-max
        px-4 py-2 md:py-2
        my-4
        text-yellow-300 hover:text-indigo-900
        bg-indigo-800 hover:bg-yellow-400
        rounded-full
        focus:outline-none focus:ring-2 ring-offset-2 ring-black
      "
    }
  end
end
