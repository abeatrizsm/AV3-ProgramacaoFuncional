defmodule EcohabitsWeb.HabitLive.Form do
  use EcohabitsWeb, :live_view

  alias Ecohabits.Habits2
  alias Ecohabits.Habits.Habit

  @categories [
    "alimentação",
    "transporte",
    "energia",
    "água",
    "resíduos"
  ]

  def mount(_params, _session, socket) do
    changeset = Habit.changeset(%Habit{}, %{
      "user_id" => socket.assigns.current_scope.user.id
    })

    {:ok,
     socket
     |> assign(:page_title, "Novo Hábito")
     |> assign(:categories, @categories)
     |> assign(:habit, %Habit{})
     |> assign_form(changeset)}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    user_id = socket.assigns.current_scope.user.id

    habit = Habits2.get_habit!(id, user_id)

    {:noreply,
     socket
     |> assign(:page_title, "Editar Hábito")
     |> assign(:habit, habit)
     |> assign_form(Habit.changeset(habit, %{}))}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", %{"habit" => params}, socket) do
    changeset =
      socket.assigns.habit
      |> Habit.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"habit" => params}, socket) do
    params =
      Map.put(
        params,
        "user_id",
        socket.assigns.current_scope.user.id
      )

    save_habit(socket, socket.assigns.habit, params)
  end

  defp save_habit(socket, %Habit{id: nil}, params) do
    case Habits2.create_habit(params) do
      {:ok, _habit} ->
        {:noreply,
         socket
         |> put_flash(:info, "Hábito criado com sucesso!")
         |> push_navigate(to: "/habits")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_habit(socket, habit, params) do
    case Habits2.update_habit(habit, params) do
      {:ok, _habit} ->
        {:noreply,
         socket
         |> put_flash(:info, "Hábito atualizado com sucesso!")
         |> push_navigate(to: "/habits")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset))
  end
end
