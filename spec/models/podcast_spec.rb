require 'rails_helper'

RSpec.describe Podcast, :type => :model do
  before do
    @podcast = create(:podcast)
  end

  # instance methods
  it 'path' do
    expect(@podcast.path).to eq("public/podcasts/#{@podcast.id}.md")
  end

  describe 'exists?(offset: 0)' do
    it '\u0000 を含む ⇒ false' do
      allow(@podcast).to receive(:path) { "public/podcasts/\u0000" }

      expect(@podcast.exists?).to eq(false)
    end

    context 'offset 省略' do
      before :each do
        allow(File).to receive(:exists?) { false }
      end

      it 'ファイルあり ⇒ true' do
        allow(File).to receive(:exists?).with("public/podcasts/#{@podcast.id}.md") { true }

        expect(@podcast.exists?).to eq(true)
      end

      it 'ファイルなし ⇒ false' do
        expect(@podcast.exists?).to eq(false)
      end
    end

    context 'offset 指定' do
      before :each do
        allow(File).to receive(:exists?) { false }
      end

      it 'ファイルあり ⇒ true' do
        allow(File).to receive(:exists?).with("public/podcasts/#{@podcast.id + 1}.md") { true }

        expect(@podcast.exists?(offset: 1)).to eq(true)
      end

      it 'ファイルなし ⇒ false' do
        expect(@podcast.exists?(offset: 1)).to eq(false)
      end
    end
  end

  describe 'content' do
    before :each do
      @content_body = "Podcast Title\n収録日: 2019/05/10\n概要説明..."
      allow(File).to receive(:read) { @content_body }
    end

    it 'ファイル存在 ⇒ ファイルから読み込み' do
      allow(@podcast).to receive(:exists?) { true }

      expect(@podcast.content).to eq(@content_body)
    end

    it 'ファイルなし ⇒ 空文字列' do
      allow(@podcast).to receive(:exists?) { false }

      expect(@podcast.content).to eq('')
    end
  end
end
