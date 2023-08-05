require "rails_helper"

RSpec.describe MotorcyclesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/motorcycles").to route_to("motorcycles#index")
    end

    it "routes to #show" do
      expect(get: "/motorcycles/1").to route_to("motorcycles#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/motorcycles").to route_to("motorcycles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/motorcycles/1").to route_to("motorcycles#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/motorcycles/1").to route_to("motorcycles#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/motorcycles/1").to route_to("motorcycles#destroy", id: "1")
    end
  end
end
