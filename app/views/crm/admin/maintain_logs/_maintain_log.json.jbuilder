json.extract!(
  maintain_log,
  :id,
  :note,
  :logged_type,
  :logged_id,
  :created_at
)
if maintain_log.maintain_tag
  json.maintain_tag maintain_log.maintain_tag, :id, :name, :color
end
