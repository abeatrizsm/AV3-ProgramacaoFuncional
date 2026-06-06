defmodule EcohabitsWeb.Sidebar do
  use Phoenix.Component

  attr(:current_scope, :map, required: true)

  def sidebar(assigns) do
    ~H"""
    <div class="fixed left-0 top-0 flex flex-col w-64 bg-[#14181f] h-screen border-r border-gray-700">
      <div class="flex items-center h-24 px-6 border-b border-gray-700">
        <div class="flex flex-col">
          <h2 class="text-green-500 text-2xl font-bold">
            EcoHabits
          </h2>

          <p class="text-gray-400 text-sm">
            Minha Área
          </p>

        </div>

      </div>

      <div class="flex flex-col p-6 gap-4">

        <.link
          navigate="/dashboard"
          class="text-white hover:text-green-500 font-semibold"
        >
          Dashboard
        </.link>

        <.link
          navigate="/profile"
          class="text-white hover:text-green-500 font-semibold"
        >
          Perfil
        </.link>

      </div>

      <div class="mt-auto p-6 border-t border-gray-700">

        <.link
          href="/users/log-out"
          method="delete"
          class="text-red-500 hover:text-red-700 font-bold"
        >
          Sair
        </.link>

      </div>

    </div>
    """
  end
end
