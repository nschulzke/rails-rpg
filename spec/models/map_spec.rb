require 'rails_helper'

RSpec.describe Map, type: :model do
  context "with a blank map" do
    before :each do
      @map = Map.create_blank(name: "Map", tile: Tile.first)
    end

    it "stores as a 2d integer array" do
      @map.map.each do |row|
        row.each do |tile|
          expect(tile).to be_an(Integer)
        end
      end
    end

    it "allows lookup of tiles by id" do
      expect(@map.tile(Tile.first.id)).to be_a(Tile)
    end

    it "generates a 2d tiles array" do
      @map.tiles.each do |row|
        row.each do |tile|
          expect(tile).to be_a(Tile)
        end
      end
    end
  end
end