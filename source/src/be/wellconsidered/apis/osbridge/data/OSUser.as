package be.wellconsidered.apis.osbridge.data
{
	public class OSUser
	{
		public var id:String = "";
		public var isViewer:Boolean = false;
		public var isOwner:Boolean = false;;
		public var thumbnailUrl:String = "";
		public var nickname:String = "";
		public var profileUrl:String = "";
		public var displayName:String = "";
		public var familyName:String = "";
		public var givenName:String = "";		
		public var formatted:String = "";		
		public var unstructured:String = "";		
		public var gender:String = "";		
		
		public function OSUser(oUser:Object = null)
		{
			var oFields:Object = oUser.name ? oUser : oUser.fields_;
			var errors:String = "";
			
			for(var i:String in oFields) { 
				try { 
					this[i] = oFields[i];
				} 
				catch (err:Error){ errors += "OSUser: " + i + " does not exists (user) ";  }
			} 
			
			// NAME
			if(oFields.name && oFields.name.fields_) {
				for(var j:String in oFields.name.fields_) { 
					try { 
						this[j] = oFields.name.fields_[j];
					} 
					catch (err:Error){ errors += "OSUser: " + j + " does not exists (name) ";  }
				}
			}
			
			// GENDER
			try { 
				gender = oFields.gender.key;
			} 
			catch (err:Error){ errors += "OSUser: " + "gender error (" + oFields.gender + ") ";  }
			
			// inspect(oUser, " > ");
			
			trace(errors);
		}
		
		public function inspect(o:*, s:String):void {
			for(var i:String in o) {
				trace("OSUser: " + s + " " + i + " - " + o[i]);
				
				inspect(o[i], s + " > ");
			}
		}
	}
}