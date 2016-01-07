object false
node(:appointments) do |m|
	@appointments.map do |appointment|
	    partial("appointments/show", object: appointment)   
	end   
end

node(:all_count) do |m|
  @all_count
end

node(:finished_count) do |m|
  @finished_count
end

node(:unfinished_count) do |m|
  @unfinished_count
end

node(:door_count) do |m|
  @door_count
end
node(:express_count) do |m|
  @express_count
end

node(:cancel_count) do |m|
  @cancel_count
end


