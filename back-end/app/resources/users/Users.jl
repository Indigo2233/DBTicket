module Users

import SearchLight: AbstractModel, DbId, save!
import Base: @kwdef

export User

@kwdef mutable struct User <: AbstractModel
  id::DbId = DbId()
  uid::String = ""
  nickname::String = ""
  password::String = ""
end

function seed()
  User(DbId(), "7777777", "7777777", "lucky seven") |> save!
end
end
