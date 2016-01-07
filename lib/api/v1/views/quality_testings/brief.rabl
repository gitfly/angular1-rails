object @quality_testing => false

attributes :id, :technology_id, :tester_id, :qualified, :remark, :refer

locals[:object] ||= @technology

node(:photo) do |m|
    partial('photos/photo', object: locals[:object].photo)
end

