json.extract! maintain,
              :id,
              :note,
              :state,
              :state_i18n,
              :created_at,
              :updated_at
json.client maintain.client, :id, :real_name, :nick_name, :birthday_type, :birthday, :age_str, :gender#, :avatar_url
json.tutelar maintain.tutelar, :id, :real_name, :identity, :mobile, :address, :wechat
json.tutelage maintain.tutelage, :id, :relation
if maintain.maintain_source
  json.maintain_source maintain.maintain_source, :id, :name
end
json.maintain_tags maintain.maintain_tags do |tag|
  json.extract! tag, :id, :name, :color
end
json.plans maintain.plans do |plan|
  json.extract! plan, :id, :begin_on, :end_on
end
json.booker_times maintain.booker_times do |booker_time|
  json.extract! booker_time, :booking_on, :start_at, :finish_at
  json.booked booker_time.booked, :id, :title
end
