# frozen_string_literal: true

# BigBlueButton open source conferencing system - http://www.bigbluebutton.org/.
#
# Copyright (c) 2018 BigBlueButton Inc. and by respective authors (see below).
#
# This program is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 3.0 of the License, or (at your option) any later
# version.
#
# BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.

class AdminsController < ApplicationController
  authorize_resource class: false
  before_action :find_user, except: :index
  before_action :verify_admin_of_user, except: :index

  # GET /admins
  def index
    @users = User.all.reverse_order
  end

  # GET /admins/edit/:user_uid
  def edit_user
    render "admins/index", locals: { setting_id: "account" }
  end

  # POST /admins/promote/:user_uid
  def promote
    @user.add_role :admin
    redirect_to admins_path, flash: { success: I18n.t("administrator.flash.promoted") }
  end

  # POST /admins/demote/:user_uid
  def demote
    @user.remove_role :admin
    redirect_to admins_path, flash: { success: I18n.t("administrator.flash.demoted") }
  end

  private

  def find_user
    @user = User.find_by!(uid: params[:user_uid])
  end

  def verify_admin_of_user
    redirect_to admins_path,
      flash: { alert: I18n.t("administrator.flash.unauthorized") } unless current_user.admin_of?(@user)
  end
end
