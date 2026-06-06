defmodule EcohabitsWeb.UserLive.Registration do
  use EcohabitsWeb, :live_view

  alias Ecohabits.Accounts
  alias Ecohabits.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm">
        <div class="text-center  ">
          <.header>
            <h2 class="text-white text-2xl font-bold mb-3 ">
              Crie sua conta para registrar seus Habitos Ecologicos!
            </h2>
            <:subtitle>
              Já tem uma conta?
              <.link navigate={~p"/users/log-in"} class="font-semibold text-brand hover:underline">
                Entre
              </.link>
              nela agora.
            </:subtitle>
          </.header>
        </div>

        <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate">
          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            autocomplete="username"
            spellcheck="false"
            required
            phx-mounted={JS.focus()}
          />
          <.input
            field={@form[:password]}
            type="password"
            label="Senha"
            autocomplete="password"
            spellcheck="false"
            required
            phx-mounted={JS.focus()}
          />
          <.input
            field={@form[:name]}
            type="text"
            label="Nome"
            autocomplete="name"
            required
            phx-mounted={JS.focus()}
          />

          <.button phx-disable-with="Creating account..." class="btn btn-primary w-full">
            Crie sua conta
          </.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: EcohabitsWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_email(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Conta criada com sucesso!"
         )
         |> push_navigate(to: ~p"/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_email(%User{}, user_params, validate_unique: false)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
