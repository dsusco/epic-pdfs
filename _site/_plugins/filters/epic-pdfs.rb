require 'action_view'
require 'active_support/core_ext/array'
require 'active_support/core_ext/string'

module Jekyll
  module EpicPdfsFilters
    include ActionView::Helpers::TagHelper

    def force_list(forces)
      forces.map { |f|
        force = @context.registers[:site].data['forces'][f]
        content_tag(:a, "the #{ force.data['name'] } Forces section", { href: "##{force.data['slug'].underscore}_forces" })
      }.to_sentence()
    end
  end
end

Liquid::Template.register_filter(Jekyll::EpicPdfsFilters)
