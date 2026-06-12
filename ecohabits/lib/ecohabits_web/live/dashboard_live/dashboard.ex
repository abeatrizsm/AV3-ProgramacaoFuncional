defmodule EcohabitsWeb.DashboardLive.Dashboard do
  use EcohabitsWeb, :live_view

  alias Ecohabits.Habits
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user

    history =
      Habits.list_user_check_ins(user)

    points =
      Habits.weekly_points(user)

    community_feed =
      Habits.list_recent_check_ins()

    if connected?(socket) do
      PubSub.subscribe(
        Ecohabits.PubSub,
        "community_feed"
      )
    end

    {:ok,
     assign(socket,
       user: user,
       history: history,
       points: points,
       community_feed: community_feed
     )}
  end

  @impl true
  def handle_info(
        {:new_check_in, user_name, date},
        socket
      ) do

    new_item = %{
      user_name: user_name,
      date: date
    }

    feed =
      [new_item | socket.assigns.community_feed]
      |> Enum.take(20)

    {:noreply,
    assign(
      socket,
      :community_feed,
      feed
    )}
  end

  @impl true
  def handle_event("check_in", _, socket) do
    user = socket.assigns.user

    case Habits.create_check_in(user) do
      {:ok, _check_in} ->
        history =
          Habits.list_user_check_ins(user)

        points =
          Habits.weekly_points(user)

        {:noreply,
         socket
         |> assign(
           history: history,
           points: points
         )
         |> put_flash(:info, "Check-in realizado com sucesso!")}

      {:error, _changeset} ->
        {:noreply,
         put_flash(
           socket,
           :error,
           "Você já realizou check-in hoje!"
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen">
      <.sidebar current_scope={@current_scope} />
      <div class="bg-[#101318] flex flex-col px-28 py-20 ml-64 min-h-screen w-full overflow-y-auto">

        <h2 class="text-white font-bold text-4xl pb-4">
          Olá, <%= @user.name %>!
        </h2>

        <p class="text-white text-lg pb-9">
          Pronto(a) para melhorar seus hábitos hoje?
        </p>

        <div class="flex gap-x-3">

          <div class="flex p-6 pl-8 pr-8 bg-gradient-to-r from-green-600 to-green-400 w-full rounded-2xl">

            <div class="flex flex-col">

              <h2 class="text-2xl font-bold text-white pb-2">
                Realizar Check-in
              </h2>

              <p class="text-gray-100">
                Registre seus hábitos de hoje!
              </p>

            </div>

            <div class="ml-auto pt-3">
              <button phx-click="check_in" class="bg-green-800 hover:bg-green-900 text-white font-semibold rounded-xl w-40 h-12">
                Check-in
              </button>
            </div>
          </div>
        </div>

        <div class="flex gap-6 mt-8">

          <div class="bg-[#191d24] border border-[#2b303b] rounded-2xl p-6 w-full">

            <h3 class="text-white text-lg font-semibold">
              Pontuação da Semana
            </h3>

            <p class="text-4xl font-bold text-green-500 mt-4">
              <%= @points %>
            </p>

            <p class="text-gray-400 mt-2">
              pontos acumulados
            </p>

          </div>
        </div>

        <div class="flex flex-col w-full mt-10 bg-[#191d24] border border-[#2b303b] rounded-2xl p-6 pl-7">

          <h2 class="text-white font-semibold text-3xl mb-6">
            Histórico de Check-ins
          </h2>

          <div class="max-h-96 overflow-y-auto rounded-2xl pr-2">

            <%= if Enum.empty?(@history) do %>
              <div class="flex justify-center items-center h-40">
                <p class="text-gray-400 text-lg">
                  Nenhum check-in registrado.
                </p>
              </div>

            <% else %>
              <%= for check_in <- @history do %>
                <div class="bg-[#101318] border border-[#2b303b] rounded-xl p-4 mb-3">
                  <div class="flex justify-between items-center">
                    <span class="text-white font-semibold">
                      Check-in realizado
                    </span>
                    <span class="text-green-500">
                      <%= check_in.date %>
                    </span>
                  </div>
                </div>
              <% end %>
            <% end %>
          </div>
        </div>

        <div class="flex flex-col w-full mt-10 bg-[#191d24] border border-[#2b303b] rounded-2xl p-6">

          <h2 class="text-white font-semibold text-3xl mb-6">
            Feed da Comunidade
          </h2>

          <div class="max-h-96 overflow-y-auto">

            <%= for item <- @community_feed do %>

              <div class="bg-[#101318] border border-[#2b303b] rounded-xl p-4 mb-3">

                <p class="text-white font-semibold">
                  <%= if Map.has_key?(item, :user) do %>
                    <%= item.user.name %>
                  <% else %>
                    <%= item.user_name %>
                  <% end %>
                </p>

                <p class="text-gray-400">
                  realizou um check-in
                </p>

                <p class="text-green-500 text-sm mt-1">
                  <%= item.date %>
                </p>

              </div>

            <% end %>

          </div>


        </div>
      </div>
      </div>
    """
  end
end
