package be.wellconsidered.apis.nlbridge.data
{
	public class OSUser
	{
		public var id:String = "";
		public var isViewer:Boolean = false;
		public var isOwner:Boolean = false;;
		public var thumbnailUrl:String = "";
		public var profileUrl:String = "";
		public var displayName:String = "";
		public var familyName:String = "";
		public var givenName:String = "";		
		public var formatted:String = "";		
		public var unstructured:String = "";		
		public var gender:String = "";		
		
		public function OSUser(oUser:Object = null)
		{
			if(oUser != null) { 
				for(var i:String in oUser.fields_) { 
					try { this[i] = oUser.fields_[i];
					} catch (err:Error){ trace(i + " does not exists (user)");  }
				} 
				
				// NAME
				for(var j:String in oUser.fields_.name.fields_) { 
					try { this[j] = oUser.fields_.name.fields_[j];
					} catch (err:Error){ trace(j + " does not exists (name)");  }
				}
				
				// GENDER
				try { gender = oUser.fields_.gender.key;
					} catch (err:Error){ trace("gender error (" + oUser.fields_.gender + ")");  }
			}
		}
	}
}