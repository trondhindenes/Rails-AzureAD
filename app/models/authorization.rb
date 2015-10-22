class Authorization < ActiveRecord::Base
	belongs_to :user
	validates :provider, :uid, :presence => true
    
    def self.find_or_create(auth_hash)
      unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
        #the raw_info object contains all claims coming from Azure AD
        user = User.create :name => auth_hash["extra"]["raw_info"]["http://schemas.microsoft.com/identity/claims/displayname"], :email => auth_hash["extra"]["raw_info"]["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"]
        auth = create :user => user, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      end
      auth
    end
end
