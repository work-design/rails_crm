json.events @events, partial: 'course_crowd', as: :course_crowd
json.course course_crowd.course, :id, :title
json.crowd course_crowd.crowd, :id, :name
json.next_occurrences course_crowd.next_occurrences(filter_options: { booker_type: 'Maintain', booker_id: @maintain.id })

