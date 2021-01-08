module CreateTableUsers

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:users) do
    [
      primary_key()
      column(:uid, :string, limit = 20)
      column(:nickname, :string, limit = 16)
      column(:password, :string, limit = 16)
    ]
  end

  add_index(:users, "uid`, `password", name = "uid_password")
end

function down()
  drop_table(:users)
end

end
