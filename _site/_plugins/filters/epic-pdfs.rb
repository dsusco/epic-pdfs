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

    def weapon_arc(w, m)
      w['arc'] if w['arc'] and not %w((bc) (15cm)).include?(m['range'])
    end

    def weapon_name(weapon, w, m)
      if m['boolean']
        content_tag(:div, m['boolean'], { class: '_boolean' })
      else
        content_tag(:div, "#{"#{w['multiplier']}× " if w['multiplier'] }#{weapon['name']}")
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::EpicPdfsFilters)
