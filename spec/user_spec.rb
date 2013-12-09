require 'spec_helper'
require_relative "../spec/lib/user.rb"
require_relative "../spec/lib/user2.rb"

describe User do

  describe ".simple_search_attriutes" do

    it "retuns exception if simple_search_attributes is not called while initializing the model" do
      expect { User2.simple_search('usa') }.to raise_error(RubySimpleSearch::Error::ATTRIBUTES_MISSING)
    end

    it "sets simple_search_attriutes" do
      User2.simple_search_attributes :name, :contact
      expect(User2.instance_variable_get("@simple_search_attributes")).to eq([:name, :contact])
    end

    it "has default pattern" do
      User2.simple_search_attributes :name, :contact
      expect(User2.instance_variable_get("@simple_search_pattern")).to eq('%q%')
    end

    it "can have patterns like plain, begining, ending, containing and underscore" do
      User2.simple_search_attributes :name, :contact, :pattern => :plain
      expect(User2.instance_variable_get("@simple_search_pattern")).to eq('q')
      User2.simple_search_attributes :name, :contact, :pattern => :beginning
      expect(User2.instance_variable_get("@simple_search_pattern")).to eq('q%')
      User2.simple_search_attributes :name, :contact, :pattern => :ending
      expect(User2.instance_variable_get("@simple_search_pattern")).to eq('%q')
      User2.simple_search_attributes :name, :contact, :pattern => :containing
      expect(User2.instance_variable_get("@simple_search_pattern")).to eq('%q%')
      User2.simple_search_attributes :name, :contact, :pattern => :underscore
      expect(User2.instance_variable_get("@simple_search_pattern")).to eq('_q_')
    end

    it "searches the records with begining pattern" do
      users = User.where("name like ?", 'bo%')
      User.simple_search_attributes :name, :contact, :address, :pattern => :beginning
      searched_users = User.simple_search('bo')
      expect(users.count).to eq(searched_users.count)
    end

    it "searches the records with ending pattern" do
      users = User.where("name like ?", '%ce')
      User.simple_search_attributes :name, :contact, :address, :pattern => :ending
      searched_users = User.simple_search('ce')
      expect(users.count).to eq(searched_users.count)
    end

  end

  describe ".simple_search" do
    it "searches user whose name is 'alice'" do
      user = User.find_by_name('alice')
      users = User.simple_search('alice')
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
  end

  describe ".simple_search extendable" do

    it "returns users who lives in usa and their age shoule be greater than 50" do
      users = User.where(:age => 60)
      searched_users = User.simple_search('usa') do |search_term|
        ['and age > ?', 50]
      end
      expect(users.to_a).to eq(searched_users.to_a)
    end

    it "returns exception if return parameters of array are wrong in simple_search block" do
      expect{ User.simple_search('usa') do |search_term|
        ['and age > ?', 50, 60]
      end }.to raise_error(RubySimpleSearch::Error::INVALID_PARAMETERS)
    end

    it "returns exception if return value is not an array type" do
      expect{ User.simple_search('usa') do |search_term|
        "Wrong return"
      end }.to raise_error(RubySimpleSearch::Error::INVALID_TYPE)
    end

  end

end
