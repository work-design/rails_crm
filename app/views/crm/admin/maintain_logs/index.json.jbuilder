json.maintain_logs @maintain_logs, partial: 'maintain_log', as: :maintain_log
json.partial! 'shared/pagination', items: @maintain_logs
