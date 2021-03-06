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
      tile = @map.tile(Tile.first.id)
      expect(tile).to be_a(Tile)
    end

    it "generates a 2d tiles array" do
      @map.tiles.each do |row|
        row.each do |tile|
          expect(tile).to be_a(Tile)
        end
      end
    end

    it "generates a map of player locations" do
      map = Map.create_blank
      player_1 = map.players.create(x_pos: 1, y_pos: 1)
      player_2 = map.players.create(x_pos: 2, y_pos: 2)

      players_map = map.players_map
      expect(players_map[1][1]).to eq(player_1)
      expect(players_map[2][2]).to eq(player_2)
    end
  end

  context "using map modifiers" do
    before :each do
      @map = Map.create_blank(name: "Map", tile: Tile.first)
    end

    it "creates a wall around the edge of the map" do
      expect(@map.map.first.first).to be(Tile.first.id)
      expect(@map.map.last.last).to be(Tile.first.id)
      @map.wall(tile: Tile.last)
      expect(@map.map.first.first).to be(Tile.last.id)
      expect(@map.map.last.last).to be(Tile.last.id)
    end

    it "identifies whether a tile is walkable" do
      @map.wall(tile: Tile.not_passable.last)
      expect(@map.passable?(0, 0)).to be(false)
    end
  end

  describe "validates" do
    before :each do
      @map = Map.create
    end

    it "validates presence of name" do
      expect(@map.errors[:name]).to include("can't be blank")
    end

    it "validates presence of map" do
      expect(@map.errors[:map]).to include("can't be blank")
    end

    it "validates that map is an array of arrays" do
      @map.map = Array.new(10) { 10 }
      @map.save
      expect(@map.errors[:map]).to include("must be a 2d array")
    end

    it "validates that each row is the same length" do
      @map.map = Array.new(2)
      @map.map[0] = Array.new(1)
      @map.map[1] = Array.new(2)
      @map.save
      expect(@map.errors[:map]).to include("must be a 2d array")
    end
  end
end
