defmodule FakebustersWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use FakebustersWeb, :controller
      use FakebustersWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: FakebustersWeb

      import Plug.Conn
      import FakebustersWeb.Gettext
      alias FakebustersWeb.Router.Helpers, as: Routes
    end
  end

  def view(opts \\ [root: "lib/fakebusters_web/templates", namespace: FakebustersWeb]) do
    quote do
      use Phoenix.View, unquote(opts)

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())

      import FakebustersWeb.Components.ComponentHelpers

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

      def error_tag(form, field, [class: class]) do
        Enum.map(Keyword.get_values(form.errors, field), fn error ->
          content_tag(:span, translate_error(error),
            class: "invalid-feedback " <> class,
            phx_feedback_for: input_name(form, field)
          )
        end)
      end
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {FakebustersWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import FakebustersWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import FakebustersWeb.ErrorHelpers
      import FakebustersWeb.Gettext
      alias FakebustersWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__({which, opts}) when is_atom(which) do
    apply(__MODULE__, which, [opts])
  end
end
