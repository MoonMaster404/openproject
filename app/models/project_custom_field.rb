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

class ProjectCustomField < CustomField
  belongs_to :project_custom_field_section, class_name: 'ProjectCustomFieldSection', foreign_key: :custom_field_section_id
  has_many :project_custom_field_project_mappings, class_name: 'ProjectCustomFieldProjectMapping', foreign_key: :custom_field_id,
                                                   dependent: :destroy, inverse_of: :project_custom_field

  acts_as_list column: :position_in_custom_field_section, scope: [:custom_field_section_id]

  # after_create :activate_in_all_projects

  def type_name
    :label_project_plural
  end

  def self.visible(user = User.current)
    if user.admin?
      all
    else
      where(visible: true)
    end
  end

  # TODO: check if custom field is set to be activated in all projects in creation form
  # def activate_in_all_projects
  #   mappings = Project.active.map { |project| { project_id: project.id, custom_field_id: id } }
  #   ProjectCustomFieldProjectMapping.create!(mappings)
  # end
end
