require 'spec_helper'

describe UpdatesController do

  describe "GET 'posts'" do
    it "returns http success" do
      get 'posts'
      response.should be_success
    end
  end

end
