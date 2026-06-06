defmodule Ecohabits.Repo.Migrations.CreateCheckIns do
  use Ecto.Migration

  def change do
    create table(:check_ins) do
      add(:date, :date)

      add(
        :user_id,
        references(:users, on_delete: :delete_all)
      )

      timestamps()
    end

    create(index(:check_ins, [:user_id]))

    create(
      unique_index(
        :check_ins,
        [:user_id, :date]
      )
    )
  end
end
