json.tutelages @tutelages do |tutelage|
  json.extract! tutelage, :id, :relation
  json.pupil tutelage.pupil, :id, :real_name, :nick_name, :birthday_type, :birthday, :gender
  json.tutelar tutelage.tutelar, :id, :real_name, :identity, :area_id, :address
end
