require 'rails_com'
module RailsCrm
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/material"
    ]
    config.eager_load_paths += Dir[
      "#{config.root}/app/models/material"
    ]

    config.generators do |g|
      g.resource_route false
      g.templates.unshift File.expand_path('lib/templates', RailsCom::Engine.root)
    end

  end
end
