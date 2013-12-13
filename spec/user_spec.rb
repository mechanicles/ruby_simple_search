require 'spec_helper'
require_relative "../spec/lib/user.rb"
require_relative "../spec/lib/user2.rb"

describe User do

  describe ".simple_search_attributes" do

    it "returns an exception if simple_search_attributes is not called while loading the model" do
      expect { User2.simple_search('usa') }.to raise_error(RubySimpleSearch::Error::ATTRIBUTES_MISSING)
    end

    it "sets simple_search_attributes" do
      User2.simple_search_attributes :name, :contact
      expect(User2.instance_variable_get("@simple_search_attributes")).to eq([:name, :contact])
    end

  end

  describe ".simple_search" do
    context "Simple" do
      it "searches users whose name are 'alice'" do
        user = User.find_by_name('alice')
        users = User.simple_search('alice')
        users.should include(user)
      end

      it "has default pattern" do
        User.find_by_name('alice')
        expect(User.instance_variable_get("@simple_search_pattern")).to eq('%q%')
      end

      it "can have patterns like plain, beginning, ending, containing and underscore" do
        User.simple_search('alice', pattern: :plain)
        expect(User.instance_variable_get("@simple_search_pattern")).to eq('q')
        User.simple_search('al', pattern: :beginning)
        expect(User.instance_variable_get("@simple_search_pattern")).to eq('q%')
        User.simple_search('alice', pattern: :ending)
        expect(User.instance_variable_get("@simple_search_pattern")).to eq('%q')
        User.simple_search('alice', pattern: :containing)
        expect(User.instance_variable_get("@simple_search_pattern")).to eq('%q%')
        User.simple_search('alice', pattern: :underscore)
        expect(User.instance_variable_get("@simple_search_pattern")).to eq('_q_')
      end

      it "should raise an exception if pattern is wrong" do
        expect{ User.simple_search('alice', pattern: 'wrong') }.to raise_error(RubySimpleSearch::Error::INVALID_PATTERN)
      end

      it "searches users whose name are 'alice' with beginning pattern" do
        user = User.find_by_name('alice')
        users = User.simple_search('al', { pattern: :beginning })
        users.should include(user)
      end

      it "returns empty records if contact number does not exist" do
        users = User.simple_search('343434')
        users.should be_empty
      end

      it "searches user records if user belongs to 'USA'" do
        users = User.where(:address => 'usa')
        searched_users = User.simple_search('usa')
        expect(users.to_a).to eq(searched_users.to_a)
      end

      it "searches the records with beginning pattern" do
        users = User.where("name like ?", 'bo%')
        User.simple_search_attributes :name, :contact, :address
        searched_users = User.simple_search('bo', pattern: :beginning)
        expect(users.count).to eq(searched_users.count)
      end

      it "searches the records with ending pattern" do
        users = User.where("name like ?", '%ce')
        User.simple_search_attributes :name, :contact, :address
        searched_users = User.simple_search('ce', pattern: :ending)
        expect(users.count).to eq(searched_users.count)
      end

      it "searches the records with underscore pattern" do
        users = User.where("name like ?", 'ce')
        User.simple_search_attributes :name, :contact, :address
        searched_users = User.simple_search('ce', pattern: :underscore)
        expect(users.count).to eq(searched_users.count)
      end

      it "searches the records with plain pattern" do
        users = User.where("name like ?", 'bob')
        User.simple_search_attributes :name, :contact, :address
        searched_users = User.simple_search('bob', pattern: :plain)
        expect(users.count).to eq(searched_users.count)
      end
    end

    context "Extendable" do
      it "returns users who live in usa and their age shoule be greater than 50" do
        User.simple_search_attributes :name, :contact, :address
        users = User.where(:age => 60)
        searched_users = User.simple_search('usa', pattern: :plain) do |search_term|
          ['AND age > ?', 50]
        end
        expect(users.to_a).to eq(searched_users.to_a)
      end

      it "returns exception if array condition is wrong in simple_search block" do
        expect{ User.simple_search('usa') do |search_term|
          ['AND age > ?', 50, 60]
        end }.to raise_error(RubySimpleSearch::Error::INVALID_CONDITION)
      end

      it "returns exception if return value is not an array type" do
        expect{ User.simple_search('usa') do |search_term|
          "Wrong return"
        end }.to raise_error(RubySimpleSearch::Error::INVALID_TYPE)
      end
    end
  end
end
