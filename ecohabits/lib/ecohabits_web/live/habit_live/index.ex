defmodule EcohabitsWeb.HabitLive.Index do
  use EcohabitsWeb, :live_view

  alias Ecohabits.Habits2

  @categories [
    "alimentação",
    "transporte",
    "energia",
    "água",
    "resíduos"
  ]

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_scope.user.id

    {:ok,
     socket
     |> assign(:categories, @categories)
     |> assign(:selected_category, "")
     |> assign(:habits, Habits2.list_habits(user_id))}
  end

  def handle_event("filter", %{"category" => ""}, socket) do
    user_id = socket.assigns.current_scope.user.id

    {:noreply,
     socket
     |> assign(:selected_category, "")
     |> assign(:habits, Habits2.list_habits(user_id))}
  end

  def handle_event("filter", %{"category" => category}, socket) do
    user_id = socket.assigns.current_scope.user.id

    {:noreply,
     socket
     |> assign(:selected_category, category)
     |> assign(:habits, Habits2.list_habits_by_category(user_id, category))}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    user_id = socket.assigns.current_scope.user.id

    habit = Habits2.get_habit!(id, user_id)

    {:ok, _} = Habits2.delete_habit(habit)

    {:noreply,
     assign(socket, :habits, Habits2.list_habits(user_id))}
  end
end
