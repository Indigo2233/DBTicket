module Tickets

import SearchLight: AbstractModel, DbId, save!
import Base: @kwdef
import Dates: DateTime
export Ticket

@kwdef mutable struct Ticket <: AbstractModel
  id::DbId = DbId()
  availableNumber::Int = 0
  beginTime::DateTime = DateTime(2020)
  city::String = ""
  detail::String = ""
  endTime::DateTime = DateTime(2020)
  price::Int = 0
  ticketName::String = ""
  typeName::String = ""
  venues::String = ""
  poster::String = ""
end

end
