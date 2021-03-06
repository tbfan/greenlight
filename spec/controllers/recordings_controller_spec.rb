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

require "rails_helper"

describe RecordingsController, type: :controller do
  before do
    @user = create(:user)
    @room = @user.main_room
    @secondary_user = create(:user)
  end

  context "POST #update_recording" do
    it "updates the recordings details" do
      @request.session[:user_id] = @user.uid

      post :update_recording, params: { meetingID: @room.bbb_id, record_id: Faker::IDNumber.valid, state: "public" }

      expect(response).to have_http_status(302)
    end

    it "redirects to root if not the room owner" do
      @request.session[:user_id] = @secondary_user.uid

      post :update_recording, params: { meetingID: @room.bbb_id, record_id: Faker::IDNumber.valid, state: "public" }

      expect(response).to redirect_to(root_path)
    end
  end

  context "DELETE #delete_recording" do
    it "deletes the recording" do
      @request.session[:user_id] = @user.uid

      post :delete_recording, params: { meetingID: @room.bbb_id, record_id: Faker::IDNumber.valid, state: "public" }

      expect(response).to have_http_status(302)
    end

    it "redirects to root if not the room owner" do
      @request.session[:user_id] = @secondary_user.uid

      post :delete_recording, params: { meetingID: @room.bbb_id, record_id: Faker::IDNumber.valid, state: "public" }

      expect(response).to redirect_to(root_path)
    end
  end
end
