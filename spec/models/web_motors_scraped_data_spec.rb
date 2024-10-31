require 'rails_helper'

RSpec.describe WebMotorsScrapedData, type: :model do
  subject {
    described_class.new(
      brand: "Ferrari",
      model: "F50",
      price: 1000000.00
    )
  }

  context "all valid parameters" do
    it "valid scraped data" do
      expect(subject).to be_valid
    end
  end

  context "null brand" do
    it "not valid scraped data" do
      subject.brand = nil
      expect(subject).to_not be_valid
    end
  end

  context "empty brand" do
    it "not valid scraped data" do
      subject.brand = ""
      expect(subject).to_not be_valid
    end
  end

  context "null model" do
    it "not valid scraped data" do
      subject.model = nil
      expect(subject).to_not be_valid
    end
  end

  context "empty model" do
    it "not valid scraped data" do
      subject.model = ""
      expect(subject).to_not be_valid
    end
  end

  context "null price" do
    it "not valid scraped data" do
      subject.price = nil
      expect(subject).to_not be_valid
    end
  end

  context "empty price" do
    it "not valid scraped data" do
      subject.price = ""
      expect(subject).to_not be_valid
    end
  end
end
