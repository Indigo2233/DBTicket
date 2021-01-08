module Orders

import SearchLight: AbstractModel, DbId
import Base: @kwdef
using Dates

export Order

@kwdef mutable struct Order <: AbstractModel
  id::DbId = DbId()
  ticketId::Int = 0
  userId::String = ""
  dealTime::DateTime = Date(2020) 
end

end
