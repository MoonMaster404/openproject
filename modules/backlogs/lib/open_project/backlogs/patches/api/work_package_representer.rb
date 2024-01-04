#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2024 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

module OpenProject::Backlogs
  module Patches
    module API
      module WorkPackageRepresenter
        module_function

        # rubocop:disable Metrics/AbcSize
        def extension
          ->(*) do
            property :position,
                     render_nil: true,
                     skip_render: ->(*) do
                       !(backlogs_enabled? && type && type.passes_attribute_constraint?(:position))
                     end

            property :story_points,
                     render_nil: true,
                     skip_render: ->(*) do
                       !(backlogs_enabled? && type && type.passes_attribute_constraint?(:story_points))
                     end

            property :remaining_time,
                     exec_context: :decorator,
                     render_nil: true,
                     skip_render: ->(represented:, **) { !represented.backlogs_enabled? },
                     getter: ->(*) do
                       datetime_formatter.format_duration_from_hours(represented.remaining_hours, allow_nil: true)
                     end

            property :derived_remaining_time,
                     exec_context: :decorator,
                     render_nil: true,
                     skip_render: ->(represented:, **) { !represented.backlogs_enabled? },
                     getter: ->(*) do
                       datetime_formatter.format_duration_from_hours(represented.derived_remaining_hours, allow_nil: true)
                     end

            # cannot use def here as it wouldn't define the method on the representer
            define_method :remaining_time= do |value|
              represented.remaining_hours = datetime_formatter
                                              .parse_duration_to_hours(value, 'remainingTime', allow_nil: true)
            end

            define_method :derived_remaining_time= do |value|
              represented.derived_remaining_hours = datetime_formatter
                                                      .parse_duration_to_hours(value, 'derivedRemainingTime', allow_nil: true)
            end
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
