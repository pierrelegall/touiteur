defmodule Touiteur.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :author_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:messages, [:author_id])
  end
end
