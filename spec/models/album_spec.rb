require 'rails_helper'

describe Album, :type => :model do  
  context "associations" do
    it { should have_and_belong_to_many(:artists) }
    it { should have_and_belong_to_many(:genres) }
    it { should have_and_belong_to_many(:styles) }
  end

  context "validations" do
    let(:valid_attrs) { FactoryBot.attributes_for(:album) }
    let(:no_name_attrs) { FactoryBot.attributes_for(:album, name: nil) }
    let(:no_added_at_attrs) { FactoryBot.attributes_for(:album, added_at: nil) }
    let(:no_id_attrs) { FactoryBot.attributes_for(:album, spotify_id: nil, discogs_id: nil) }

    it "is valid with valid attributes" do
      expect(Album.new(valid_attrs)).to be_valid
    end

    it "is not valid without a name" do
      expect(Album.new(no_name_attrs)).to_not be_valid
    end

    it "is not valid without added_at" do
      expect(Album.new(no_added_at_attrs)).to_not be_valid
    end

    it "is not valid without at least a discogs or spotify id" do
      expect(Album.new(no_id_attrs)).to_not be_valid
    end
  end

  context "before_destroy" do
    subject(:call) { album.destroy }
    
    context "with artists, genres and styles that do not have other albums" do
      let(:album) { FactoryBot.create(:album) }

      it 'deletes the album, artists, genres and styles' do
        expect { call }.to change(Album, :count).by(-1)
        .and change(Artist, :count).by(-album.artists.length)
        .and change(Genre, :count).by(-album.genres.length)
        .and change(Style, :count).by(-album.styles.length)
      end
    end

    context "with artists that do have other albums" do
      let(:album_with_same_artists) { FactoryBot.create(:album) }
      let(:album) { FactoryBot.create(:album, artists_count: 2) }

      before { album.artists << album_with_same_artists.artists }
     
      it 'deletes the album, and artists without other album' do
        expect { call }.to change(Album, :count).by(-1)
          .and change(Artist, :count).by(-2)
      end

      it 'does not delete artists with other albums' do
        call
        album_with_same_artists.artists.each do |artist|
          expect(Artist.exists?(artist.id)).to be true
        end
      end
    end

    context "with genres that do have other albums" do
      let(:album_with_same_genres) { FactoryBot.create(:album) }
      let(:album) { FactoryBot.create(:album, genres_count: 2) }

      before { album.genres << album_with_same_genres.genres }

      it 'deletes the album, and genres without other album' do
        expect { call }.to change(Album, :count).by(-1)
          .and change(Genre, :count).by(-2)
      end

      it 'deletes genre without other album' do
        call
        album_with_same_genres.genres.each do |genre|
          expect(Genre.exists?(genre.id)).to be true
        end
      end
    end

    context "with styles that do have other albums" do
      let(:album_with_same_styles) { FactoryBot.create(:album) }
      let(:album) { FactoryBot.create(:album, styles_count: 2) }

      before { album.styles << album_with_same_styles.styles }

      it 'deletes the album, and styles without other album' do
        expect { call }.to change(Album, :count).by(-1)
          .and change(Style, :count).by(-2)
      end

      it 'deletes style without other album' do
        call
        album_with_same_styles.styles.each do |style|
          expect(Style.exists?(style.id)).to be true
        end
      end
    end
  end
end