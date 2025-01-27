#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2023 the OpenProject GmbH
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

require "spec_helper"
require_relative "../shared_context"

RSpec.describe "Edit project custom fields on project overview page", :js do
  include_context "with seeded projects, members and project custom fields"

  let(:overview_page) { Pages::Projects::Show.new(project) }

  describe "with insufficient permissions" do
    # turboframe sidebar request is covered by a controller spec checking for 403
    # async dialog content request is be covered by a controller spec checking for 403
    # via spec/permissions/manage_project_custom_values_spec.rb
    before do
      login_as member_without_project_edit_permissions
      overview_page.visit_page
    end

    it "does not show the edit buttons" do
      overview_page.within_async_loaded_sidebar do
        expect(page).to have_no_css("[data-test-selector='project-custom-field-section-edit-button']")
      end
    end
  end

  describe "with sufficient permissions" do
    before do
      login_as member_with_project_edit_permissions
      overview_page.visit_page
    end

    it "shows the edit buttons" do
      overview_page.within_async_loaded_sidebar do
        expect(page).to have_css("[data-test-selector='project-custom-field-section-edit-button']", count: 3)
      end
    end
  end
end
